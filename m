Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826764;
	b=GQmaeReGridEWxQtAnSG4p15+3lRNhSfPHyGDGtAcuOod1zd17cRba3dryGz2s8GWEs2
	 2WZGBhyZWe/+4ucgJ09AfzmEDCyiEWeND09Mlknm9GriYKuM+1OxZCEMf3XcSzKQK9Ke7
	 k50on6cbicNjTHjG0bsZ/1uMw3EFjkGTc1flEdywQiYgsALR666HLgf+7AsUEm6wi3FXQ
	 rQkfBAqAZv0UFTDGLxIMa1Xhx8SW5uyWjG6UjQ9IVlXD/XUS6l8Eo9Ia+D0bJ6GioIMVW
	 qsIj3EoRpQKfUddQf1m9U3Z4cpeCKAHP1ksIt2aQOyKHJv7hPPXRa73lBKctvAtrmBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826764;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=nSwVUiRXHWlJ3sME5JnREZSqbabP5VYGE4/W3e7KmF4=;
	b=hvAO8XYIvqwbCVLmh+AttZKKbWXpTujYvJk9iaX3rnGiomaZejUWvn+M/sTMGgZ1NgtA
	 DGNHV6JbT3Fh/wlIao83jsSaMDbrt9UMdFP57GUkd5FEJoLqqh3Jyq6o1/Ks0Oi5/S+lP
	 ClVvMxw6S6JTc0MT8m4DRdhZUyhIUxoRYxM3qOeY95pQ5fMJoUVe7TzN5gtmXGJ2mpldJ
	 TptpXlwaV2Hq6wsx0h0wrClLgjqINwyIkAmx/1sAKKPnGspWzB9xCm9payHtTs7+DK+1F
	 gWlL2q8noVfjcpyrIBDex7ARKDVmltDNp0X9xo7zVX7ZObLbSIKExVpHB9De43xqBTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C739606A324;
	Sat, 24 Oct 2026 07:26:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C739606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jBWdf6K8gz55y2Q;
	Sat, 24 Oct 2026 15:25:58 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
	by mse-fl2.zte.com.cn with SMTP id 69O7PlKb094846;
	Sat, 24 Oct 2026 15:25:47 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 24 Oct 2026 15:25:49 +0800
X-Zmail-TransId: 3e816adc5d7c026-b7bb3
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH 7/7] RDMA/zrdma: Implement device and port query operations
Date: Sat, 24 Oct 2026 15:15:39 +0800
Message-ID: <20261024071539.2182864-8-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl2.zte.com.cn 69O7PlKb094846
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 24 Oct 2026 15:25:58 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADC5D86.000/4jBWdf6K8gz55y2Q

Add implementation for querying device attributes, port attributes,
GID, PKey, and link layer information. Also include firmware
version string retrieval.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_main.h  |   2 +-
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 398 +++++++++++++++++++++-
 2 files changed, 383 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.h b/drivers/infiniband/hw/zrdma/zrdma_main.h
index 060d6f627b0d..62e52e5a23ee 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_main.h
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
@@ -208,7 +208,7 @@ static inline void zxdh_free_rsrc(struct zxdh_pci_f *rf,
 	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
 }
 
-int zxdh_get_del_rdma_name(const char *sbdf, char *name);
+int zxdh_get_del_rdma_name(const char *sbdf, char *name, size_t name_len);
 int zxdh_ctrl_init_hw(struct zxdh_pci_f *rf);
 int zxdh_ib_register_device(struct zxdh_device *zdev);
 void zxdh_del_handler(struct zxdh_handler *hdl);
diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index 54b016ea8f5d..a16e00e78535 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -11,6 +11,7 @@
 #include <rdma/ib_cache.h>
 #include <rdma/ib_user_verbs.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 
 static void zxdh_sc_pd_init(struct zxdh_sc_dev *dev, struct zxdh_sc_pd *pd,
 			    u32 pd_id, int abi_ver)
