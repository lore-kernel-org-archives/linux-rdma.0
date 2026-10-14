Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD944A260F;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016479; cv=none; b=I87xWSjTwo8Amonw/TfzGDquI366OuxPib+pF/tO+7wnVYJEctUdj4UxKUfkRhfTEuOrX6cX8Pz01/Z6rfDvNztp/s3gLvwvJCoxJg/cdCRN2TENIcBVnIqO8Qlqj5Tz3n59cOf7lcuDXuovlmdi6+6/QXdOPcHwEtsWj/gl9zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016479; c=relaxed/simple;
	bh=J1Ol1QMPPSKruHHNVnPNMjyedy8qIhT9ZJmZ+iwDZEk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m9wzRxoG1S4ftM04q2BM7Y6hTdxJtV+2JWT1bss1MSXwk0oSLYTbdq4XtZP4pUqRLizNV7B7j7B04k78N7A8Z6e/TXJXUp2Qj0MJSMr0YQbrwqeTQ3Va/ChNhmOhhtNp3QkRCzdhnw/69a6yYtpwObU0wpiPabgr1T+WzSbQUi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6mkD9i8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6mkD9i8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5910DC2BCF5;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792016479;
	bh=J1Ol1QMPPSKruHHNVnPNMjyedy8qIhT9ZJmZ+iwDZEk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=W6mkD9i82kFaxlK8pPKUNYodUdkzny+RgKIkBbmO5HdQuoxFqjFAxZJe3JshicfTO
	 Ef9QvM77gsCouUAYdvfpbE5RdsLM/K4jVmIBUw5sLmjYcIVXF7A64jIBnTIszR7LDz
	 vseMAtFfPagsnglGAJzHhLFCNdxPH/GJczFNLyBvio4jlu8BzcqQfvDutkuJ91EWEM
	 2IKkXAYN8aq1b255IVjF0aVFY27qyr7tf4+loJV9yv6IkhS0KsIOsTZpMkL3xnBZ5k
	 U+UwsSug8YEQXCRn9S4Dj1FzEqm4FF+YrT6q4Aoj2S9Gl7aSVN0TJPdqqV3q57/eVo
	 Ikp8BbVo/VVgw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B68BCC6B30;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Wed, 14 Oct 2026 15:21:11 -0700
Subject: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792016478; l=10408;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=crnEnjuKd1pOZM8IA2qQL2sUKlyP/QlqfCD/cFgooYY=;
 b=CSq/Yn/pzw/tSfYOWGOyBAjRH6WAH4Rg3dHyAO1hjaugl+Z45CDZ1odlsmR+/ojiuOMt8yC5w
 jwlN2B5X3zpB+u7KXsi4UB1OT7Jb2+K/6vzAz1vAGk+lH06oqdOKKgb
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com

From: Eric Davis <eric.davis@broadcom.com>

Ultra Ethernet runs over two encapsulations: UDP and IP. Each becomes
a new GID type. A port can then hold both UET and RoCE GIDs, with the
transport following from the GID a queue pair is given, the driver
enforces that.

These UET ports build their GID table from a netdev, as RoCE does. Added
rdma_port_gids_from_netdev() and use it where the code tested for RoCE
alone.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/cache.c         | 12 +++++----
 drivers/infiniband/core/cma.c           |  4 +++
 drivers/infiniband/core/device.c        |  2 +-
 drivers/infiniband/core/nldev.c         |  2 ++
 drivers/infiniband/core/roce_gid_mgmt.c |  6 +++--
 drivers/infiniband/core/verbs.c         |  4 +++
 include/rdma/ib_verbs.h                 | 48 ++++++++++++++++++++++++++++++---
 include/uapi/rdma/ib_user_ioctl_verbs.h |  2 ++
 8 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 647a547e2d7f..d5e17a36f186 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -139,6 +139,8 @@ static const char * const gid_type_str[] = {
 	[IB_GID_TYPE_IB]	= "IB/RoCE v1",
 	[IB_GID_TYPE_ROCE]	= "IB/RoCE v1",
 	[IB_GID_TYPE_ROCE_UDP_ENCAP]	= "RoCE v2",
+	[IB_GID_TYPE_UET_UDP]		= "UET UDP",
+	[IB_GID_TYPE_UET_IP]		= "UET IP",
 };
 
 const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
