From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 2/3] Add support for TCP segmentation offload (TSO)
Date: Sun, 21 Aug 2016 19:48:00 +0300
Message-ID: <1471798081-19088-3-git-send-email-yishaih@mellanox.com>
References: <1471798081-19088-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471798081-19088-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

1) Add a structure to define a TSO packet as part of struct ibv_send_wr.
2) Add IBV_WR_TSO opcode to be used as part of post_send.
3) Add IBV_WC_TSO to be used as part of poll_cq to report a TSO completion.
4) Add IBV_QP_INIT_ATTR_MAX_TSO_HEADER to define the maximum TSO header size
   when creating a QP. This is needed to let providers prepare their SQ buffer
   to fit application's usage.
5) Report TSO capabilities when querying a device.

In order to preserve the size of ibv_send_wr structure and prevents some
performance penalty, the TSO definition was added under a union with the
memory window stuff, those options are mutual exclusive.

The TSO definition should include:
- A pointer to the packet header.
- Header size.
- The maximum segment size (mss) that the hardware should generate in
  its TSO engine.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c         | 20 ++++++++++++++++++++
 include/infiniband/verbs.h | 37 +++++++++++++++++++++++++++++--------
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 915ebb3..c497650 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -345,6 +345,25 @@ static void print_device_cap_flags_ex(uint64_t device_cap_flags_ex)
 		       ex_flags & unknown_flags);
 }
 
+static void print_tso_caps(const struct ibv_tso_caps *caps)
+{
+	uint32_t unknown_general_caps = ~(1 << IBV_QPT_RAW_PACKET |
+					  1 << IBV_QPT_UD);
+	printf("\ttso_caps:\n");
+	printf("\tmax_tso:\t\t\t%d\n", caps->max_tso);
+
+	if (caps->max_tso) {
+		printf("\tsupported_qp:\n");
+		if (ibv_is_qpt_supported(caps->supported_qpts, IBV_QPT_RAW_PACKET))
+			printf("\t\t\t\t\tSUPPORT_RAW_PACKET\n");
+		if (ibv_is_qpt_supported(caps->supported_qpts, IBV_QPT_UD))
+			printf("\t\t\t\t\tSUPPORT_UD\n");
+		if (caps->supported_qpts & unknown_general_caps)
+			printf("\t\t\t\t\tUnknown flags: 0x%" PRIX32 "\n",
+			       caps->supported_qpts & unknown_general_caps);
+	}
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -445,6 +464,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 
 		printf("\tdevice_cap_flags_ex:\t\t0x%" PRIX64 "\n", device_attr.device_cap_flags_ex);
 		print_device_cap_flags_ex(device_attr.device_cap_flags_ex);
+		print_tso_caps(&device_attr.tso_caps);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ccf1d51..ec541e3 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -209,6 +209,11 @@ enum ibv_odp_general_caps {
 	IBV_ODP_SUPPORT = 1 << 0,
 };
 
+struct ibv_tso_caps {
+	uint32_t max_tso;
+	uint32_t supported_qpts;
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -216,6 +221,7 @@ struct ibv_device_attr_ex {
 	uint64_t		completion_timestamp_mask;
 	uint64_t		hca_core_clock;
 	uint64_t		device_cap_flags_ex;
+	struct ibv_tso_caps	tso_caps;
 };
 
 enum ibv_mtu {
@@ -357,6 +363,7 @@ enum ibv_wc_opcode {
 	IBV_WC_FETCH_ADD,
 	IBV_WC_BIND_MW,
 	IBV_WC_LOCAL_INV,
+	IBV_WC_TSO,
 /*
  * Set value of IBV_WC_RECV so consumers can test if a completion is a
  * receive by testing (opcode & IBV_WC_RECV).
@@ -636,7 +643,8 @@ enum ibv_qp_init_attr_mask {
 	IBV_QP_INIT_ATTR_PD		= 1 << 0,
 	IBV_QP_INIT_ATTR_XRCD		= 1 << 1,
 	IBV_QP_INIT_ATTR_CREATE_FLAGS	= 1 << 2,
-	IBV_QP_INIT_ATTR_RESERVED	= 1 << 3
+	IBV_QP_INIT_ATTR_MAX_TSO_HEADER = 1 << 3,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 4
 };
 
 enum ibv_qp_create_flags {
@@ -657,7 +665,7 @@ struct ibv_qp_init_attr_ex {
 	struct ibv_pd	       *pd;
 	struct ibv_xrcd	       *xrcd;
 	uint32_t                create_flags;
-
+	uint16_t		max_tso_header;
 };
 
 enum ibv_qp_open_attr_mask {
@@ -756,6 +764,7 @@ enum ibv_wr_opcode {
 	IBV_WR_LOCAL_INV,
 	IBV_WR_BIND_MW,
 	IBV_WR_SEND_WITH_INV,
+	IBV_WR_TSO,
 };
 
 enum ibv_send_flags {
@@ -802,12 +811,18 @@ struct ibv_send_wr {
 			uint32_t    remote_srqn;
 		} xrc;
 	} qp_type;
-	struct {
-		struct ibv_mw	*mw;
-		uint32_t		rkey;
-		struct ibv_mw_bind_info	bind_info;
-	} bind_mw;
-
+	union {
+		struct {
+			struct ibv_mw	*mw;
+			uint32_t		rkey;
+			struct ibv_mw_bind_info	bind_info;
+		} bind_mw;
+		struct {
+			void		       *hdr;
+			uint16_t		hdr_sz;
+			uint16_t		mss;
+		} tso;
+	};
 };
 
 struct ibv_recv_wr {
@@ -1967,6 +1982,12 @@ int ibv_resolve_eth_l2_from_gid(struct ibv_context *context,
 				struct ibv_ah_attr *attr,
 				uint8_t eth_mac[ETHERNET_LL_SIZE],
 				uint16_t *vid);
+
+static inline int ibv_is_qpt_supported(uint32_t caps, enum ibv_qp_type qpt)
+{
+	return !!(caps & (1 << qpt));
+}
+
 END_C_DECLS
 
 #  undef __attribute_const
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
