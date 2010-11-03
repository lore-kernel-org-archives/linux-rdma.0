From: Guanglei Li <liguanglei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ibv_cmd_create_cq failed with ret=c
Date: Wed, 3 Nov 2010 13:41:06 +0800
Message-ID: <AANLkTikDPZkk2FbJRpPj5LLXbDSaYXZsqzzTq5kxdJzR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
  I met an error when trying to run a job on my cluster. I am not sure
if this mailing list is the right place to ask for help.
  My cluster has 248 nodes. Each node is Power7+RedHat6, with 32GB
memory. When I run 13000 tasks across the cluster, I met the following
errors:

PID5b42 ehca0 EHCA_ERR:ehcau_create_cq ibv_cmd_create_cq() failed
ret=c context=0x1001f252ef0 cqe=80
PID5b42 ehca0 EHCA_ERR:ehcau_create_cq An error has occured
context=0x1001f252ef0 cqe=80

  'ret=c' should correspond to ENOMEM. But during the job running, I
found the free memory is around 24GB on each node.

 I found if total task number <=11000, i.e.,  ~40 tasks per node , it
couild succeed.
  Could someone give me hint about the possible reason?

  the /etc/security/limits.conf is:
*               soft    core            unlimited
*               hard    core            unlimited
*               soft    memlock            unlimited
*               hard    memlock            unlimited
*               hard    nofile         65535
*               soft    nofile         65535
*               hard    stack         16000
*               soft    stack         16000
*               soft    nproc           65535
*               hard    nproc           65535

  Thanks in advance for your help.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
