Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761A542BEA0;
	Tue, 11 Aug 2026 09:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441384; cv=none; b=mDFObVU909kFkDwqB9pHaT1wG6kUQzA9v2xkY8w6cWnoK3Rh8jXGR+g68IfTW8T/KhU5nCpKcfRIGlUY4LQRvbWCjDZhB6gPuaqVeRc0iXjnMk2raGp9PQi68CfMyqqoCb6T779a/OMacratxcB/Lsg21wWTorIhLaeOsd6iXwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441384; c=relaxed/simple;
	bh=JCtLJJLGcnc2nyskBdNqhUkdgZRb0mxTV5Oylo08czc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzjG4QnLgJCb3H1qGcD3BhRsBr4mmPZXWzcFAKopBjhq+p3Oib0V7+9UE/5vSUX+NdrngecwsOUE7fpOFdhmvWWbeRF/j+vCJQ8q5BJgeYwlG2gKGf9YsVVTlhOwr5Aj7Y3vl2YRFQgGbZjJlGjZCWyK4feLcsZBCDbLmCEebyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hK69v5XXjz4yjG7;
	Tue, 11 Aug 2026 17:42:59 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
	by mse-fl1.zte.com.cn with SMTP id 67B9ghmH089569;
	Tue, 11 Aug 2026 17:42:43 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 11 Aug 2026 17:42:46 +0800
X-Zmail-TransId: 3e816a7aee95013-444b6
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v5 7/7] RDMA/zrdma: Implement device and port query operations
Date: Tue, 11 Aug 2026 17:37:40 +0800
Message-ID: <20260811093740.2607476-8-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 67B9ghmH089569
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 11 Aug 2026 17:42:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A7AEEA3.000/4hK69v5XXjz4yjG7

Add implementation for querying device attributes, port attributes,
GID, PKey, and link layer information. Also include firmware
version string retrieval.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_verbs.c | 368 +++++++++++++++++++++-
 1 file changed, 355 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index 2194d34b6438..de691662922f 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -315,29 +315,303 @@ static int zxdh_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	return ret;
 }
 
-static void zxdh_init_roce_device(struct zxdh_device *zdev)
+static void extract_version(const char *input, char *output)
 {
-	zdev->ibdev.node_type = RDMA_NODE_IB_CA;
-	addrconf_addr_eui48((u8 *)&zdev->ibdev.node_guid,
-			    zdev->netdev->dev_addr);
+	const char *last_dash_pos = strrchr(input, '-');
+
+	if (last_dash_pos) {
+		const char *v_pos = strstr(last_dash_pos, "V");
+
+		if (v_pos)
+			strscpy(output, v_pos + 1, 12);
+		else
+			output[0] = '\0';
+	} else {
+		output[0] = '\0';
+	}
 }
 
