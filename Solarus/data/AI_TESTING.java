class AI
{
	// Vars
	private PC self;
	private ArrayList<AIState> states;

	public AI(PC self, ArrayList<AIState> states)
	{
		this.self = self;
		this.states = states;
	}
	
	public void update(PC control)
	{
		PC closest = null;
		
		// If the list isn't empty, find the closest enemy
		if (!self.enemyList.isEmpty())
		{
			closest = self.enemyList.get(0);
			float d = dist(closest.pos.x, closest.pos.y, self.pos.x, self.pos.y);
			
			for (PC e : self.enemyList)
			{
				if (dist(e.pos.x, e.pos.y, self.pos.x, self.pos.y) < d)
				{
					closest = e;
					d = dist(e.pos.x, e.pos.y, self.pos.x, self.pos.y);
				}
			}
		}
		
		int indSelect = -1;
		
		// Find the highest priority active state
		for (int i = 0; i < states.size(); i++)
		{
			if (states.get(i).takeControl(self, closest, control))
				indSelect = i;
		}
		
		// Suppress all states
		for (AIState a : states)
			a.suppress();
		
		// Start the new state
		states.get(i).takeAction(self, closest, control);
	}
}

/*
 * Interface for all AIStates to implement.
 */
interface AIState
{
	public boolean isSuppressed();
	public void suppress();
	public boolean takeControl(PC self, PC other, PC control);
	public void takeAction(PC self, PC other, PC control);
}

// STATES //

// STOP
class AIStop implements AIState
{
	private boolean suppress;
	
	public AIStop()
	{
		suppress = false;
	}
	
	public boolean takeControl(PC self, PC other, PC control)
	{
		return true;
	}
	
	public void takeAction(PC self, PC other, PC control)
	{
		suppress = false;
		
		self.accel = new PVector(self.vel.x, self.vel.y);
		self.accel.mult(-self.slow);
		if (self.vel.mag() < 0.1)
			self.vel = new PVector(0,0);
	}
	
	public void suppress() {suppress=true;}
	public boolean isSuppressed() {return suppress;}
}

// WANDER
class AIWander implements AIState
{
	private boolean suppress;
	
	public AIWander()
	{
		suppress = false;
	}
	
	public boolean takeControl(PC self, PC other, PC control)
	{
		// IF the target and the follow is null, don't wander
		if (other == null && control == null)
			return false;
		
		return true;
	}
	
	public boolean takeControl(PC self, PC other, PC control)
	{
		suppress = true;
		
		float d1 = Integer.MAX_VALUE;
		float d2 = Integer.MAX_VALUE;
		
		if (other != null)
			d1 = dist(self.pos.x, self.pos.y, other.pos.x, other.pos.y);
		
		if (control != null)
			d2 = dist(self.pos.x, self.pos.y, control.pos.x, control.pos.y);
		
		// IF enemy
		if (d1 < d2)
		{
			// Finds the vectors representing the distance from self to other
			// and the one representing the self PCs current bearing.
			PVector dis = PVector.sub(other.pos, self.pos);
			PVector ang = PVector.fromAngle(self.getAngle());
			ang.rotate(-PI/2);
			
			boolean tCW = false;
			boolean tCCW = false;
			
			// Check for which direction to turn
			if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
			{
				float dot = (ang.x * -dis.y) + (ang.y * dis.x);
				
				if (dot >= 0)
					tCW = true;
				else
					tCCW = true;
			}
			
			// Start turning in that direction
			if (tCW)
				self.rot(-self.maxRot / frameRate);
			else if (tCCW)
				self.rot(self.maxRot / frameRate);
			
			PVector variance = new PVector(newAccel.x, newAccel.y);
			variance.rotate(PI/2);
			variance.setMag(random(-self.maxAccel, self.maxAccel));
			
			self.accel = variance;
		}
		// If friend
		else
		{
			// Finds the vectors representing the distance from self to control
			// and the one representing the self PCs current bearing.
			PVector dis = PVector.fromAngle(control.getAngle());
			PVector ang = PVector.fromAngle(self.getAngle());
			dis.rotate(-PI/2);
			ang.rotate(-PI/2);
			
			boolean tCW = false;
			boolean tCCW = false;
			
			// Check for which direction to turn
			if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
			{
				float dot = (ang.x * -dis.y) + (ang.y * dis.x);
				
				if (dot >= 0)
					tCW = true;
				else
					tCCW = true;
			}
			
			// Start turning in that direction
			if (tCW)
				self.rot(-self.maxRot / frameRate);
			else if (tCCW)
				self.rot(self.maxRot / frameRate);
			
			// Accelerate towards the target
			PVector newAccel = PVector.fromAngle(self.getAngle());
			newAccel.rotate(-PI/2);
			newAccel.setMag(self.maxAccel);
			
			PVector variance = new PVector(newAccel.x, newAccel.y);
			variance.rotate(PI/2);
			variance.setMag(random(-self.maxAccel, self.maxAccel));
			
			newAccel.add(variance);
			
			self.accel = newAccel;
		}
	}
	
	public void suppress() {suppress=true;}
	public boolean isSuppressed() {return suppress;}
}

// AGGRO
class AIAggro implements AIState
{
	private boolean suppress;
	private float aggroDist, prefDist, closeDist;
	
	AIAggro(float aggroDist, float closeDist, float prefDist)
	{
		suppress = false;
		this.aggroDist = aggroDist;
		this.closeDist = closeDist;
		this.prefDist = prefDist;
	}
	
