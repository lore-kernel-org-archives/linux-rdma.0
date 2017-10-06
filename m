From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 03/47] RDMA/cma: Avoid triggering undefined behavior
Date: Fri,  6 Oct 2017 14:32:49 -0700
Message-ID: <20171006213333.6721-4-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

According to the C standard the behavior of computations with
integer operands is as follows:
* A computation involving unsigned operands can never overflow,
  because a result that cannot be represented by the resulting
  unsigned integer type is reduced modulo the number that is one
  greater than the largest value that can be represented by the
  resulting type.
* The behavior for signed integer underflow and overflow is
  undefined.

Hence only use unsigned integers when checking for integer
overflow.

This patch is what I came up with after having analyzed the
following smatch warnings:

drivers/infiniband/core/cma.c:3448: cma_resolve_ib_udp() warn: signed overflow undefined. 'offset + conn_param->private_data_len < conn_param->private_data_len'
drivers/infiniband/core/cma.c:3505: cma_connect_ib() warn: signed overflow undefined. 'offset + conn_param->private_data_len < conn_param->private_data_len'

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 852c8fec8088..fa79c7076ccd 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1540,7 +1540,7 @@ static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
 	return id_priv;
 }
 
-static inline int cma_user_data_offset(struct rdma_id_private *id_priv)
+static inline u8 cma_user_data_offset(struct rdma_id_private *id_priv)
 {
 	return cma_family(id_priv) == AF_IB ? 0 : sizeof(struct cma_hdr);
 }
@@ -1942,7 +1942,8 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	struct rdma_id_private *listen_id, *conn_id = NULL;
 	struct rdma_cm_event event;
 	struct net_device *net_dev;
-	int offset, ret;
+	u8 offset;
+	int ret;
 
 	listen_id = cma_id_from_event(cm_id, ib_event, &net_dev);
 	if (IS_ERR(listen_id))
@@ -3440,7 +3441,8 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 	struct ib_cm_sidr_req_param req;
 	struct ib_cm_id	*id;
 	void *private_data;
-	int offset, ret;
+	u8 offset;
+	int ret;
 
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
@@ -3497,7 +3499,8 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	struct rdma_route *route;
 	void *private_data;
 	struct ib_cm_id	*id;
-	int offset, ret;
+	u8 offset;
+	int ret;
 
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
