Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067771;
	b=onBWTGQJnCBwAiOpA2SyMc+7x9axPW2WSC3yb0wINvqZOqEDYTIjm1xDvS+wHqiY267O
	 phcimJFi6hBZMA5aJSC/FLQiRRb0OdfSACvpgHTjmp0g3WKmbEFFNJdOnh6pmby8tkxnk
	 VbIUfcaGgjw4ekxXTOHbQXQ1Ej1PyYQdNbt7DSFF3xH9t/MklgpBni7yYlg6mmkt/PIVd
	 NXHIl1sJzH8z5A/QWzufdE2Do4B3+Hmnr+iBqI0oAfm0BYGb8i243pKcn6s9HQJsjsFgM
	 Vzv7ZRv0K+/PDk9Mw6YepoOfPG8JNM/5PvNK0fXSWKDaUzDiSfSzNUQD13IofIsqbUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067771;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=S6AsA1P5OPt44Y9bsmtYV7XUdp8eQ3XyaaPOUJN+1tQ=;
	b=Q9qqqlswM1g04vOKQ3uag0LWV7yr17JC7Yu3tdsX2y3eStDBSSnSmwplBKKiSIqZXL6x
	 PD+lbDdj2zK7cpJNB3qgWSlUMZhfYgD7nYq2kCe+T3uAVIpj+5HHAI0JvsO85asZVTjdd
	 KKPxVuHY03MTLXUpB9BCa4ThUyg09CRNO2Sui5Wd9DIwPbrWP2fQyHZC4+KJzQ5TVQzp8
	 Dpl3sNhvPUWmX1ZUQeUyquuOp9JxSDTZjzyvv9GN3uPEkurt183otkFn3Dcc1s6pfslmU
	 XGBBKv1S3Ef6s34BtBL2rlqcFFlgGIRffyJDXJ73EvQ1oGqaeWtuYOsw4agmo0X7yYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB4C606A32C;
	Tue, 27 Oct 2026 02:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB4C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jDDmQ553Gz5B7RT;
	Tue, 27 Oct 2026 10:22:46 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
	by mse-fl1.zte.com.cn with SMTP id 69R2MTkD088291;
	Tue, 27 Oct 2026 10:22:29 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 27 Oct 2026 10:22:31 +0800
X-Zmail-TransId: 3e816ae00ae6027-4be81
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v7 7/7] RDMA/zrdma: Implement device and port query operations
Date: Tue, 27 Oct 2026 10:11:19 +0800
Message-ID: <20261027021119.2325798-8-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl1.zte.com.cn 69R2MTkD088291
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 27 Oct 2026 10:22:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE00AF6.001/4jDDmQ553Gz5B7RT

Add implementation for querying device attributes, port attributes,
PKey, and link layer information. Also include firmware version string
retrieval.

 - query_device() accepts a NULL udata, which is how the core calls it
   while the device is being registered, and it reports the number of
   send and receive SGEs the hardware supports.
 - The firmware version is parsed as unsigned values and masked to 16
   bits, and the version string keeps its "N/A" placeholder when no
   version can be extracted from the driver info. A model prefix is
   skipped whether or not the network driver appends the vendor in
   parentheses, so that a firmware string carrying both a model prefix
   and a vendor suffix still yields a non-zero fw_ver.
 - The driver info is read with rtnl held, taking the lock only when
   the caller does not hold it already, so a bond never falls back to
   the bond device itself. The driver info is only read from process
   context, through query_device() and get_dev_fw_str(), so taking the
   rtnl lock there cannot sleep in atomic context.
 - The port speed is taken from ib_get_eth_speed(), which reads the
   current link settings instead of caching a stale value.
 - The immutable port information is filled in directly rather than
   taken from the port query, so that it does not depend on the port
   query being run while the device is still being registered.
 - The port number is passed to rdma_protocol_roce() instead of being
   hard coded, so that the query stays correct if more ports are added.
 - The RoCE GID cache is owned by the core, so the driver does not
   provide a query_gid callback.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 294 +++++++++++++++++++++-
 1 file changed, 292 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index abac97e69413..ceaad155fc5a 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -10,7 +10,9 @@
 #include <rdma/ib_mad.h>
 #include <rdma/ib_cache.h>
 #include <rdma/ib_user_verbs.h>