@@ -55,7 +56,8 @@ static int zxdh_alloc_pd(struct ib_pd *pd, struct ib_udata *udata)
 	err = zxdh_alloc_rsrc(rf, rf->allocated_pds, rf->max_pd, &pd_id,
 			      &rf->next_pd);
 	if (err) {
-		pr_warn("zrdma: zxdh_alloc_rsrc failed err=%d\n", err);
+		pr_warn_ratelimited("zrdma: PD allocation failed err=%d\n",
+				   err);
 		return err;
 	}
 
@@ -157,7 +159,7 @@ static int zxdh_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 	ucontext->zdev = zdev;
 	ucontext->abi_ver = req.userspace_ver;
 
-	uresp.srq_db_bar_off = SRQ_DB_OFFSET;
+	uresp.srq_db_bar_off = SRQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM;
 
 	ucontext->sq_db_mmap_entry =
 		zxdh_user_mmap_entry_insert(ucontext, SQ_DB_BAR_OFF,
@@ -332,29 +334,327 @@ static int zxdh_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	return ret;
 }
 
-static void zxdh_init_roce_device(struct zxdh_device *zdev)
+/* Fetch the driver info for @zdev->netdev, or for its first lower device
+ * when it is a bond. adj_list.lower is rtnl_lock protected, but the core
+ * may call this from a netdev notifier already holding rtnl_lock.
+ */
+static bool zxdh_get_drvinfo(struct zxdh_device *zdev,
+			     struct ethtool_drvinfo *info)
 {
-	zdev->ibdev.node_type = RDMA_NODE_IB_CA;
-	addrconf_addr_eui48((u8 *)&zdev->ibdev.node_guid,
-			    zdev->netdev->dev_addr);
+	struct net_device *slave = NULL, *dev;
+	struct list_head *iter;
+	bool locked = false;
+	bool ret = false;
+
+	memset(info, 0, sizeof(*info));
+
+	if ((zdev->netdev->priv_flags & IFF_BONDING) && rtnl_trylock()) {
+		netdev_for_each_lower_dev(zdev->netdev, slave, iter)
+			break;
+		locked = true;
+	}
+
+	dev = slave ? slave : zdev->netdev;
+	if (dev->ethtool_ops && dev->ethtool_ops->get_drvinfo) {
+		dev->ethtool_ops->get_drvinfo(dev, info);
+		ret = true;
+	}
+
+	if (locked)
+		rtnl_unlock();
+
+	return ret;
 }
 