@@ -392,10 +394,10 @@ static void del_gid(struct ib_device *ib_dev, u32 port,
 	write_lock_irq(&table->rwlock);
 	entry = table->data_vec[ix];
 	entry->state = GID_TABLE_ENTRY_PENDING_DEL;
-	/*
-	 * For non RoCE protocol, GID entry slot is ready to use.
+	/* Where the GID table is not derived from a netdev, the entry slot is
+	 * ready to use.
 	 */
-	if (!rdma_protocol_roce(ib_dev, port))
+	if (!rdma_port_gids_from_netdev(ib_dev, port))
 		table->data_vec[ix] = NULL;
 	write_unlock_irq(&table->rwlock);
 
@@ -447,7 +449,7 @@ static int add_modify_gid(struct ib_gid_table *table,
 	if (!entry)
 		return -ENOMEM;
 
-	if (rdma_protocol_roce(attr->device, attr->port_num)) {
+	if (rdma_port_gids_from_netdev(attr->device, attr->port_num)) {
 		ret = add_roce_gid(entry);
 		if (ret)
 			goto done;
@@ -1459,7 +1461,7 @@ ib_cache_update(struct ib_device *device, u32 port, bool update_gids,
 		goto err;
 	}
 
-	if (!rdma_protocol_roce(device, port) && update_gids) {
+	if (!rdma_port_gids_from_netdev(device, port) && update_gids) {
 		ret = config_non_roce_gid_cache(device, port,
 						tprops);
 		if (ret)
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1acf7..7dedf93ac465 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -293,6 +293,10 @@ int cma_set_default_gid_type(struct cma_device *cma_dev,
 	if (!rdma_is_port_valid(cma_dev->device, port))
 		return -EINVAL;
 
+	if (default_gid_type == IB_GID_TYPE_UET_UDP ||
+	    default_gid_type == IB_GID_TYPE_UET_IP)
+		return -EINVAL;
+
 	if (default_gid_type == IB_GID_TYPE_IB &&
 	    rdma_protocol_roce_eth_encap(cma_dev->device, port))
 		default_gid_type = IB_GID_TYPE_ROCE;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 29af9fe860e2..7c65a9373701 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2567,7 +2567,7 @@ void ib_enum_roce_netdev(struct ib_device *ib_dev,
 	u32 port;
 
 	rdma_for_each_port (ib_dev, port)
-		if (rdma_protocol_roce(ib_dev, port)) {
+		if (rdma_port_gids_from_netdev(ib_dev, port)) {
 			struct net_device *idev =
 				ib_device_get_netdev(ib_dev, port);
 
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 849a5db54e1c..91b7be84b15f 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -350,6 +350,8 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL, "iw");
 	else if (rdma_protocol_roce(device, port))
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL, "roce");
+	else if (rdma_protocol_uet(device, port))
+		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL, "uet");
 	else if (rdma_protocol_usnic(device, port))
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL,
 				     "usnic");
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 4a2a4638b476..214af921341a 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -75,6 +75,8 @@ static const struct {
 } PORT_CAP_TO_GID_TYPE[] = {
 	{rdma_protocol_roce_eth_encap, IB_GID_TYPE_ROCE},
 	{rdma_protocol_roce_udp_encap, IB_GID_TYPE_ROCE_UDP_ENCAP},
+	{rdma_protocol_uet_udp, IB_GID_TYPE_UET_UDP},
+	{rdma_protocol_uet_ip, IB_GID_TYPE_UET_IP},
 };
 
 #define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)
@@ -84,7 +86,7 @@ unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u32 port)
 	int i;
 	unsigned int ret_flags = 0;
 
-	if (!rdma_protocol_roce(ib_dev, port))
+	if (!rdma_port_gids_from_netdev(ib_dev, port))
 		return 1UL << IB_GID_TYPE_IB;
 
 	for (i = 0; i < CAP_TO_GID_TABLE_SIZE; i++)
@@ -526,7 +528,7 @@ void rdma_roce_rescan_port(struct ib_device *ib_dev, u32 port)
 {
 	struct net_device *ndev = NULL;
 
-	if (rdma_protocol_roce(ib_dev, port)) {
+	if (rdma_port_gids_from_netdev(ib_dev, port)) {
 		ndev = ib_device_get_netdev(ib_dev, port);
 		if (!ndev)
 			return;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index edf62652f9d3..24db88e6d3fa 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -862,6 +862,10 @@ int ib_init_ah_attr_from_wc(struct ib_device *device, u32 port_num,
 
 	might_sleep();
 
+	if (rdma_protocol_uet(device, port_num) &&
+	    !rdma_protocol_roce(device, port_num))
+		return -EPROTONOSUPPORT;
+
 	memset(ah_attr, 0, sizeof *ah_attr);
 	ah_attr->type = rdma_ah_find_type(device, port_num);
 	if (rdma_cap_eth_ah(device, port_num)) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d6eaa3fee66e..4e3a5c38cbe8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -145,6 +145,8 @@ enum ib_gid_type {
 	IB_GID_TYPE_IB = IB_UVERBS_GID_TYPE_IB,
 	IB_GID_TYPE_ROCE = IB_UVERBS_GID_TYPE_ROCE_V1,
 	IB_GID_TYPE_ROCE_UDP_ENCAP = IB_UVERBS_GID_TYPE_ROCE_V2,
+	IB_GID_TYPE_UET_UDP = IB_UVERBS_GID_TYPE_UET_UDP,
+	IB_GID_TYPE_UET_IP = IB_UVERBS_GID_TYPE_UET_IP,
 	IB_GID_TYPE_SIZE
 };
 
@@ -664,10 +666,16 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 #define RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP 0x00800000
 #define RDMA_CORE_CAP_PROT_RAW_PACKET   0x01000000
 #define RDMA_CORE_CAP_PROT_USNIC        0x02000000
+#define RDMA_CORE_CAP_PROT_UET_UDP      0x04000000
+#define RDMA_CORE_CAP_PROT_UET_IP       0x08000000
+
+#define RDMA_CORE_CAP_PROT_UET         (RDMA_CORE_CAP_PROT_UET_UDP \
+					| RDMA_CORE_CAP_PROT_UET_IP)
 
 #define RDMA_CORE_PORT_IB_GRH_REQUIRED (RDMA_CORE_CAP_IB_GRH_REQUIRED \
 					| RDMA_CORE_CAP_PROT_ROCE     \
-					| RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP)
+					| RDMA_CORE_CAP_PROT_ROCE_UDP_ENCAP \
+					| RDMA_CORE_CAP_PROT_UET)
 
 #define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
 					| RDMA_CORE_CAP_IB_MAD \
@@ -691,6 +699,11 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 #define RDMA_CORE_PORT_INTEL_OPA       (RDMA_CORE_PORT_IBA_IB  \
 					| RDMA_CORE_CAP_OPA_MAD)
 
+#define RDMA_CORE_PORT_UET_UDP		(RDMA_CORE_CAP_PROT_UET_UDP \
+					| RDMA_CORE_CAP_ETH_AH)
+#define RDMA_CORE_PORT_UET_IP		(RDMA_CORE_CAP_PROT_UET_IP \
+					| RDMA_CORE_CAP_ETH_AH)
+
 #define RDMA_CORE_PORT_RAW_PACKET	(RDMA_CORE_CAP_PROT_RAW_PACKET)
 
 #define RDMA_CORE_PORT_USNIC		(RDMA_CORE_CAP_PROT_USNIC)
@@ -3407,6 +3420,34 @@ static inline bool rdma_protocol_roce_eth_encap(const struct ib_device *device,
 	       RDMA_CORE_CAP_PROT_ROCE;
 }
 
+static inline bool rdma_protocol_uet(const struct ib_device *device,
+				     u32 port_num)
+{
+	return device->port_data[port_num].immutable.core_cap_flags &
+	       RDMA_CORE_CAP_PROT_UET;
+}
+
+static inline bool rdma_protocol_uet_udp(const struct ib_device *device,
+					 u32 port_num)
+{
+	return device->port_data[port_num].immutable.core_cap_flags &
+	       RDMA_CORE_CAP_PROT_UET_UDP;
+}
+
+static inline bool rdma_protocol_uet_ip(const struct ib_device *device,
+					u32 port_num)
+{
+	return device->port_data[port_num].immutable.core_cap_flags &
+	       RDMA_CORE_CAP_PROT_UET_IP;
+}
+
+static inline bool rdma_port_gids_from_netdev(const struct ib_device *device,
+					      u32 port_num)
+{
+	return rdma_protocol_roce(device, port_num) ||
+	       rdma_protocol_uet(device, port_num);
+}
+
 static inline bool rdma_protocol_iwarp(const struct ib_device *device,
 				       u32 port_num)
 {
@@ -3677,7 +3718,7 @@ static inline size_t rdma_max_mad_size(const struct ib_device *device,
 static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
 					   u32 port_num)
 {
-	return rdma_protocol_roce(device, port_num) &&
+	return rdma_port_gids_from_netdev(device, port_num) &&
 		device->ops.add_gid && device->ops.del_gid;
 }
 
@@ -4984,7 +5025,8 @@ void rdma_move_ah_attr(struct rdma_ah_attr *dest, struct rdma_ah_attr *src);
 static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
 						       u32 port_num)
 {
-	if (rdma_protocol_roce(dev, port_num))
+	if (rdma_protocol_roce(dev, port_num) ||
+	    rdma_protocol_uet(dev, port_num))
 		return RDMA_AH_ATTR_TYPE_ROCE;
 	if (rdma_protocol_ib(dev, port_num)) {
 		if (rdma_cap_opa_ah(dev, port_num))
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 21f86cc7bb1f..ed72f48960f8 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -263,6 +263,8 @@ enum ib_uverbs_gid_type {
 	IB_UVERBS_GID_TYPE_IB,
 	IB_UVERBS_GID_TYPE_ROCE_V1,
 	IB_UVERBS_GID_TYPE_ROCE_V2,
+	IB_UVERBS_GID_TYPE_UET_UDP,
+	IB_UVERBS_GID_TYPE_UET_IP,
 };
 
 struct ib_uverbs_gid_entry {

-- 
2.56.0


