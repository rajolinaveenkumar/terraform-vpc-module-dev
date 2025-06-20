# What is AWS ALB (Application Load Balancer)?
* ALB is a Layer 7 (HTTP/HTTPS) Load Balancer that automatically distributes incoming application traffic - - across multiple targets like:
    - EC2 instances
    - Containers (ECS, EKS)
    - Lambda functions
    - IP addresses

It is smart and content-aware — meaning it understands URLs, headers, and cookies.

### Where is ALB used?
You use ALB when you want to:

- Balance traffic between web servers

- Host multiple apps on same domain (path-based routing)

Handle HTTPS traffic securely

Do blue-green or canary deployments (target groups)

Monitor traffic using CloudWatch

📦 Key ALB Components
1. Load Balancer
The main ALB resource, public or internal.

Exposes a DNS name to receive traffic (e.g. my-app-alb-123456.ap-south-1.elb.amazonaws.com).

2. Listeners
Listens on a port (usually 80 or 443).

Routes traffic to target groups based on rules.

Example: