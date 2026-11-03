Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711289;
	b=NDOK1opO8EDeKJibVA6zNHJibFLRdAJwQsrWyLxvLB2gmpmSPMiG7O0CKobY8fQLbRyo
	 Ojaw4AGw8zAyXskVSZRUYH4/GFKNzQ7SxPrK3zkSoolO1WtsyRbqs3JqM2ArAQMvKltvk
	 APv4VlaLccXh8nqwdsk7UpahAHkzooBNoIne+GxSDIxlucKZmMW+IzpBmsgM8ghvv+j5i
	 wVkt9lt4R7Vfx21LbMfAILbnKp5jKSkV4zCpBlCT7cUjDLGvSPJug6/6qRA4q/GUGAeu2
	 cRrjbawut9XqAsCS21472gT90ALKXv6lfxQO4LpVxgYux3+Wyx5u1tLiiBZ21etgv1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711289;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=r7CooIw1Bi/0suNnLQLpMoBg0C8qxELygEKgmH6yELM=;
	b=vxtL5rs6XEifQLF3ohDF6p9SK7istdy5HSoJySRfiG/356BH5szv2oCXUJIXxL3uxGMP
	 CckDZIBtFWYwWdHc1u0XdwJYw/isqwp7YR7Td/tz3b/xzs5jTJTxGMtDJjzV0qCn7RjCq
	 c/BrLKeSnztlZqyUvSvvSDICWbEaHzUuLlFhGayeDiqFWxqq362ArpvgbQS9AW595fUvK
	 cfpcqDWaNoKyzVZ8hY/wD48a+e6jC9b89vSljIbt7Rl65TMKLpIF9rZdpkr1JTGWJPfXf
	 ZIAJtqxFrcuXvHzsiGTa2g3paHO12ijylT0k1oeHbPnECwcPSGU/pwfpS51WD3rOcQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A209606A333;
	Tue,  3 Nov 2026 13:08:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A209606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJplj3nx2z55y2H;
	Tue, 03 Nov 2026 21:08:01 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl1.zte.com.cn with SMTP id 6A3D7j5a004970;
	Tue, 3 Nov 2026 21:07:45 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 3 Nov 2026 21:07:49 +0800
X-Zmail-TransId: 3e816ae9dca4029-7edfd
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v9 5/7] RDMA/zrdma: Implement device and port query operations
Date: Tue,  3 Nov 2026 20:56:52 +0800
Message-ID: <20261103125654.2707069-6-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 6A3D7j5a004970
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 21:08:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9DCB1.000/4jJplj3nx2z55y2H

Add implementation for querying device attributes, port attributes,
PKey, and link layer information. Also include firmware version string
retrieval.

The device attributes report the limits of the hardware, the vendor id
and the firmware version, which is taken from the driver info of the
network device. The port attributes report the state and the speed of
the port, which is taken from the network device on every query. The
immutable port information describes the RoCE encapsulation of the
port.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 300 ++++++++++++++++++++++
 1 file changed, 300 insertions(+)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index 84ee7be418139..b5322a8e129bb 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -7,11 +7,305 @@
 #include "zrdma_main.h"
 #include "zrdma_verbs.h"
 #include "zrdma_ctrl.h"
