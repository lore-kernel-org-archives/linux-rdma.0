From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/26] rdma/cm: Allow user to specify AF_IB when binding
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <FAE7751BA28B43A5934ADF965B56BB1D@amr.corp.intel.com>
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

Modify rdma_bind_addr to allow the user to specify AF_IB when
binding to a device.  AF_IB indicates that the user is not
mapping an IP address to the native IB addressing.  (The mapping
may have already been done, or is not needed.)

AF_IB is restricted to the RDMA_PS_IB port space.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 84909b9..b724eac 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -320,6 +320,13 @@ static int cma_set_qkey(struct rdma_id_private *id_priv)
 	return ret;
 }
 
+static void cma_translate_ib(struct sockaddr_ib *addr, struct rdma_dev_addr *dev_addr)
+{
+	dev_addr->dev_type = ARPHRD_INFINIBAND;
+	rdma_addr_set_sgid(dev_addr, (union ib_gid *) &addr->sib_addr);
+	ib_addr_set_pkey(dev_addr, ntohs(addr->sib_pkey));
+}
+
 static int cma_acquire_dev(struct rdma_id_private *id_priv)
 {
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
@@ -2177,7 +2184,9 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	struct rdma_id_private *id_priv;
 	int ret;
 
-	if (addr->sa_family != AF_INET && addr->sa_family != AF_INET6)
+	if ((addr->sa_family != AF_INET && addr->sa_family != AF_INET6 &&
+	    addr->sa_family != AF_IB) ||
+	    (addr->sa_family == AF_IB && id->ps != RDMA_PS_IB))
 		return -EAFNOSUPPORT;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
@@ -2189,9 +2198,14 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 		goto err1;
 
 	if (!cma_any_addr(addr)) {
-		ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
-		if (ret)
-			goto err1;
+		if (addr->sa_family == AF_IB) {
+			cma_translate_ib((struct sockaddr_ib *) addr,
+					 &id->route.addr.dev_addr);
+		} else {
+			ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
+			if (ret)
+				goto err1;
+		}
 
 		mutex_lock(&lock);
 		ret = cma_acquire_dev(id_priv);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
