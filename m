Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283266;
	b=rpiCjngM8XLIk7ZXvZQYze7F6t7obpSlzIEzj6rq21WJm8uaSomQwVsoJJjfWakzgBUi
	 jQYfi9CuBhJ0pcevjD+lXojU5NY+iWrJYTX/yXiTlJ7EEH5LVAP1W16K+wUNx/H1Llohl
	 MYhy/U8LzbbT+DPCCfe/pfAt19yEZIkuQClAZvg9WjiQOyQm6qIJnFnb8EfTMNzsrdiGq
	 GWYLZc79BtCHgYgcH3TRPxoU2wdCSV+nSilnjv9eUfYdvAiU+tE5Rz5se+dYJoSsKpyt1
	 c+qRONGGL4+pkTo3mFs/Axlmm2tixUqe0B8GWb0Lu+3nWkVNmRw+qnqulUptBOI1v7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283266;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=H1MY2Veoe1KEP0n0qpFzfjS3N+CXyCKQMUjuUSgdHYI=;
	b=on1fETFYYk4ne9UMEhwfMftlQAWCLna5q9W8J7j1qYY3/L9b6vPjrs3H0pjayJqL/NGo
	 DhE+cRHV1kN9j1BzdzMr8ckO7tmqx3CR9xBpi7BDBrnel+DD2naLKTxvnz8/wYI8MPiwU
	 Xe8Trh5isFetk3VqhQhGsZiI0oBpSAUrMO9bUXatC6vTvWNoK3BTRrP1KxzQnN6rRKqVV
	 /zN6ghfcoUrH1gvCQfIGRsC4DmeFSTFmxGtsEePzGn8JhyMJTbaRIKR6W3sdcu+BxEG5D
	 H5Qx027I9oj8M4jrIlL7hgtrc0AdhToPDmZ4beilqsVvgACQtPAvH1Crbjn/ZbvBIGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAtLkbRC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F37460A5BC1;
	Tue, 10 Nov 2026 04:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UAtLkbRC
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283266;
	b=GYYiixiEA+M50aFQbZlzspM12odLsMMYNUguI/zvjO7LqDO2WM8gJAfF8TgFCzVO++qt
	 NM4CB2XEloy3mD0dWJrcwQkZLfUlWwF/1GNeNBhbHEgDE9jtFUxzlIEzKPYqOY7Vxh7Jd
	 R30cyqtdyvRiOa690iZssgxbbOZqnriRxMS80nNycNjnKcNhUqF0561LooNKhueSpMLrc
	 PC2snapTDyqxT/En7b0UsMzqrqQqcv+9oWYvQiCYg5Lv+0CswxmSfBvIG5WY1M68lkmZg
	 Q2VQjyW04VDiSwXSfIZiUuehKR4NYjCwUVoHJXzqkGnPR+HDGREvHyxdKAc80/td/EQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283266;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=H1MY2Veoe1KEP0n0qpFzfjS3N+CXyCKQMUjuUSgdHYI=;
	b=s5A9IALJEO8thmFJ93TIco1wqJIrKcHevKDyLs8vLEKIvxYokoRZcQvG34Rz/RqpnsgG
	 Elbp6vq6eQUYXZ6LDJqvlGvO/7AppasHU9IKp7rnn7ebvfiGYdrd4Fhfvuz24l2N/OyHF
	 d9pENRYdVeIZ51kqNYgLkidpGTGIoum4hhSyUbD2Ym5xvjaqzfali75847GferJH+efTP
	 ct6lgy0lLis1H2bdsO+h2ltXqLVLPxfI372ArEq0xu6YBdcOzvUjJlygKZWJOxp5bJdm6
	 /FTk0KqS+uBVl3/QbtKfTvCtyCqyl7j1AUnznXhsdDczcS/QJuJW5kGAQWyDNtcVdsw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 192181F00903;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283266;
	bh=H1MY2Veoe1KEP0n0qpFzfjS3N+CXyCKQMUjuUSgdHYI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UAtLkbRCgZFvOMqcJ6gjEFHPlVkCPuNxqUNwv4RBbE6MlaMVqdtrvRXzwmQgP8izH
	 YIJaIsxPf/FC2sfWNe+aVKYeWf1fDh0m8zkCNDauNQKAxEPeegqhn7+9Jple3fWLlI
	 eoEjlPZAVo4sshAnGScCSZYSXgphr/8G/eGngxaNANmgoeRktg8UMyVj6vht3/G4Mm
	 LTDKDJF8b2SfMUPGYZB3gX9ATo+f/GSm7MD17YPbI9u9Y3sSdvh3nNIg+E/G7BQSNj
	 TSz9F6+o3Uixn7ehMI/fANCjT9qOEuECmd/Nnd8fl9bSUM9tUDfWDJvItX2ETUihz6
	 2JX5TmQeS709A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9661948800;
	Tue, 10 Nov 2026 04:00:51 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:35 -0800
Subject: [PATCH rdma-next v3 02/13] RDMA/core: add the UET GID types
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-uet-ib-core-v3-2-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=11233;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=atYJ36/YY1k5Pp9gS3XTF4QURcSue6mTxl2cvhNkKAM=;
 b=641tRpEO5vTMq6xye82mmxnELiydQCOzVrQLofGzGq8wk/RWXAY0R4ab6O67wyshWSyPmsJ8m
 1THpd6bYEA6C/pJk8FQsGAU2rGJ4vUHuTI77vzVcmMPHYaMwMeCO/jM
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

Ultra Ethernet runs over two encapsulations: UDP and IP. Each becomes
a new GID type. A port can then hold both UET and RoCE GIDs, with the
transport following from the GID a queue pair is given; the driver
enforces that.

These UET ports build their GID table from a netdev, as RoCE does. Added
rdma_port_gids_from_netdev() and use it where the code tested for RoCE
alone. The CM has no use for a UET GID, so RDMA-CM never makes one a
port's default GID type.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/cache.c         | 12 +++++----
 drivers/infiniband/core/cma.c           |  9 ++++++-
 drivers/infiniband/core/device.c        |  2 +-
 drivers/infiniband/core/nldev.c         |  2 ++
 drivers/infiniband/core/roce_gid_mgmt.c |  6 +++--
 drivers/infiniband/core/verbs.c         |  4 +++
 include/rdma/ib_verbs.h                 | 48 ++++++++++++++++++++++++++++++---
 include/uapi/rdma/ib_user_ioctl_verbs.h |  2 ++
 8 files changed, 73 insertions(+), 12 deletions(-)

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
index 337a49d1acf7..59cb526fe2a2 100644
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
@@ -5425,10 +5429,13 @@ static int cma_add_one(struct ib_device *device)
 	rdma_for_each_port (device, i) {
 		supported_gids = roce_gid_type_mask_support(device, i);
 		WARN_ON(!supported_gids);
+		/* the CM has no use for a UET GID, so a UET-only port keeps 0 */
+		supported_gids &= ~(BIT(IB_GID_TYPE_UET_UDP) |
+				    BIT(IB_GID_TYPE_UET_IP));
 		if (supported_gids & (1 << CMA_PREFERRED_ROCE_GID_TYPE))
 			cma_dev->default_gid_type[i - rdma_start_port(device)] =
 				CMA_PREFERRED_ROCE_GID_TYPE;
-		else
+		else if (supported_gids)
 			cma_dev->default_gid_type[i - rdma_start_port(device)] =
 				find_first_bit(&supported_gids, BITS_PER_LONG);
 		cma_dev->default_roce_tos[i - rdma_start_port(device)] = 0;
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
index 7d52d3036208..1299125752d8 100644
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


