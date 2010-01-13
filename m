From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE Lustre
 port space
Date: Wed, 13 Jan 2010 15:51:50 +0100
Message-ID: <20100113155150.59867f40@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100113154952.0f01aa1d@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  This patch adds a new port space for use by Lustre traffic.

  This, along with patches to OpenSM and Lustre, allow to define a
specific QoS for lustre.

Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    5 +++++
 include/rdma/rdma_cm.h        |   11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc9b594..6b9e75e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -78,6 +78,7 @@ static DEFINE_IDR(sdp_ps);
 static DEFINE_IDR(tcp_ps);
 static DEFINE_IDR(udp_ps);
 static DEFINE_IDR(ipoib_ps);
+static DEFINE_IDR(lustre_ps);
 static int next_port;
 
 struct cma_device {
@@ -2066,6 +2067,9 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	case RDMA_PS_IPOIB:
 		ps = &ipoib_ps;
 		break;
+	case RDMA_PS_LUSTRE:
+		ps = &lustre_ps;
+		break;
 	default:
 		return -EPROTONOSUPPORT;
 	}
@@ -3034,6 +3038,7 @@ static void __exit cma_cleanup(void)
 	idr_destroy(&tcp_ps);
 	idr_destroy(&udp_ps);
 	idr_destroy(&ipoib_ps);
+	idr_destroy(&lustre_ps);
 }
 
 module_init(cma_init);
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c6b2962..d662799 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -63,11 +63,12 @@ enum rdma_cm_event_type {
 };
 
 enum rdma_port_space {
-	RDMA_PS_SDP   = 0x0001,
-	RDMA_PS_IPOIB = 0x0002,
-	RDMA_PS_TCP   = 0x0106,
-	RDMA_PS_UDP   = 0x0111,
-	RDMA_PS_SCTP  = 0x0183
+	RDMA_PS_SDP    = 0x0001,
+	RDMA_PS_IPOIB  = 0x0002,
+	RDMA_PS_TCP    = 0x0106,
+	RDMA_PS_UDP    = 0x0111,
+	RDMA_PS_LUSTRE = 0x0153,
+	RDMA_PS_SCTP   = 0x0183
 };
 
 struct rdma_addr {
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