	public boolean takeControl(PC self, PC other, PC control)
	{
		if (other == null)
			return false;
		
		float d = dist(self.pos.x, self.pos.y, other.pos.x, other.pos.y);
		return (d < aggroDist && d > prefDist) || (d < closeDist);
	}
	
	public void takeAction(PC self, PC other, PC control)
	{
		suppress = false;
		
		// Check for nullity
		if (self != null && other != null)
		{
			// Finds the vectors representing the distance from self to other
			// and the one representing the self PCs current bearing.
			PVector dis = PVector.sub(other.pos, self.pos);
			PVector ang = PVector.fromAngle(self.getAngle());
			ang.rotate(-PI/2);
			
			boolean tCW = false;
			boolean tCCW = false;
			
			// Check for which direction to turn
			if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
			{
				float dot = (ang.x * -dis.y) + (ang.y * dis.x);
				
				if (dot >= 0)
					tCW = true;
				else
					tCCW = true;
			}
			
			// Start turning in that direction
			if (tCW)
				self.rot(-self.maxRot / frameRate);
			else if (tCCW)
				self.rot(self.maxRot / frameRate);
			
			// Accelerate towards the target
			self.accel = PVector.fromAngle(self.getAngle());
			self.accel.rotate(-PI/2);
			self.accel.setMag(self.maxAccel);
			
			// If we want to retreat, accelerate backwards
			if (dis.mag() < closeDist)
				self.accel.mult(-1);
		}
	}
		
	public void suppress() {suppress=true;}
	public boolean isSuppressed() {return suppress;}
}

// ATTACK
class AIAttack implements AIState
{
	private boolean suppress;
	private int chance;
	
	public AIAttack(int chance)
	{
		suppress = false;
		this.chance = chance;
	}
	
	public boolean takeControl(PC self, PC other, PC control)
	{
		// Calculate the angle between the AI and the target
		PVector dis = PVector.sub(other.pos, self.pos);
		PVector ang = PVector.fromAngle(self.getAngle());
		
		float angle = PVector.angleBetween(dis, ang);
		
		return angle < PI/4 && self.projCount < self.projMax && 1 > random(chance);
	}
	
	public void takeAction(PC self, PC other, PC control)
	{
		// Create a projectile and add our velocity to it
		Proj ptmp = parseProj("test.bullet");
		ptmp.originator = self;
		ptmp.targetList = self.enemyList;

		ptmp.pos = new PVector(self.pos.x, self.pos.y);
		ptmp.vel = PVector.fromAngle(self.getAngle()-PI/2);
		ptmp.vel.setMag(ptmp.maxVel);
		
		if (PVector.angleBetween(ptmp.vel, self.vel) < PI/2)
			ptmp.vel.add(self.vel);
		
		// Draw the bullet
		PGraphics im = createGraphics(30, 30);
		im.beginDraw();
		if (self.enemy)
			im.image(enemyP1, 0,0, 30,30);
		else
			im.image(friendP2, 0,0, 30,30);
		im.endDraw();

		ptmp.setImage(im);
		
		// Add the bullet to the PCs list, increase the count
		self.projList.add(ptmp);

		self.projCount++;
	}
	
	public void suppress() {suppress=true;}
	public boolean isSuppressed() {return suppress;}
}

// FOLLOW
class AIFollow implements AIState
{
	private boolean suppress;
	private float followDist, closeDist;
	
	AIFollow(float followDist, float closeDist)
	{
		suppress = false;
		this.followDist = followDist;
		this.closeDist = closeDist;
	}
	
	public boolean takeControl(PC self, PC other, PC control)
	{
		if (control == null)
			return false;
		
		float d = dist(self.pos.x, self.pos.y, control.pos.x, control.pos.y);
		return d > followDist || d < closeDist;
	}
	
	public void takeAction(PC self, PC other, PC control)
	{
		suppress = false;
		
		// Check for nullity
		if (self != null && control != null)
		{
			// Finds the vectors representing the distance from self to control
			// and the one representing the self PCs current bearing.
			PVector dis = PVector.sub(control.pos, self.pos);
			PVector ang = PVector.fromAngle(self.getAngle());
			ang.rotate(-PI/2);
			
			boolean tCW = false;
			boolean tCCW = false;
			
			// Check for which direction to turn
			if (PVector.angleBetween(dis, ang) > PI/self.getRotThresh())
			{
				float dot = (ang.x * -dis.y) + (ang.y * dis.x);
				
				if (dot >= 0)
					tCW = true;
				else
					tCCW = true;
			}
			
			// Start turning in that direction
			if (tCW)
				self.rot(-self.maxRot / frameRate);
			else if (tCCW)
				self.rot(self.maxRot / frameRate);
			
			// Accelerate towards the target
			self.accel = PVector.fromAngle(self.getAngle());
			self.accel.rotate(-PI/2);
			self.accel.setMag(self.maxAccel);
			
			// If we want to retreat, accelerate backwards
			if (dis.mag() < closeDist)
				self.accel.mult(-1);
		}
	}
		
	public void suppress() {suppress=true;}
}



/**
 * @param val The value to check.
 * @param def The default value to return.
 * @return If the value is not -1, return val, otherwise return def.
 */
int check(int val, int def)
{
	if (val != -1)
		return val;
	
	return def;
}