From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/8] nvme.h: add NVMe over Fabrics definitions
Date: Mon, 13 Jun 2016 16:45:25 +0200
Message-ID: <1465829128-22993-6-git-send-email-hch@lst.de>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Armen Baloyan <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The NVMe over Fabrics specification defines a protocol interface and
related extensions to NVMe that enable operation over network protocols.
The NVMe over Fabrics specification has an NVMe Transport binding for
each NVMe Transport.

This patch adds the fabrics related definitions:
- fabric specific command set and error codes
- transport addressing and binding definitions
- fabrics sgl extensions
- controller identification fabrics enhancements
- discovery log page definition

Signed-off-by: Armen Baloyan <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/core.c |   4 +-
 drivers/nvme/host/pci.c  |   4 +-
 include/linux/nvme.h     | 337 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 322 insertions(+), 23 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5676c6..3a1e82e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -524,7 +524,7 @@ int nvme_get_features(struct nvme_ctrl *dev, unsigned fid, unsigned nsid,
 	memset(&c, 0, sizeof(c));
 	c.features.opcode = nvme_admin_get_features;
 	c.features.nsid = cpu_to_le32(nsid);
-	c.features.prp1 = cpu_to_le64(dma_addr);
+	c.features.dptr.prp1 = cpu_to_le64(dma_addr);
 	c.features.fid = cpu_to_le32(fid);
 
 	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &cqe, NULL, 0, 0,
@@ -543,7 +543,7 @@ int nvme_set_features(struct nvme_ctrl *dev, unsigned fid, unsigned dword11,
 
 	memset(&c, 0, sizeof(c));
 	c.features.opcode = nvme_admin_set_features;
-	c.features.prp1 = cpu_to_le64(dma_addr);
+	c.features.dptr.prp1 = cpu_to_le64(dma_addr);
 	c.features.fid = cpu_to_le32(fid);
 	c.features.dword11 = cpu_to_le32(dword11);
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index de222ed..79a4f56 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -520,8 +520,8 @@ static int nvme_map_data(struct nvme_dev *dev, struct request *req,
 			goto out_unmap;
 	}
 
-	cmnd->rw.prp1 = cpu_to_le64(sg_dma_address(iod->sg));
-	cmnd->rw.prp2 = cpu_to_le64(iod->first_dma);
+	cmnd->rw.dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sg));
+	cmnd->rw.dptr.prp2 = cpu_to_le64(iod->first_dma);
 	if (blk_integrity_rq(req))
 		cmnd->rw.metadata = cpu_to_le64(sg_dma_address(&iod->meta_sg));
 	return BLK_MQ_RQ_QUEUE_OK;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index dc815cc..7525030 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -16,6 +16,78 @@
 #define _LINUX_NVME_H
 
 #include <linux/types.h>