-static int zxdh_init_rdma_device(struct zxdh_device *zdev)
+static void extract_version(const char *input, char *output)
 {
+	const char *v_start, *p;
+	int dots = 0;
+
+	if (!output || !input)
+		goto fail;
+
+	if (strstr(input, " (")) {
+		v_start = input;
+		for (p = v_start; *p && *p != ' '; p++) {
+			if (*p == '.' && ++dots == 4)
+				break;
+			*output++ = *p;
+		}
+	} else {
+		/* Format: "E310-V25.30.103.01" - find 'V' after last '-' */
+		const char *last_dash = strrchr(input, '-');
+
+		if (!last_dash)
+			goto fail;
+		v_start = strstr(last_dash, "V");
+		if (!v_start)
+			goto fail;
+		v_start++;  /* skip 'V' */
+
+		for (p = v_start; *p && dots < 4; p++) {
+			if (*p == '.' && ++dots == 4)
+				break;
+			*output++ = *p;
+		}
+	}
+
+fail:
+	if (output)
+		*output = '\0';
+}
+
+static int zxdh_query_device(struct ib_device *ibdev,
+			     struct ib_device_attr *props,
+			     struct ib_udata *udata)
+{
+	struct zxdh_device *zdev = to_zdev(ibdev);
 	struct pci_dev *pcidev = zdev->rf->pcidev;
+	int major, sub_major, minor, sub_minor;
+	struct ethtool_drvinfo info;
+	char extracted_version[32];
+
+	if (zxdh_get_drvinfo(zdev, &info)) {
+		extract_version(info.fw_version, extracted_version);
+		if (sscanf(extracted_version, "%d.%d.%d.%d", &major,
+			   &sub_major, &minor, &sub_minor) != 4) {
+			major = 0;
+			sub_major = 0;
+			minor = 0;
+			sub_minor = 0;
+		}
+	} else {
+		major = sub_major = minor = sub_minor = 0;
+	}
 
-	if (zdev->roce_mode)
-		zxdh_init_roce_device(zdev);
+	if (udata->inlen || udata->outlen)
+		return -EINVAL;
+
+	memset(props, 0, sizeof(*props));
+	addrconf_addr_eui48((u8 *)&props->sys_image_guid,
+			    zdev->netdev->dev_addr);
+	props->fw_ver = ((u64)major << 48 | (u64)sub_major << 32 |
+			 (u64)minor << 16 | sub_minor);
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
+	if (rdma_protocol_roce(ibdev, 1)) {
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
+static u32 zxdh_get_eth_netdev_speed(struct zxdh_device *zdev, u32 port_num)
+{
+	struct ethtool_link_ksettings lksettings;
+	u32 netdev_speed = (u32)SPEED_UNKNOWN;
+	struct zxdh_pci_f *rf = zdev->rf;
+	int rc;
+
+	if (rdma_port_get_link_layer(&zdev->ibdev, port_num) !=
+	    IB_LINK_LAYER_ETHERNET)
+		return -EINVAL;
+
+	if (zdev->netdev_speed != (u32)SPEED_UNKNOWN)
+		return zdev->netdev_speed;
+
+	if (rf->drv_np_cap == ZXDH_RDMA_COMMON_FUNC_CAP &&
+	    rf->common_func_num_max > ZXDH_FUNC_NETDEV_SPEED_GET) {
+		rc = rf->gen_ops.zxdh_common_func(zdev->zxdh_adev->parent,
+						  &netdev_speed,
+						  ZXDH_FUNC_NETDEV_SPEED_GET);
+
+		if (rc || netdev_speed == (u32)SPEED_UNKNOWN)
+			netdev_speed = SPEED_1000;
+		else
+			zdev->netdev_speed = netdev_speed;
+	} else {
+		if (!rtnl_trylock())
+			return SPEED_1000;
+
+		rc = __ethtool_get_link_ksettings(zdev->netdev, &lksettings);
+		rtnl_unlock();
+
+		if (!rc &&
+		    lksettings.base.speed != (u32)SPEED_UNKNOWN) {
+			netdev_speed = lksettings.base.speed;
+			zdev->netdev_speed = netdev_speed;
+		} else {
+			netdev_speed = SPEED_1000;
+		}
+	}
+
+	return netdev_speed;
+}
+
+static int zxdh_get_eth_speed(struct ib_device *dev, struct net_device *netdev,
+			      u32 port_num, u16 *speed, u8 *width)
+{
+	struct zxdh_device *zdev = to_zdev(dev);
+	u32 netdev_speed;
+
+	if (zdev)
+		netdev_speed = zxdh_get_eth_netdev_speed(zdev, port_num);
 	else
-		return -EPFNOSUPPORT;
+		netdev_speed = SPEED_1000;
+
+	if (netdev_speed <= SPEED_1000) {
+		*width = IB_WIDTH_1X;
+		*speed = IB_SPEED_SDR;
+	} else if (netdev_speed <= SPEED_10000) {
+		*width = IB_WIDTH_1X;
+		*speed = IB_SPEED_FDR10;
+	} else if (netdev_speed <= SPEED_20000) {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_DDR;
+	} else if (netdev_speed <= SPEED_25000) {
+		*width = IB_WIDTH_1X;
+		*speed = IB_SPEED_EDR;
+	} else if (netdev_speed <= SPEED_40000) {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_FDR10;
+	} else if (netdev_speed <= SPEED_100000) {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_EDR;
+	} else {
+		*width = IB_WIDTH_4X;
+		*speed = IB_SPEED_HDR;
+	}
 
-	zdev->ibdev.phys_port_cnt = 1;
-	zdev->ibdev.num_comp_vectors = zdev->rf->ceqs_count;
-	zdev->ibdev.dev.parent = &pcidev->dev;
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
+	zxdh_get_eth_speed(ibdev, netdev, port, &props->active_speed,
+			   &props->active_width);
+	if (rdma_protocol_roce(ibdev, 1)) {
+		props->gid_tbl_len = 255;
+		props->ip_gids = true;
+		props->pkey_tbl_len = ZXDH_PKEY_TBL_SZ;
+	} else {
+		props->gid_tbl_len = 1;
+	}
+	props->port_cap_flags |= IB_PORT_CM_SUP;
+	props->max_msg_sz = MAX_MSG_SZ;
+	props->qkey_viol_cntr = 0;
 
 	return 0;
 }
 
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
+static int zxdh_query_gid_roce(struct ib_device *ibdev, u32 port, int index,
+			       union ib_gid *gid)
+{
+	int ret;
+
+	ret = rdma_query_gid(ibdev, port, index, gid);
+	if (ret == -EAGAIN) {
+		memcpy(gid, &zgid, sizeof(*gid));
+		return 0;
+	}
+
+	return ret;
+}
+
+static int zxdh_roce_port_immutable(struct ib_device *ibdev, u32 port_num,
+				    struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int err;
+
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP |
+				    RDMA_CORE_CAP_PROT_ROCE;
+	err = ib_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
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
+	strscpy(str, extracted_version, IB_FW_VERSION_NAME_MAX);
+}
+
 static const struct ib_device_ops zxdh_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ZRDMA,
@@ -364,6 +664,13 @@ static const struct ib_device_ops zxdh_dev_ops = {
 	.dealloc_driver = zxdh_ib_dealloc_device,
 	.dealloc_pd = zxdh_dealloc_pd,
 	.dealloc_ucontext = zxdh_dealloc_ucontext,
+	.query_device = zxdh_query_device,
+	.query_port = zxdh_query_port,
+	.query_gid = zxdh_query_gid_roce,
+	.query_pkey = zxdh_query_pkey,
+	.get_link_layer = zxdh_get_link_layer,
+	.get_port_immutable = zxdh_roce_port_immutable,
+	.get_dev_fw_str = zxdh_get_dev_fw_str,
 	.mmap = zxdh_mmap,
 	.mmap_free = zxdh_mmap_free,
 
@@ -371,19 +678,78 @@ static const struct ib_device_ops zxdh_dev_ops = {
 	INIT_RDMA_OBJ_SIZE(ib_ucontext, zxdh_ucontext, ibucontext),
 };
 
+static void zxdh_init_roce_device(struct zxdh_device *zdev)
+{
+	zdev->ibdev.node_type = RDMA_NODE_IB_CA;
+	addrconf_addr_eui48((u8 *)&zdev->ibdev.node_guid,
+			    zdev->netdev->dev_addr);
+}
+
+static int zxdh_init_rdma_device(struct zxdh_device *zdev)
+{
+	struct pci_dev *pcidev = zdev->rf->pcidev;
+
+	if (zdev->roce_mode)
+		zxdh_init_roce_device(zdev);
+	else
+		return -EPFNOSUPPORT;
+
+	zdev->ibdev.phys_port_cnt = 1;
+	zdev->ibdev.num_comp_vectors = zdev->rf->ceqs_count;
+	zdev->ibdev.dev.parent = &pcidev->dev;
+
+	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
+
+	return 0;
+}
+
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
 
-	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
+	ret = zxdh_get_del_rdma_name(pci_name(zdev->rf->pcidev), name,
+				      IB_DEVICE_NAME_MAX);
+	if (ret)
+		snprintf(name, IB_DEVICE_NAME_MAX, "%s", "zrdma%d");
 
-	ret = ib_register_device(&zdev->ibdev, "zrdma%d", zdev->rf->hw.device);
+	ret = ib_device_set_netdev(&zdev->ibdev, zdev->netdev, 1);
 	if (ret)
-		pr_err("zrdma: Register RDMA device fail\n");
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
-- 
2.27.0