+#include <linux/ctype.h>
+#include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
+
+/* Fetch the driver info for @zdev->netdev, or for its first lower device
+ * when it is a bond. The lower device list is protected by rtnl_lock.
+ *
+ * The lock is taken unconditionally. rtnl_is_locked() only tells whether
+ * some task holds the lock, not whether the current one does, so it must
+ * not be used to decide that the lock can be skipped: skipping it would
+ * walk the lower device list without its protection.
+ *
+ * The lock is needed for two reasons: the kernel requires it for the
+ * traversal of the lower device list, and it keeps a slave from being
+ * unlinked or unregistered while it is used. A reference on the device
+ * would not be enough, because it does not keep the private data of the
+ * driver of the slave alive during the unregistration.
+ *
+ * The callers run in process context, so taking the lock there cannot
+ * sleep in atomic context. None of the callers holds the rtnl lock
+ * itself: query_device() is called from the uverbs and from the
+ * registration path, get_dev_fw_str() from the sysfs and from the
+ * netlink path. The rtnl mutex is not recursive, so taking it here
+ * cannot deadlock.
+ */
+static bool zxdh_get_drvinfo(struct zxdh_device *zdev,
+			     struct ethtool_drvinfo *info)
+{
+	struct net_device *slave = NULL, *dev;
+	struct list_head *iter;
+	bool ret = true;
+
+	memset(info, 0, sizeof(*info));
+
+	if (!zdev->netdev)
+		return false;
+
+	rtnl_lock();
+
+	/* Only the master of a bond has the slaves in its lower device
+	 * list. A slave carries the bonding flag as well, but it has no
+	 * lower devices of its own.
+	 */
+	if (netif_is_bond_master(zdev->netdev))
+		netdev_for_each_lower_dev(zdev->netdev, slave, iter)
+			break;
+
+	dev = slave ? slave : zdev->netdev;
+	if (dev->ethtool_ops && dev->ethtool_ops->get_drvinfo)
+		dev->ethtool_ops->get_drvinfo(dev, info);
+	else
+		ret = false;
+
+	rtnl_unlock();
+
+	return ret;
+}
+
+static void extract_version(const char *input, char *output, size_t size)
+{
+	const char *v_start, *p;
+	size_t len = 0;
+	int dots = 0;
+
+	if (!output || !size)
+		return;
+
+	*output = '\0';
+
+	if (!input)
+		return;
+
+	/* The version is preceded by the model, e.g. "E310-V25.30.103.01".
+	 * Skip the model, so that only the version itself is reported.
+	 */
+	v_start = input;
+	for (p = input; *p; p++) {
+		if (p[0] == '-' && p[1] == 'V' && isdigit((unsigned char)p[2])) {
+			v_start = p + 2;
+			break;
+		}
+	}
+
+	/* Cut the vendor suffix, if any, and keep at most four dot
+	 * separated fields, which is what the fw_ver layout can hold.
+	 */
+	for (p = v_start; *p && *p != ' '; p++) {
+		if (*p == '.' && ++dots == 4)
+			break;
+		if (len + 1 >= size)
+			break;
+		output[len++] = *p;
+	}
+
+	output[len] = '\0';
+}
+
+static int zxdh_query_device(struct ib_device *ibdev,
+			     struct ib_device_attr *props,
+			     struct ib_udata *udata)
+{
+	struct zxdh_device *zdev = to_zdev(ibdev);
+	struct pci_dev *pcidev = zdev->rf->pcidev;
+	unsigned int major, sub_major, minor, sub_minor;
+	struct ethtool_drvinfo info;
+	char extracted_version[32] = {};
+	int err;
+
+	/* The driver has no device specific data to exchange. The core
+	 * calls this without udata while the device is being registered,
+	 * so udata is only inspected when it is there.
+	 */
+	err = ib_no_udata_io(udata);
+	if (err)
+		return err;
+
+	memset(props, 0, sizeof(*props));
+
+	if (zxdh_get_drvinfo(zdev, &info)) {
+		extract_version(info.fw_version, extracted_version,
+				 sizeof(extracted_version));
+		if (sscanf(extracted_version, "%u.%u.%u.%u", &major,
+			   &sub_major, &minor, &sub_minor) != 4) {
+			major = 0;
+			sub_major = 0;
+			minor = 0;
+			sub_minor = 0;
+		}
+	} else {
+		major = 0;
+		sub_major = 0;
+		minor = 0;
+		sub_minor = 0;
+	}
+
+	addrconf_addr_eui48((u8 *)&props->sys_image_guid,
+			    zdev->netdev->dev_addr);
+	props->fw_ver = ((u64)(major & 0xffff) << 48 |
+			 (u64)(sub_major & 0xffff) << 32 |
+			 (u64)(minor & 0xffff) << 16 |
+			 (u64)(sub_minor & 0xffff));
+	/* Only the capabilities that the driver implements are reported.
+	 * The memory management extensions need the advise_mr operation,
+	 * the notification of the completion queue needs req_notify_cq and
+	 * the RNR NAK generation needs the queue pair data path.
+	 */
+	props->device_cap_flags =
+		IB_DEVICE_MEM_WINDOW | IB_DEVICE_SYS_IMAGE_GUID;
+	props->vendor_id = pcidev->vendor;
+	props->vendor_part_id = pcidev->device;
+	props->hw_ver = pcidev->revision;
+	props->page_size_cap = SZ_4K | SZ_2M | SZ_1G;
+	props->max_mr_size = MAX_MR_SIZE;
+	props->max_qp = MAX_QP;
+	props->max_qp_wr = MAX_QP_WR;
+	props->max_cq = MAX_CQ;
+	props->max_cqe = MAX_CQE;
+	props->max_mr = MAX_MR;
+	props->max_mw = MAX_MW;
+	props->max_pd = MAX_PD;
+	props->max_send_sge = MAX_SEND_SGE;
+	props->max_recv_sge = MAX_RECV_SGE;
+	props->max_sge_rd = MAX_SGE_RD;
+	props->max_qp_rd_atom = MAX_QP_RD_ATOM;
+	props->max_res_rd_atom = MAX_RES_RD_ATOM;
+	props->max_qp_init_rd_atom = MAX_QP_INIT_RD_ATOM;
+	props->max_srq = MAX_SRQ;
+	props->max_srq_wr = MAX_SRQ_WR;
+	props->max_srq_sge = MAX_SRQ_SGE;
+	props->local_ca_ack_delay = LOCAL_CA_ACK_DELAY;
+	props->hca_core_clock = HCA_CORE_CLOCK;
+	props->max_wq_type_rq = MAX_WQ_TYPE_RQ;
+	if (rdma_protocol_roce(ibdev, rdma_start_port(ibdev))) {
+		props->max_pkeys = ZXDH_PKEY_TBL_SZ;
+		props->max_ah = MAX_AH;
+		props->max_mcast_grp = 0;
+		props->max_mcast_qp_attach = 0;
+		props->max_total_mcast_qp_attach = 0;
+	}
+	props->max_fast_reg_page_list_len = MAX_FAST_REG_PAGE_LIST_LEN;
+	props->cq_caps.max_cq_moderation_count = MAX_CQ_MODERATION_COUNT;
+	props->cq_caps.max_cq_moderation_period = MAX_CQ_MODERATION_PERIOD;
+	props->timestamp_mask = TIMESTAMP_MASK;
+
+	return 0;
+}
+
+static int zxdh_query_port(struct ib_device *ibdev, u32 port,
+			   struct ib_port_attr *props)
+{
+	struct zxdh_device *zdev = to_zdev(ibdev);
+	struct net_device *netdev = zdev->netdev;
+
+	props->max_mtu = IB_MTU_4096;
+	props->active_mtu = ib_mtu_int_to_enum(netdev->mtu - ZXDH_MTU_HEADER_RSV);
+	props->lid = 0;
+	props->lmc = 0;
+	props->sm_lid = 0;
+	props->sm_sl = 0;
+	if (netif_carrier_ok(netdev) && netif_running(netdev)) {
+		props->state = IB_PORT_ACTIVE;
+		props->phys_state = IB_PORT_PHYS_STATE_LINK_UP;
+	} else {
+		props->state = IB_PORT_DOWN;
+		props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
+	}
+
+	/* The link speed is read from the netdev on every query, so a
+	 * link change is never reported with a stale value.
+	 */
+	if (ib_get_eth_speed(ibdev, port, &props->active_speed,
+			     &props->active_width))
+		pr_warn_ratelimited("zrdma: failed to get the port speed\n");
+
+	if (rdma_protocol_roce(ibdev, port)) {
+		props->gid_tbl_len = ZXDH_GID_TBL_LEN;
+		props->ip_gids = true;
+		props->pkey_tbl_len = ZXDH_PKEY_TBL_SZ;
+	} else {
+		props->gid_tbl_len = 1;
+	}
+	props->max_msg_sz = MAX_MSG_SZ;
+	props->qkey_viol_cntr = 0;
+
+	return 0;
+}
+
+static enum rdma_link_layer zxdh_get_link_layer(struct ib_device *ibdev,
+						u32 port_num)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+static int zxdh_query_pkey(struct ib_device *ibdev, u32 port, u16 index,
+			   u16 *pkey)
+{
+	if (index >= ZXDH_PKEY_TBL_SZ)
+		return -EINVAL;
+
+	*pkey = ZXDH_DEFAULT_PKEY;
+	return 0;
+}
+
+static int zxdh_roce_port_immutable(struct ib_device *ibdev, u32 port_num,
+				    struct ib_port_immutable *immutable)
+{
+	/* The core passes a pointer to port_data[port_num].immutable, so
+	 * the values are visible to rdma_protocol_roce() as soon as they
+	 * are written here. They are filled in directly instead of asking
+	 * zxdh_query_port(), because that helper is only meant for a
+	 * device that is already registered.
+	 */
+	/* The management datagrams are not supported, so the MAD and the
+	 * CM capability are not reported and the size of the management
+	 * datagram is zero.
+	 */
+	immutable->core_cap_flags = RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP |
+				    RDMA_CORE_CAP_PROT_ROCE;
+	immutable->max_mad_size = 0;
+	immutable->pkey_tbl_len = ZXDH_PKEY_TBL_SZ;
+	immutable->gid_tbl_len = ZXDH_GID_TBL_LEN;
+
+	return 0;
+}
+
+static void zxdh_get_dev_fw_str(struct ib_device *dev, char *str)
+{
+	struct zxdh_device *zdev = to_zdev(dev);
+	struct ethtool_drvinfo info;
+	char extracted_version[32];
+
+	strscpy(str, "N/A", IB_FW_VERSION_NAME_MAX);
+
+	if (!zxdh_get_drvinfo(zdev, &info))
+		return;
+
+	extract_version(info.fw_version, extracted_version,
+				 sizeof(extracted_version));
+	/* Keep the placeholder when no version could be extracted. */
+	if (extracted_version[0])
+		strscpy(str, extracted_version, IB_FW_VERSION_NAME_MAX);
+}
+
+static void zxdh_init_roce_device(struct zxdh_device *zdev)
+{
+	zdev->ibdev.node_type = RDMA_NODE_IB_CA;
+	addrconf_addr_eui48((u8 *)&zdev->ibdev.node_guid,
+			    zdev->netdev->dev_addr);
+}
 
 static int zxdh_init_rdma_device(struct zxdh_device *zdev)
 {
 	struct pci_dev *pcidev = zdev->rf->pcidev;
 
+	if (zdev->roce_mode)
+		zxdh_init_roce_device(zdev);
+	else
+		return -EPFNOSUPPORT;
+
 	zdev->ibdev.phys_port_cnt = 1;
 	/* The core divides by num_comp_vectors in ib_cq_pool_get() and
 	 * rejects every uverbs CQ creation when it is zero, so the count
@@ -47,4 +341,10 @@ const struct ib_device_ops zxdh_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ZRDMA,
 	.uverbs_abi_ver = ZXDH_ABI_VER,
+	.query_device = zxdh_query_device,
+	.query_port = zxdh_query_port,
+	.query_pkey = zxdh_query_pkey,
+	.get_link_layer = zxdh_get_link_layer,
+	.get_port_immutable = zxdh_roce_port_immutable,
+	.get_dev_fw_str = zxdh_get_dev_fw_str,
 };
-- 
2.43.5