+#include <linux/uuid.h>
+
+/* NQN names in commands fields specified one size */
+#define NVMF_NQN_FIELD_LEN	256
+
+/* However the max length of a qualified name is another size */
+#define NVMF_NQN_SIZE		223
+
+#define NVMF_TRSVCID_SIZE	32
+#define NVMF_TRADDR_SIZE	256
+#define NVMF_TSAS_SIZE		256
+
+#define NVME_DISC_SUBSYS_NAME	"nqn.2014-08.org.nvmexpress.discovery"
+
+#define NVME_RDMA_IP_PORT	4420
+
+enum nvme_subsys_type {
+	NVME_NQN_DISC	= 1,		/* Discovery type target subsystem */
+	NVME_NQN_NVME	= 2,		/* NVME type target subsystem */
+};
+
+/* Address Family codes for Discovery Log Page entry ADRFAM field */
+enum {
+	NVMF_ADDR_FAMILY_PCI	= 0,	/* PCIe */
+	NVMF_ADDR_FAMILY_IP4	= 1,	/* IP4 */
+	NVMF_ADDR_FAMILY_IP6	= 2,	/* IP6 */
+	NVMF_ADDR_FAMILY_IB	= 3,	/* InfiniBand */
+	NVMF_ADDR_FAMILY_FC	= 4,	/* Fibre Channel */
+};
+
+/* Transport Type codes for Discovery Log Page entry TRTYPE field */
+enum {
+	NVMF_TRTYPE_RDMA	= 1,	/* RDMA */
+	NVMF_TRTYPE_FC		= 2,	/* Fibre Channel */
+	NVMF_TRTYPE_LOOP	= 254,	/* Reserved for host usage */
+	NVMF_TRTYPE_MAX,
+};
+
+/* Transport Requirements codes for Discovery Log Page entry TREQ field */
+enum {
+	NVMF_TREQ_NOT_SPECIFIED	= 0,	/* Not specified */
+	NVMF_TREQ_REQUIRED	= 1,	/* Required */
+	NVMF_TREQ_NOT_REQUIRED	= 2,	/* Not Required */
+};
+
+/* RDMA QP Service Type codes for Discovery Log Page entry TSAS
+ * RDMA_QPTYPE field
+ */
+enum {
+	NVMF_RDMA_QPTYPE_CONNECTED	= 0, /* Reliable Connected */
+	NVMF_RDMA_QPTYPE_DATAGRAM	= 1, /* Reliable Datagram */
+};
+
+/* RDMA QP Service Type codes for Discovery Log Page entry TSAS
+ * RDMA_QPTYPE field
+ */
+enum {
+	NVMF_RDMA_PRTYPE_NOT_SPECIFIED	= 0, /* No Provider Specified */
+	NVMF_RDMA_PRTYPE_IB		= 1, /* InfiniBand */
+	NVMF_RDMA_PRTYPE_ROCE		= 2, /* InfiniBand RoCE */
+	NVMF_RDMA_PRTYPE_ROCEV2		= 3, /* InfiniBand RoCEV2 */
+	NVMF_RDMA_PRTYPE_IWARP		= 4, /* IWARP */
+};
+
+/* RDMA Connection Management Service Type codes for Discovery Log Page
+ * entry TSAS RDMA_CMS field
+ */
+enum {
+	NVMF_RDMA_CMS_RDMA_CM	= 0, /* Sockets based enpoint addressing */
+};
+
+#define NVMF_AQ_DEPTH		32
 
 enum {
 	NVME_REG_CAP	= 0x0000,	/* Controller Capabilities */
@@ -117,7 +189,8 @@ struct nvme_id_ctrl {
 	__le32			rtd3r;
 	__le32			rtd3e;
 	__le32			oaes;
-	__u8			rsvd96[160];
+	__le32			ctratt;
+	__u8			rsvd100[156];
 	__le16			oacs;
 	__u8			acl;
 	__u8			aerl;
@@ -132,7 +205,7 @@ struct nvme_id_ctrl {
 	__u8			rsvd270[242];
 	__u8			sqes;
 	__u8			cqes;
-	__u8			rsvd514[2];
+	__le16			maxcmd;
 	__le32			nn;
 	__le16			oncs;
 	__le16			fuses;
@@ -145,7 +218,15 @@ struct nvme_id_ctrl {
 	__le16			acwu;
 	__u8			rsvd534[2];
 	__le32			sgls;
-	__u8			rsvd540[1508];
+	__u8			rsvd540[228];
+	char			subnqn[256];
+	__u8			rsvd1024[768];
+	__le32			ioccsz;
+	__le32			iorcsz;
+	__le16			icdoff;
+	__u8			ctrattr;
+	__u8			msdbd;
+	__u8			rsvd1804[244];
 	struct nvme_id_power_state	psd[32];
 	__u8			vs[1024];
 };
@@ -307,6 +388,61 @@ enum nvme_opcode {
 };
 
 /*
+ * Descriptor subtype - lower 4 bits of nvme_(keyed_)sgl_desc identifier
+ *
+ * @NVME_SGL_FMT_ADDRESS:     absolute address of the data block
+ * @NVME_SGL_FMT_OFFSET:      relative offset of the in-capsule data block
+ * @NVME_SGL_FMT_INVALIDATE:  RDMA transport specific remote invalidation
+ *                            request subtype
+ */
+enum {
+	NVME_SGL_FMT_ADDRESS		= 0x00,
+	NVME_SGL_FMT_OFFSET		= 0x01,
+	NVME_SGL_FMT_INVALIDATE		= 0x0f,
+};
+
+/*
+ * Descriptor type - upper 4 bits of nvme_(keyed_)sgl_desc identifier
+ *
+ * For struct nvme_sgl_desc:
+ *   @NVME_SGL_FMT_DATA_DESC:		data block descriptor
+ *   @NVME_SGL_FMT_SEG_DESC:		sgl segment descriptor
+ *   @NVME_SGL_FMT_LAST_SEG_DESC:	last sgl segment descriptor
+ *
+ * For struct nvme_keyed_sgl_desc:
+ *   @NVME_KEY_SGL_FMT_DATA_DESC:	keyed data block descriptor
+ */
+enum {
+	NVME_SGL_FMT_DATA_DESC		= 0x00,
+	NVME_SGL_FMT_SEG_DESC		= 0x02,
+	NVME_SGL_FMT_LAST_SEG_DESC	= 0x03,
+	NVME_KEY_SGL_FMT_DATA_DESC	= 0x04,
+};
+
+struct nvme_sgl_desc {
+	__le64	addr;
+	__le32	length;
+	__u8	rsvd[3];
+	__u8	type;
+};
+
+struct nvme_keyed_sgl_desc {
+	__le64	addr;
+	__u8	length[3];
+	__u8	key[4];
+	__u8	type;
+};
+
+union nvme_data_ptr {
+	struct {
+		__le64	prp1;
+		__le64	prp2;
+	};
+	struct nvme_sgl_desc	sgl;
+	struct nvme_keyed_sgl_desc ksgl;
+};
+
+/*
  * Lowest two bits of our flags field (FUSE field in the spec):
  *
  * @NVME_CMD_FUSE_FIRST:   Fused Operation, first command
@@ -336,8 +472,7 @@ struct nvme_common_command {
 	__le32			nsid;
 	__le32			cdw2[2];
 	__le64			metadata;
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__le32			cdw10[6];
 };
 
@@ -348,8 +483,7 @@ struct nvme_rw_command {
 	__le32			nsid;
 	__u64			rsvd2;
 	__le64			metadata;
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__le64			slba;
 	__le16			length;
 	__le16			control;
@@ -389,8 +523,7 @@ struct nvme_dsm_cmd {
 	__u16			command_id;
 	__le32			nsid;
 	__u64			rsvd2[2];
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__le32			nr;
 	__le32			attributes;
 	__u32			rsvd12[4];
@@ -454,6 +587,7 @@ enum {
 	NVME_LOG_ERROR		= 0x01,
 	NVME_LOG_SMART		= 0x02,
 	NVME_LOG_FW_SLOT	= 0x03,
+	NVME_LOG_DISC		= 0x70,
 	NVME_LOG_RESERVATION	= 0x80,
 	NVME_FWACT_REPL		= (0 << 3),
 	NVME_FWACT_REPL_ACTV	= (1 << 3),
@@ -466,8 +600,7 @@ struct nvme_identify {
 	__u16			command_id;
 	__le32			nsid;
 	__u64			rsvd2[2];
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__le32			cns;
 	__u32			rsvd11[5];
 };
@@ -478,8 +611,7 @@ struct nvme_features {
 	__u16			command_id;
 	__le32			nsid;
 	__u64			rsvd2[2];
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__le32			fid;
 	__le32			dword11;
 	__u32			rsvd12[4];
@@ -538,8 +670,7 @@ struct nvme_download_firmware {
 	__u8			flags;
 	__u16			command_id;
 	__u32			rsvd1[5];
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__le32			numd;
 	__le32			offset;
 	__u32			rsvd12[4];
@@ -561,8 +692,7 @@ struct nvme_get_log_page_command {
 	__u16			command_id;
 	__le32			nsid;
 	__u64			rsvd2[2];
-	__le64			prp1;
-	__le64			prp2;
+	union nvme_data_ptr	dptr;
 	__u8			lid;
 	__u8			rsvd10;
 	__le16			numdl;
@@ -573,6 +703,126 @@ struct nvme_get_log_page_command {
 	__u32			rsvd14[2];
 };
 
+/*
+ * Fabrics subcommands.
+ */
+enum nvmf_fabrics_opcode {
+	nvme_fabrics_command		= 0x7f,
+};
+
+enum nvmf_capsule_command {
+	nvme_fabrics_type_property_set	= 0x00,
+	nvme_fabrics_type_connect	= 0x01,
+	nvme_fabrics_type_property_get	= 0x04,
+};
+
+struct nvmf_common_command {
+	__u8	opcode;
+	__u8	resv1;
+	__u16	command_id;
+	__u8	fctype;
+	__u8	resv2[35];
+	__u8	ts[24];
+};
+
+/*
+ * The legal cntlid range a NVMe Target will provide.
+ * Note that cntlid of value 0 is considered illegal in the fabrics world.
+ * Devices based on earlier specs did not have the subsystem concept;
+ * therefore, those devices had their cntlid value set to 0 as a result.
+ */
+#define NVME_CNTLID_MIN		1
+#define NVME_CNTLID_MAX		0xffef
+#define NVME_CNTLID_DYNAMIC	0xffff
+
+#define MAX_DISC_LOGS	255
+
+/* Discovery log page entry */
+struct nvmf_disc_rsp_page_entry {
+	__u8		trtype;
+	__u8		adrfam;
+	__u8		nqntype;
+	__u8		treq;
+	__le16		portid;
+	__le16		cntlid;
+	__le16		asqsz;
+	__u8		resv8[22];
+	char		trsvcid[NVMF_TRSVCID_SIZE];
+	__u8		resv64[192];
+	char		subnqn[NVMF_NQN_FIELD_LEN];
+	char		traddr[NVMF_TRADDR_SIZE];
+	union tsas {
+		char		common[NVMF_TSAS_SIZE];
+		struct rdma {
+			__u8	qptype;
+			__u8	prtype;
+			__u8	cms;
+			__u8	resv3[5];
+			__u16	pkey;
+			__u8	resv10[246];
+		} rdma;
+	} tsas;
+};
+
+/* Discovery log page header */
+struct nvmf_disc_rsp_page_hdr {
+	__le64		genctr;
+	__le64		numrec;
+	__le16		recfmt;
+	__u8		resv14[1006];
+	struct nvmf_disc_rsp_page_entry entries[0];
+};
+
+struct nvmf_connect_command {
+	__u8		opcode;
+	__u8		resv1;
+	__u16		command_id;
+	__u8		fctype;
+	__u8		resv2[19];
+	union nvme_data_ptr dptr;
+	__le16		recfmt;
+	__le16		qid;
+	__le16		sqsize;
+	__u8		cattr;
+	__u8		resv3;
+	__le32		kato;
+	__u8		resv4[12];
+};
+
+struct nvmf_connect_data {
+	uuid_le		hostid;
+	__le16		cntlid;
+	char		resv4[238];
+	char		subsysnqn[NVMF_NQN_FIELD_LEN];
+	char		hostnqn[NVMF_NQN_FIELD_LEN];
+	char		resv5[256];
+};
+
+struct nvmf_property_set_command {
+	__u8		opcode;
+	__u8		resv1;
+	__u16		command_id;
+	__u8		fctype;
+	__u8		resv2[35];
+	__u8		attrib;
+	__u8		resv3[3];
+	__le32		offset;
+	__le64		value;
+	__u8		resv4[8];
+};
+
+struct nvmf_property_get_command {
+	__u8		opcode;
+	__u8		resv1;
+	__u16		command_id;
+	__u8		fctype;
+	__u8		resv2[35];
+	__u8		attrib;
+	__u8		resv3[3];
+	__le32		offset;
+	__u8		resv4[16];
+};
+
 struct nvme_command {
 	union {
 		struct nvme_common_command common;
@@ -587,15 +837,29 @@ struct nvme_command {
 		struct nvme_dsm_cmd dsm;
 		struct nvme_abort_cmd abort;
 		struct nvme_get_log_page_command get_log_page;
+		struct nvmf_common_command fabrics;
+		struct nvmf_connect_command connect;
+		struct nvmf_property_set_command prop_set;
+		struct nvmf_property_get_command prop_get;
 	};
 };
 
 static inline bool nvme_is_write(struct nvme_command *cmd)
 {
+	/*
+	 * What a mess...
+	 *
+	 * Why can't we simply have a Fabrics In and Fabrics out command?
+	 */
+	if (unlikely(cmd->common.opcode == nvme_fabrics_command))
+		return cmd->fabrics.opcode & 1;
 	return cmd->common.opcode & 1;
 }
 
 enum {
+	/*
+	 * Generic Command Status:
+	 */
 	NVME_SC_SUCCESS			= 0x0,
 	NVME_SC_INVALID_OPCODE		= 0x1,
 	NVME_SC_INVALID_FIELD		= 0x2,
@@ -614,10 +878,18 @@ enum {
 	NVME_SC_SGL_INVALID_DATA	= 0xf,
 	NVME_SC_SGL_INVALID_METADATA	= 0x10,
 	NVME_SC_SGL_INVALID_TYPE	= 0x11,
+
+	NVME_SC_SGL_INVALID_OFFSET	= 0x16,
+	NVME_SC_SGL_INVALID_SUBTYPE	= 0x17,
+
 	NVME_SC_LBA_RANGE		= 0x80,
 	NVME_SC_CAP_EXCEEDED		= 0x81,
 	NVME_SC_NS_NOT_READY		= 0x82,
 	NVME_SC_RESERVATION_CONFLICT	= 0x83,
+
+	/*
+	 * Command Specific Status:
+	 */
 	NVME_SC_CQ_INVALID		= 0x100,
 	NVME_SC_QID_INVALID		= 0x101,
 	NVME_SC_QUEUE_SIZE		= 0x102,
@@ -635,9 +907,29 @@ enum {
 	NVME_SC_FEATURE_NOT_CHANGEABLE	= 0x10e,
 	NVME_SC_FEATURE_NOT_PER_NS	= 0x10f,
 	NVME_SC_FW_NEEDS_RESET_SUBSYS	= 0x110,
+
+	/*
+	 * I/O Command Set Specific - NVM commands:
+	 */
 	NVME_SC_BAD_ATTRIBUTES		= 0x180,
 	NVME_SC_INVALID_PI		= 0x181,
 	NVME_SC_READ_ONLY		= 0x182,
+
+	/*
+	 * I/O Command Set Specific - Fabrics commands:
+	 */
+	NVME_SC_CONNECT_FORMAT		= 0x180,
+	NVME_SC_CONNECT_CTRL_BUSY	= 0x181,
+	NVME_SC_CONNECT_INVALID_PARAM	= 0x182,
+	NVME_SC_CONNECT_RESTART_DISC	= 0x183,
+	NVME_SC_CONNECT_INVALID_HOST	= 0x184,
+
+	NVME_SC_DISCOVERY_RESTART	= 0x190,
+	NVME_SC_AUTH_REQUIRED		= 0x191,
+
+	/*
+	 * Media and Data Integrity Errors:
+	 */
 	NVME_SC_WRITE_FAULT		= 0x280,
 	NVME_SC_READ_ERROR		= 0x281,
 	NVME_SC_GUARD_CHECK		= 0x282,
@@ -645,12 +937,19 @@ enum {
 	NVME_SC_REFTAG_CHECK		= 0x284,
 	NVME_SC_COMPARE_FAILED		= 0x285,
 	NVME_SC_ACCESS_DENIED		= 0x286,
+
 	NVME_SC_DNR			= 0x4000,
 };
 
 struct nvme_completion {
-	__le32	result;		/* Used by admin commands to return data */
-	__u32	rsvd;
+	/*
+	 * Used by Admin and Fabrics commands to return data:
+	 */
+	union {
+		__le16	result16;
+		__le32	result;
+		__le64	result64;
+	};
 	__le16	sq_head;	/* how much of this queue may be reclaimed */
 	__le16	sq_id;		/* submission queue that generated this entry */
 	__u16	command_id;	/* of the command which completed */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
