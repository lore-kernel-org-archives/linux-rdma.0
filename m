From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/26] rdma/cm: add support for AF_IB to cma_get_service_id
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <FDC38F513FED4F699910E7FC6D5BDAEB@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

cma_get_service_id forms the service ID based on the port space
and port number of the rdma_cm_id.  Extend the call to support
AF_IB, which contains the service ID directly.  This will
be needed to support any arbitrary SID.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5c956be..cc35872 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1256,6 +1256,9 @@ out:
 
 static __be64 cma_get_service_id(enum rdma_port_space ps, struct sockaddr *addr)
 {
+	if (addr->sa_family == AF_IB)
+		return ((struct sockaddr_ib *) addr)->sib_sid;
+
 	return cpu_to_be64(((u64)ps << 16) + be16_to_cpu(cma_port(addr)));
 }
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
