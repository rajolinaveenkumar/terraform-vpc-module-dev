# What is AWS ALB (Application Load Balancer)?
* ALB is a Layer 7 (HTTP/HTTPS) Load Balancer that automatically distributes incoming application traffic - - across multiple targets like:
    - EC2 instances
    - Containers (ECS, EKS)
    - Lambda functions
    - IP addresses

It is smart and content-aware — meaning it understands URLs, headers, and cookies.

**OR**
* ALB stands for Application Load Balancer, a Layer 7 load balancer in AWS that:
    * Distributes HTTP/HTTPS traffic across multiple targets (EC2, ECS, Lambda)
    * Understands application-level data like paths, headers, cookies
    * Supports routing rules, SSL termination, sticky sessions, etc.


### Where is ALB used?
You use ALB when you want to:

- Balance traffic between web servers
- Host multiple apps on same domain (path-based routing)
- Handle HTTPS traffic securely
- Do blue-green or canary deployments (target groups)
- Monitor traffic using CloudWatch

### Key ALB Components
**1. Load Balancer**
- The main ALB resource, public or internal.
- Exposes a DNS name to receive traffic (e.g. my-app-alb-123456.ap-south-1.elb.amazonaws.com).

**2. Listeners**
- Listens on a port (usually 80 or 443).
- Routes traffic to target groups based on rules.
Example:
```
Port 80 —> Target Group A
Port 443 —> Target Group B (HTTPS)
```
**3. Listener Rules**
* Defines how to forward traffic:
    - Path-based (e.g., /api/* goes to backend)
    - Host-based (e.g., admin.example.com goes to admin app)

**4. Target Groups**
* Group of resources ALB forwards requests to.
* Can contain:
        - EC2 instances
        - ECS services
        - Lambda functions
        - IPs
    Health checks are configured here.

**5. Health Checks**
* ALB continuously checks targets’ health:
    - If healthy → sends traffic
    - If unhealthy → skips that instance
* You define:
    - Protocol (HTTP/HTTPS)
    - Path (e.g. /health)
    - Port

**🔐 ALB Security**
ALB is placed in public subnets (with internet access).

Backend EC2s usually in private subnets.

Use Security Groups to control who can access ALB and what it can access.

🧪 Health Checks
ALB continuously checks targets’ health:

If healthy → sends traffic

If unhealthy → skips that instance

You define:

Protocol (HTTP/HTTPS)

Path (e.g. /health)

Port

📈 ALB Monitoring
Use:

CloudWatch Metrics (requests count, error rates, latency)

Access Logs (store logs in S3)

AWS X-Ray (for tracing)

🛠️ Real-World Use Case
Let's say you’re running a website:

Frontend React app on /

Backend Node.js API on /api

Admin panel on admin.example.com