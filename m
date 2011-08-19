From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/20 v2] rdma/cm: Define new RDMA port space specific for IB
Date: Fri, 19 Aug 2011 02:14:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A50@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add RDMA_PS_IB.  XRC QP types will use the IB port space
when operating over the RDMA CM.  For the 'IP protocol'
field value, we select 0x3F, which is listed as being for
'any local network'.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    5 +++++
 include/rdma/rdma_cm.h        |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b6a33b3..9f1d44d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -81,6 +81,7 @@ static DEFINE_IDR(sdp_ps);
 static DEFINE_IDR(tcp_ps);
 static DEFINE_IDR(udp_ps);
 static DEFINE_IDR(ipoib_ps);
+static DEFINE_IDR(ib_ps);
 
 struct cma_device {
 	struct list_head	list;
@@ -2231,6 +2232,9 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	case RDMA_PS_IPOIB:
 		ps = &ipoib_ps;
 		break;
+	case RDMA_PS_IB:
+		ps = &ib_ps;
+		break;
 	default:
 		return -EPROTONOSUPPORT;
 	}
@@ -3456,6 +3460,7 @@ static void __exit cma_cleanup(void)
 	idr_destroy(&tcp_ps);
 	idr_destroy(&udp_ps);
 	idr_destroy(&ipoib_ps);
+	idr_destroy(&ib_ps);
 }
 
 module_init(cma_init);
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 26977c1..51988f8 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -65,6 +65,7 @@ enum rdma_cm_event_type {
 enum rdma_port_space {
 	RDMA_PS_SDP   = 0x0001,
 	RDMA_PS_IPOIB = 0x0002,
+	RDMA_PS_IB    = 0x013F,
 	RDMA_PS_TCP   = 0x0106,
 	RDMA_PS_UDP   = 0x0111,
 };


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