+#include <linux/ctype.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 
 /* Release everything the probe path may have allocated. The hook is
  * called from ib_dealloc_device(), so it must tolerate a partially
@@ -352,6 +354,252 @@ static int zxdh_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	return ret;
 }
 
+/* Fetch the driver info for @zdev->netdev, or for its first lower device
+ * when it is a bond. The lower device list is protected by rtnl_lock, and
+ * the core may call this from a netdev notifier that already holds the
+ * lock, so it is only taken when it is not held already.
+ */
+static bool zxdh_get_drvinfo(struct zxdh_device *zdev,
+			     struct ethtool_drvinfo *info)
+{
+	struct net_device *slave = NULL, *dev;
+	struct list_head *iter;
+	bool locked;
+	bool ret = true;
+
+	memset(info, 0, sizeof(*info));
+
+	locked = !rtnl_is_locked();
+	if (locked)
+		rtnl_lock();
+
+	if (zdev->netdev->priv_flags & IFF_BONDING)
+		netdev_for_each_lower_dev(zdev->netdev, slave, iter)
+			break;
+
+	dev = slave ? slave : zdev->netdev;
+	if (dev->ethtool_ops && dev->ethtool_ops->get_drvinfo)
+		dev->ethtool_ops->get_drvinfo(dev, info);
+	else
+		ret = false;
+
+	if (locked)
+		rtnl_unlock();
+
+	return ret;
+}
+
+static void extract_version(const char *input, char *output)
+{
+	const char *v_start, *p;
+	int dots = 0;
+
+	if (!output)
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
+		*output++ = *p;
+	}
+
+	*output = '\0';
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
+
+	/* The core calls this without udata while the device is being
+	 * registered, so udata is only inspected when it is there.
+	 */
+	if (udata && (udata->inlen || udata->outlen))
+		return -EINVAL;
+
+	memset(props, 0, sizeof(*props));
+
+	if (zxdh_get_drvinfo(zdev, &info)) {
+		extract_version(info.fw_version, extracted_version);
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
+			 (sub_minor & 0xffff));
+	props->device_cap_flags =
+		IB_DEVICE_MEM_WINDOW | IB_DEVICE_MEM_MGT_EXTENSIONS |
+		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SYS_IMAGE_GUID |
+		IB_DEVICE_RC_RNR_NAK_GEN | IB_DEVICE_N_NOTIFY_CQ;
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
+	props->active_mtu = zxdh_mtu_int_to_enum(netdev->mtu);
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
+	props->port_cap_flags |= IB_PORT_CM_SUP;
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
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP |
+				    RDMA_CORE_CAP_PROT_ROCE;
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
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
+	extract_version(info.fw_version, extracted_version);
+	/* Keep the placeholder when no version could be extracted. */
+	if (extracted_version[0])
+		strscpy(str, extracted_version, IB_FW_VERSION_NAME_MAX);
+}
+
 static void zxdh_init_roce_device(struct zxdh_device *zdev)
 {
 	zdev->ibdev.node_type = RDMA_NODE_IB_CA;
@@ -375,17 +623,53 @@ static int zxdh_init_rdma_device(struct zxdh_device *zdev)
 	return 0;
 }
 
+static void zxdh_port_ibevent(struct zxdh_device *zdev)
+{
+	struct ib_event event;
+
+	event.device = &zdev->ibdev;
+	event.element.port_num = 1;
+	event.event = zdev->ibdev_status ? IB_EVENT_PORT_ACTIVE :
+						 IB_EVENT_PORT_ERR;
+	ib_dispatch_event(&event);
+}
+
 int zxdh_ib_register_device(struct zxdh_device *zdev)
 {
+	char name[IB_DEVICE_NAME_MAX] = {};
 	int ret;
 
 	ret = zxdh_init_rdma_device(zdev);
 	if (ret)
 		return ret;
 
-	ret = ib_register_device(&zdev->ibdev, "zrdma%d", zdev->rf->hw.device);
+	ret = zxdh_get_del_rdma_name(pci_name(zdev->rf->pcidev), name,
+				     IB_DEVICE_NAME_MAX);
 	if (ret)
-		pr_err("zrdma: Register RDMA device fail\n");
+		snprintf(name, IB_DEVICE_NAME_MAX, "%s", "zrdma%d");
+
+	ret = ib_device_set_netdev(&zdev->ibdev, zdev->netdev, 1);
+	if (ret)
+		goto error;
+
+	zdev->rf->hw.device = &zdev->rf->pcidev->dev;
+	dma_set_max_seg_size(zdev->rf->hw.device, SZ_1G);
+
+	/* Publish the link state before the device becomes visible to
+	 * userspace, so a racing ULP never observes a stale status.
+	 */
+	zdev->ibdev_status = 1;
+
+	ret = ib_register_device(&zdev->ibdev, name, zdev->rf->hw.device);
+	if (ret)
+		goto error;
+
+	zxdh_port_ibevent(zdev);
+
+	return 0;
+
+error:
+	pr_err("zrdma: Register RDMA device fail, ret=%d\n", ret);
 
 	return ret;
 }
@@ -399,6 +683,12 @@ const struct ib_device_ops zxdh_dev_ops = {
 	.alloc_ucontext = zxdh_alloc_ucontext,
 	.dealloc_pd = zxdh_dealloc_pd,
 	.dealloc_ucontext = zxdh_dealloc_ucontext,
+	.query_device = zxdh_query_device,
+	.query_port = zxdh_query_port,
+	.query_pkey = zxdh_query_pkey,
+	.get_link_layer = zxdh_get_link_layer,
+	.get_port_immutable = zxdh_roce_port_immutable,
+	.get_dev_fw_str = zxdh_get_dev_fw_str,
 	.mmap = zxdh_mmap,
 	.mmap_free = zxdh_mmap_free,
 
-- 
2.27.0

