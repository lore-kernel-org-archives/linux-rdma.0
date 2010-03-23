From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 10/22] [for 2.6.36] rdma/cm: add support for AF_IB to cma_get_service_id
Date: Tue, 23 Mar 2010 11:07:16 -0700
Message-ID: <29BFB07581C9453EABFB24BED70B0B39@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
index c7b6912..326bda6 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1259,6 +1259,9 @@ out:
 
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