-static int zxdh_init_rdma_device(struct zxdh_device *zdev)
+static int zxdh_query_device(struct ib_device *ibdev,
+			     struct ib_device_attr *props,
+			     struct ib_udata *udata)
 {
+	struct zxdh_device *zdev = to_zdev(ibdev);
 	struct pci_dev *pcidev = zdev->rf->pcidev;
+	int major, sub_major, minor, sub_minor;
+	struct net_device *slave = NULL;
+	struct ethtool_drvinfo info;
+	char extracted_version[16];
+	struct list_head *iter;
+
+	memset(&info, 0, sizeof(info));
+	if (zdev->netdev->priv_flags & IFF_BONDING) {
+		rcu_read_lock();
+		netdev_for_each_lower_dev(zdev->netdev, slave, iter) {
+			slave->ethtool_ops->get_drvinfo(slave, &info);
+			break;
+		}
+		rcu_read_unlock();
+		if (!slave) {
+			zdev->netdev->ethtool_ops->get_drvinfo(zdev->netdev,
+							       &info);
+		}
+	} else {
+		zdev->netdev->ethtool_ops->get_drvinfo(zdev->netdev, &info);
+	}
+	extract_version(info.fw_version, extracted_version);
+	if (sscanf(extracted_version, "%d.%d.%d.%d", &major, &sub_major, &minor,
+		   &sub_minor) != 4) {
+		major = 0;
+		sub_major = 0;
+		minor = 0;
+		sub_minor = 0;
+	}
 
-	if (zdev->roce_mode)
-		zxdh_init_roce_device(zdev);
+	if (udata->inlen || udata->outlen)
+		return -EINVAL;
+
+	memset(props, 0, sizeof(*props));
+	ether_addr_copy((u8 *)&props->sys_image_guid, zdev->netdev->dev_addr);
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
+		if (zdev->netdev_speed == (u32)SPEED_UNKNOWN) {
+			rtnl_lock();
+			rc = __ethtool_get_link_ksettings(zdev->netdev,
+							  &lksettings);
+			rtnl_unlock();
+
+			if (!rc &&
+			    lksettings.base.speed != (u32)SPEED_UNKNOWN) {
+				netdev_speed = lksettings.base.speed;
+				zdev->netdev_speed = netdev_speed;
+			} else {
+				netdev_speed = SPEED_1000;
+			}
+		} else {
+			netdev_speed = zdev->netdev_speed;
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
 
 	return 0;
 }
 
+static void zxdh_get_dev_fw_str(struct ib_device *dev, char *str)
+{
+	struct zxdh_device *zdev = to_zdev(dev);
+	struct net_device *slave = NULL;
+	struct ethtool_drvinfo info;
+	char extracted_version[16];
+	struct list_head *iter;
+
+	memset(&info, 0, sizeof(info));
+
+	if (zdev->netdev->priv_flags & IFF_BONDING) {
+		rcu_read_lock();
+		netdev_for_each_lower_dev(zdev->netdev, slave, iter) {
+			slave->ethtool_ops->get_drvinfo(slave, &info);
+			break;
+		}
+		rcu_read_unlock();
+		if (!slave) {
+			zdev->netdev->ethtool_ops->get_drvinfo(zdev->netdev,
+							       &info);
+		}
+		extract_version(info.fw_version, extracted_version);
+		snprintf(str, IB_FW_VERSION_NAME_MAX, "%s", extracted_version);
+		return;
+	}
+	zdev->netdev->ethtool_ops->get_drvinfo(zdev->netdev, &info);
+	extract_version(info.fw_version, extracted_version);
+	snprintf(str, IB_FW_VERSION_NAME_MAX, "%s", extracted_version);
+}
+
 static const struct ib_device_ops zxdh_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ZRDMA,
@@ -347,6 +621,13 @@ static const struct ib_device_ops zxdh_dev_ops = {
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
 
@@ -354,17 +635,78 @@ static const struct ib_device_ops zxdh_dev_ops = {
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
+	int err;
 
 	ret = zxdh_init_rdma_device(zdev);
 	if (ret)
 		return ret;
 
-	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
+	ret = zxdh_get_del_rdma_name(pci_name(zdev->rf->pcidev), name);
+	if (ret)
+		snprintf(name, IB_DEVICE_NAME_MAX, "%s", "zrdma%d");
+
+	ret = ib_device_set_netdev(&zdev->ibdev, zdev->netdev, 1);
+	if (ret)
+		goto error;
+
+	zdev->rf->hw.device = &zdev->rf->pcidev->dev;
+	dma_set_max_seg_size(zdev->rf->hw.device, SZ_1G);
 
-	ret = ib_register_device(&zdev->ibdev, "zrdma%d", zdev->rf->hw.device);
+	ret = ib_register_device(&zdev->ibdev, name, zdev->rf->hw.device);
+	if (ret) {
+		snprintf(name, IB_DEVICE_NAME_MAX, "%s", "zrdma%d");
+		err = ib_register_device(&zdev->ibdev, name,
+					 zdev->rf->hw.device);
+		if (err)
+			goto error;
+	}
+
+	zdev->ibdev_status = 1;
+	zxdh_port_ibevent(zdev);
+
+	return 0;
+
+error:
 	if (ret)
 		pr_err("zrdma: Register RDMA device fail\n");
 
-- 
2.27.0

