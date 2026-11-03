Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740475;
	b=Tj9tUGp3Z5knzL8LAIaRHEpPLSms+lcDbS1Vpsz9lwLZq4oRzMpg/6Fcd64w3OhnzmIw
	 8vft5/Skzz0JJAZKG5P6o/aca2L4TccZKyvuLsEG4t63AXJUSGl8HHFlDKHBpACFF3DH2
	 Imr5NqCc7sTRNjnyDf9mLpsIhr64AIXaw+ZcmkiyrlzOOxZcdVTUHeBnvu6yykqlxy/PO
	 6+s6QzGqQFV5Bzm+5xdXKh+sfftXf5LSuYLyBaV3BCOWUgh9YR1PcYWx8/u1zVKJIVIAT
	 dZ1olDdrKKaJiO9ZN+aAKV6xIaUX5FZNsvfGkQehBOJGqu18d3Y1l/fuhFngl+/upqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ZXklrxEfZsXJmWeyZiqGJ3XFPkU6qBB3CFReRDvTW60=;
	b=1QB9axHRL4lrFiSMP4DVzwxY66DN/uITxX5/1LTPu186Be8RnWtqYyHxq9edCIdIvADq
	 cQYLOxdGPo9A+oY1Yw6DHVSzo24jOULMaAUw2Snwdds5OxaO5708LJvnctOgQoFiLyd/6
	 Q+KJB/6XYQRGxuQGlVX2luKa265ieV6lnDj3K9Cdgdtv3f3vfKkEl1zeA5fk7jG2XDFUp
	 8gQEU476E86Syd3LDshroQBTL+5gn8T0iVr/1emcHWRLB19U6DHPlLM06erLx6wLHk7mG
	 3JVAH5YncFlKjHdVJFHIk96Q/+NRgXjQ3TtsU/hmZCs+nh4QnKpo2ZFDM7emK9PFLNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Q/rV7R/5";
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33AF6082BD0
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 21:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C33AF6082BD0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q/rV7R/5
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-14373747468so135679c88.1
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740474; x=1794345274; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXklrxEfZsXJmWeyZiqGJ3XFPkU6qBB3CFReRDvTW60=;
        b=Q/rV7R/5DRy9XYoVR14vDXr2CVLs77UshFQi+MBVkfEotAvkN6Mg0ugCHR6XEnWWrY
         tFFz7xTMZneqcYpskqsQAA2mEa9bPVLdxJU7y4jW6VHy1W5SNCU7Y3jSuxlki1YmLwAF
         Lup6TC7gihRrNTtb1FTMLwMJ9DUci6z0aMS1bP1OJMjxtwqoBswih6npdyWZ4e/etLB1
         QF9s+dQNKFGLsqyfqRrJDju8ysztDT1qH3u9LJ4uQ095DgLXkQlvF7xsvlDjKpVT2fdk
         cw+6vPnsS9NvEJHFadqpHbZNiWLSxuh7ba8CoG24JiA0s16KJGhG70tFwV9mC5xO/XuY
         d1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740474; x=1794345274;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZXklrxEfZsXJmWeyZiqGJ3XFPkU6qBB3CFReRDvTW60=;
        b=FZpb2yD+g057DUwFsko0Quf7X04tC/O3HFZR/vb8zk0vX/2jz9ggwX3BDANDOdZLK3
         93o4Gupc+QQOvdiEWyqJZrxKCR91GG7q4SN/ZI8q+goj1CxdpXutF6DuO7S6nr+Z7CkV
         hA8DPxC1BcWEqEFwQo1hbMTApMbbnRNFnPzpsWgCwlbDeY5UELOzaQilEmF97W3ypI7p
         AahwzWcwxASrq+fTfjGggoQhuUwam/mkE3t6WThm9oKASFp2H/uSFeYZTVwoEl14pg25
         4K/U9v4v8coTn+Hg43mABABpismu4gIzmy4c2Tm9IVb7TOn0iRiQtF2Zvh/OV1G6omkq
         47dA==
X-Forwarded-Encrypted: i=1; AKwUvByNtAp3RtKU/R+2onFA5DWRZxQde1PqdLPw724iXvF8P/9iQvJuD4d6C1D7k1y02dFB9qHJPIU7MAvm@vger.kernel.org
X-Gm-Message-State: APuU4Z9JHlLcjMxKQJJEzFufIY1Q3PfgigXIG2yJEUSYH0l/c2NZ5gdv
	ErPRhP7CHQNXch+p6e8IRzb0V6NkIxBcV5qtm7KiVFz+YYcJg8xyRQT9WFy+OaPXP+V9VT+PlG3
	2W4usapYC0sPo6W3Ik4jtGXpM3A==
X-Received: from dlak6.prod.google.com ([2002:a05:701b:2906:b0:1a7:2bf1:46cc])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4542:20b0:1b2:43cc:48 with SMTP id a92af1059eb24-1b243cc0084mr2074889c88.33.1793740473459;
 Tue, 03 Nov 2026 13:14:33 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:24 +0000
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103211424.127627-6-almasrymina@google.com>
Subject: [PATCH net-next v1 5/5] net: remove skb_mark_for_recycle()
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Willem de Bruijn <willemb@google.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Pavel Begunkov <asml.silence@gmail.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>, 
	Justin Chen <justin.chen@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Vikas Gupta <vikas.gupta@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>, 
	Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, Wei Fang <wei.fang@nxp.com>, 
	Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, 
	Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>, 
	Subbaraya Sundeep <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
	Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, 
	Daniel Machon <daniel.machon@microchip.com>, Steen Hegelund <Steen.Hegelund@microchip.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>, 
	Brett Creeley <brett.creeley@amd.com>, Justin Lai <justinlai0215@realtek.com>, 
	Larry Chiu <larry.chiu@realtek.com>, 
	"=?UTF-8?q?Niklas=20S=C3=B6derlund?=" <niklas.soderlund@ragnatech.se>, Paul Barker <paul@pbarker.dev>, 
	Masahisa Kojima <kojima.masahisa@socionext.com>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>, 
	MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>, 
	Mengyuan Lou <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, 
	Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, 
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>, Eric Joyner <eric.joyner@amd.com>, 
	Mohammad Heib <mheib@redhat.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	Chintan Vankar <c-vankar@ti.com>, Nora Schiffer <nora.schiffer@ew.tq-group.com>, 
	Alexander Sverdlin <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

Now that page_pool reference counting is dispatched directly from each
netmem's type and skb->pp_recycle has been removed, skb_mark_for_recycle()
is a no-op stub with no remaining purpose. Remove its definition, all
in-tree callers, and its reference in
Documentation/networking/page_pool.rst.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 Documentation/networking/page_pool.rst                |  1 -
 drivers/net/ethernet/airoha/airoha_eth.c              |  1 -
 drivers/net/ethernet/alibaba/eea/eea_rx.c             |  3 ---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c      |  1 -
 drivers/net/ethernet/broadcom/bnge/bnge_txrx.c        |  5 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c             |  8 --------
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |  2 --
 drivers/net/ethernet/cisco/enic/enic_rq.c             |  1 -
 drivers/net/ethernet/engleder/tsnep_main.c            |  2 --
 drivers/net/ethernet/freescale/fec_main.c             |  1 -
 drivers/net/ethernet/google/gve/gve_rx_dqo.c          |  9 ---------
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c     |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       |  6 ------
 drivers/net/ethernet/huawei/hinic3/hinic3_rx.c        |  1 -
 drivers/net/ethernet/intel/iavf/iavf_txrx.c           |  2 --
 drivers/net/ethernet/marvell/mvneta.c                 |  2 --
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       |  2 --
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    |  1 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           |  1 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c            |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c       |  8 --------
 drivers/net/ethernet/mellanox/mlxsw/pci.c             |  2 --
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c |  2 --
 .../ethernet/microchip/sparx5/lan969x/lan969x_fdma.c  |  1 -
 drivers/net/ethernet/microsoft/mana/mana_en.c         |  3 ---
 drivers/net/ethernet/mucse/rnpgbe/rnpgbe_lib.c        |  1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c      |  2 --
 drivers/net/ethernet/realtek/rtase/rtase_main.c       |  1 -
 drivers/net/ethernet/renesas/ravb_main.c              |  2 --
 drivers/net/ethernet/socionext/netsec.c               |  1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     |  1 -
 drivers/net/ethernet/tehuti/tn40.c                    |  1 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c              |  1 -
 drivers/net/ethernet/ti/cpsw.c                        |  2 --
 drivers/net/ethernet/ti/cpsw_new.c                    |  2 --
 drivers/net/ethernet/ti/icssg/icssg_common.c          |  1 -
 drivers/net/ethernet/wangxun/libwx/wx_lib.c           |  2 --
 drivers/net/virtio_net.c                              |  8 +-------
 drivers/net/vmxnet3/vmxnet3_xdp.c                     |  1 -
 drivers/net/wireless/mediatek/mt76/dma.c              |  1 -
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c       |  1 -
 drivers/net/wireless/mediatek/mt76/npu.c              |  1 -
 drivers/net/wireless/mediatek/mt76/usb.c              |  1 -
 drivers/net/xen-netfront.c                            |  1 -
 include/linux/skbuff.h                                |  5 -----
 include/net/page_pool/helpers.h                       |  5 ++---
 net/core/skbuff.c                                     |  1 -
 net/core/xdp.c                                        | 11 ++---------
 48 files changed, 5 insertions(+), 115 deletions(-)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index d0be2b800a060..5b2d6d011fc1b 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -166,7 +166,6 @@ NAPI poller
             if XDP_DROP:
                 page_pool_recycle_direct(page_pool, page);
         } else (packet_is_skb) {
-            skb_mark_for_recycle(skb);
             new_page = page_pool_dev_alloc_pages(page_pool);
         }
     }
diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index b164a78ddac9d..980b8c1d0dc49 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -925,7 +925,6 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 
 			skb_reserve(q->skb, AIROHA_RX_HEADROOM);
 			__skb_put(q->skb, len);
-			skb_mark_for_recycle(q->skb);
 			q->skb->dev = netdev;
 			q->skb->ip_summed = CHECKSUM_UNNECESSARY;
 			skb_record_rx_queue(q->skb, qid);
diff --git a/drivers/net/ethernet/alibaba/eea/eea_rx.c b/drivers/net/ethernet/alibaba/eea/eea_rx.c
index 5dfb7cb2ba6d2..27feb9cdedd7e 100644
--- a/drivers/net/ethernet/alibaba/eea/eea_rx.c
+++ b/drivers/net/ethernet/alibaba/eea/eea_rx.c
@@ -319,8 +319,6 @@ static struct sk_buff *eea_rx_build_split_hdr_skb(struct eea_net_rx *rx,
 		skb_add_rx_frag(skb, 0, page, offset, ctx->len, truesize);
 	}
 
-	skb_mark_for_recycle(skb);
-
 	return skb;
 }
 
@@ -345,7 +343,6 @@ static struct sk_buff *eea_rx_build_skb(struct eea_net_rx *rx,
 		return NULL;
 
 	truesize = eea_consume_rx_buffer(rx, meta, bufsize);
-	skb_mark_for_recycle(skb);
 
 	skb->truesize += truesize - bufsize;
 
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index f09054a02feb6..005476e150710 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -576,7 +576,6 @@ static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
 		skb_reserve(skb, NET_SKB_PAD);
 		skb_put(skb, len);
 		memcpy(skb->data, data, len);
-		skb_mark_for_recycle(skb);
 
 		/* Skip the 2-byte hardware alignment pad. */
 		skb_pull(skb, 2);
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c b/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c
index 472b02cc43b3c..de352d53628c9 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c
@@ -240,7 +240,6 @@ static struct sk_buff *bnge_rx_agg_netmems_skb(struct bnge_net *bn,
 	total_frag_len = __bnge_rx_agg_netmems(bn, cpr, idx, agg_bufs,
 					       tpa, skb);
 	if (!total_frag_len) {
-		skb_mark_for_recycle(skb);
 		dev_kfree_skb(skb);
 		return NULL;
 	}
@@ -468,7 +467,6 @@ void bnge_reuse_rx_data(struct bnge_rx_ring_info *rxr, u16 cons, void *data)
 static void bnge_deliver_skb(struct bnge_net *bn, struct bnge_napi *bnapi,
 			     struct sk_buff *skb)
 {
-	skb_mark_for_recycle(skb);
 	skb_record_rx_queue(skb, bnapi->index);
 	napi_gro_receive(&bnapi->napi, skb);
 }
@@ -659,7 +657,6 @@ static struct sk_buff *bnge_tpa_end(struct bnge_net *bn,
 			bnge_abort_tpa(cpr, idx, agg_bufs);
 			return NULL;
 		}
-		skb_mark_for_recycle(skb);
 		skb_reserve(skb, bn->rx_offset);
 		skb_put(skb, len);
 	}
@@ -761,7 +758,6 @@ static struct sk_buff *bnge_rx_vlan(struct sk_buff *skb, u8 cmp_type,
 	return skb;
 
 vlan_err:
-	skb_mark_for_recycle(skb);
 	dev_kfree_skb(skb);
 	return NULL;
 }
@@ -790,7 +786,6 @@ static struct sk_buff *bnge_rx_skb(struct bnge_net *bn,
 		return NULL;
 	}
 
-	skb_mark_for_recycle(skb);
 	skb_reserve(skb, bn->rx_offset);
 	skb_put(skb, len);
 	return skb;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 757c7266ce15d..af385c0c43b6e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1226,7 +1226,6 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 		bnxt_reuse_rx_data(rxr, cons, data);
 		return NULL;
 	}
-	skb_mark_for_recycle(skb);
 	skb_reserve(skb, data_ptr - (u8 *)frag_start);
 	__skb_put(skb, len);
 
@@ -1265,7 +1264,6 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 
-	skb_mark_for_recycle(skb);
 	off = (void *)data_ptr - page_address(page);
 	skb_add_rx_frag(skb, 0, page, off, len, rxr->rx_page_size);
 	memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
@@ -1304,7 +1302,6 @@ static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 		return NULL;
 	}
 
-	skb_mark_for_recycle(skb);
 	skb_reserve(skb, bp->rx_offset);
 	skb_put(skb, offset_and_len & 0xffff);
 	return skb;
@@ -1411,7 +1408,6 @@ static struct sk_buff *bnxt_rx_agg_netmems_skb(struct bnxt *bp,
 	total_frag_len = __bnxt_rx_agg_netmems(bp, cpr, idx, agg_bufs, tpa,
 					       skb, NULL);
 	if (!total_frag_len) {
-		skb_mark_for_recycle(skb);
 		dev_kfree_skb(skb);
 		return NULL;
 	}
@@ -2023,7 +2019,6 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 			cpr->sw_stats->rx.rx_oom_discards += 1;
 			return NULL;
 		}
-		skb_mark_for_recycle(skb);
 		skb_reserve(skb, bp->rx_offset);
 		skb_put(skb, len);
 	}
@@ -2088,8 +2083,6 @@ static void bnxt_tpa_agg(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 static void bnxt_deliver_skb(struct bnxt *bp, struct bnxt_napi *bnapi,
 			     struct sk_buff *skb)
 {
-	skb_mark_for_recycle(skb);
-
 	if (skb->dev != bp->dev) {
 		/* this packet belongs to a vf-rep */
 		bnxt_vf_rep_rx(bp, skb);
@@ -2151,7 +2144,6 @@ static struct sk_buff *bnxt_rx_vlan(struct sk_buff *skb, u8 cmp_type,
 	}
 	return skb;
 vlan_err:
-	skb_mark_for_recycle(skb);
 	dev_kfree_skb(skb);
 	return NULL;
 }
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 4d2be2a21ed1b..240d2d5e4f5fe 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2437,8 +2437,6 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			goto next;
 		}
 
-		skb_mark_for_recycle(skb);
-
 		/* Reserve the RSB + pad, then set the data length */
 		skb_reserve(skb, GENET_RSB_PAD);
 		__skb_put(skb, len - GENET_RSB_PAD);
diff --git a/drivers/net/ethernet/cisco/enic/enic_rq.c b/drivers/net/ethernet/cisco/enic/enic_rq.c
index ccbf5c9a21d0f..1221a4a289294 100644
--- a/drivers/net/ethernet/cisco/enic/enic_rq.c
+++ b/drivers/net/ethernet/cisco/enic/enic_rq.c
@@ -369,7 +369,6 @@ static void enic_rq_indicate_buf(struct enic *enic, struct vnic_rq *rq,
 				      fcoe_fc_crc_ok, vlan_stripped,
 				      csum_not_calc, tcp_udp_csum_ok, ipv6,
 				      ipv4_csum_ok, vlan_tci, skb);
-		skb_mark_for_recycle(skb);
 		napi_gro_frags(napi);
 		if (enic->rx_coalesce_setting.use_adaptive_rx_coalesce)
 			enic_intr_update_pkt_size(&cq->pkt_size_counter,
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 5db04e209dc67..e0881dd53912d 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1416,8 +1416,6 @@ static void tsnep_rx_page(struct tsnep_rx *rx, struct napi_struct *napi,
 
 	skb = tsnep_build_skb(rx, page, length);
 	if (skb) {
-		skb_mark_for_recycle(skb);
-
 		rx->packets++;
 		rx->bytes += length;
 		if (skb->pkt_type == PACKET_MULTICAST)
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f7636f23d1ebb..42499a269ad6c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1855,7 +1855,6 @@ static struct sk_buff *fec_build_skb(struct fec_enet_private *fep,
 
 	skb_reserve(skb, FEC_ENET_XDP_HEADROOM + fep->rx_shift);
 	skb_put(skb, len);
-	skb_mark_for_recycle(skb);
 
 	/* Get offloads from the enhanced buffer descriptor */
 	if (fep->bufdesc_ex) {
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 82ed5e48b00ab..3942e5d117c14 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -622,9 +622,6 @@ static int gve_rx_append_frags(struct napi_struct *napi,
 		if (!skb)
 			return -1;
 
-		if (rx->dqo.page_pool)
-			skb_mark_for_recycle(skb);
-
 		if (rx->ctx.skb_tail == rx->ctx.skb_head)
 			skb_shinfo(rx->ctx.skb_head)->frag_list = skb;
 		else
@@ -883,9 +880,6 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 			if (unlikely(!rx->ctx.skb_head))
 				goto error;
 			rx->ctx.skb_tail = rx->ctx.skb_head;
-
-			if (rx->dqo.page_pool)
-				skb_mark_for_recycle(rx->ctx.skb_head);
 		} else {
 			unsplit = 1;
 		}
@@ -988,9 +982,6 @@ static int gve_rx_dqo(struct napi_struct *napi, struct gve_rx_ring *rx,
 		return 0;
 	}
 
-	if (rx->dqo.page_pool)
-		skb_mark_for_recycle(rx->ctx.skb_head);
-
 	gve_skb_add_rx_frag(rx, buf_state, 0, buf_len);
 	gve_reuse_buffer(rx, buf_state);
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
index 2ea025fd964fd..3204203230795 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
@@ -471,7 +471,6 @@ static int hbg_build_skb(struct hbg_priv *priv,
 	buffer->skb = napi_build_skb(buffer->page_addr, buffer->page_size);
 	if (unlikely(!buffer->skb))
 		return -ENOMEM;
-	skb_mark_for_recycle(buffer->skb);
 
 	/* page will be freed together with the skb */
 	buffer->page = NULL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 47788be64be68..ed6e75b45c25e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4125,9 +4125,6 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 		return 0;
 	}
 
-	if (ring->page_pool)
-		skb_mark_for_recycle(skb);
-
 	hns3_ring_stats_update(ring, seg_pkt_cnt);
 
 	ring->pull_len = eth_get_headlen(netdev, va, HNS3_RX_HEAD_SIZE);
@@ -4165,9 +4162,6 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
 				return -ENXIO;
 			}
 
-			if (ring->page_pool)
-				skb_mark_for_recycle(new_skb);
-
 			ring->frag_num = 0;
 
 			if (ring->tail_skb) {
diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_rx.c b/drivers/net/ethernet/huawei/hinic3/hinic3_rx.c
index 309ab59013797..4f94c13eedf3f 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_rx.c
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_rx.c
@@ -234,7 +234,6 @@ static void hinic3_add_rx_frag(struct hinic3_rxq *rxq,
 
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 			rx_info->page_offset, size, rxq->buf_len);
-	skb_mark_for_recycle(skb);
 }
 
 static void packaging_skb(struct hinic3_rxq *rxq, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 8982cf75466fa..6b863035d3ae9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1229,8 +1229,6 @@ static struct sk_buff *iavf_build_skb(const struct libeth_fqe *rx_buffer,
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_mark_for_recycle(skb);
-
 	/* update pointers within the skb to store the data */
 	skb_reserve(skb, hr);
 	__skb_put(skb, size);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ea755cf05b9ef..0554595fbd143 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2407,8 +2407,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	skb_mark_for_recycle(skb);
-
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 	if (metasize)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 317af54369cfe..7d4c6ce505697 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4030,8 +4030,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			}
 			goto err_drop_frame_retired;
 		}
-		if (pp)
-			skb_mark_for_recycle(skb);
 
 		/* If we have RX hardware timestamping enabled, grab the
 		 * timestamp from the queue and convert.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 90af9b9044aa0..8869e9f1d6b5a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -383,7 +383,6 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (pfvf->flags & OTX2_FLAG_TC_MARK_ENABLED)
 		skb->mark = parse->match_id;
 
-	skb_mark_for_recycle(skb);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ad0fdc4133fb6..51105efb0ed6f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2305,7 +2305,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			metasize = xdp.data - xdp.data_meta;
 			if (metasize)
 				skb_metadata_set(skb, metasize);
-			skb_mark_for_recycle(skb);
 		} else {
 			if (ring->frag_size <= PAGE_SIZE)
 				new_data = napi_alloc_frag(ring->frag_size);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index fe18606c2ab55..6c59761b903b0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -856,7 +856,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 		skb = napi_get_frags(&cq->napi);
 		if (unlikely(!skb))
 			goto next;
-		skb_mark_for_recycle(skb);
 
 		if (unlikely(ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL)) {
 			u64 timestamp = mlx4_en_get_cqe_ts(cqe);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c9..f2b5ab014d549 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1614,7 +1614,6 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	skb_mark_for_recycle(skb);
 	frag_page->frags++;
 
 	return skb;
@@ -1701,7 +1700,6 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_mark_for_recycle(skb);
 	head_wi->frag_page->frags++;
 
 	if (xdp_buff_has_frags(&mxbuf->xdp)) {
@@ -1966,7 +1964,6 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 			rq->stats->buff_alloc_err++;
 			return NULL;
 		}
-		skb_mark_for_recycle(skb);
 		va = skb->head;
 		net_prefetchw(va); /* xdp_frame data area */
 		net_prefetchw(skb->data);
@@ -2046,7 +2043,6 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 		if (unlikely(!skb))
 			return NULL;
 
-		skb_mark_for_recycle(skb);
 		linear_page->frags++;
 
 		if (xdp_buff_has_frags(&mxbuf->xdp)) {
@@ -2146,7 +2142,6 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 
 	/* queue up for recycling/reuse */
-	skb_mark_for_recycle(skb);
 	frag_page->frags++;
 
 	return skb;
@@ -2176,9 +2171,6 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			      head_offset, head_offset, len);
 	__skb_put(skb, head_size);
 
-	/* queue up for recycling/reuse */
-	skb_mark_for_recycle(skb);
-
 	return skb;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index dceb69945d26e..a81cff6a6b7b8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -776,8 +776,6 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 		goto out;
 	}
 
-	skb_mark_for_recycle(skb);
-
 	if (mlxsw_pci_cqe_lag_get(cqe_v, cqe)) {
 		rx_info.is_lag = true;
 		rx_info.u.lag_id = mlxsw_pci_cqe_lag_id_get(cqe_v, cqe);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 21668bbcc9063..e4f091fd7956c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -439,8 +439,6 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	if (unlikely(!skb))
 		goto free_page;
 
-	skb_mark_for_recycle(skb);
-
 	skb_reserve(skb, XDP_PACKET_HEADROOM);
 	skb_put(skb, fdma_db_len_get(db));
 
diff --git a/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c b/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c
index 053d125eda658..f9c610c18b2c3 100644
--- a/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c
@@ -120,7 +120,6 @@ static struct sk_buff *lan969x_fdma_rx_get_frame(struct sparx5 *sparx5,
 	if (unlikely(!skb))
 		goto free_page;
 
-	skb_mark_for_recycle(skb);
 	skb_put(skb, fdma_db_len_get(db));
 	skb_pull(skb, IFH_LEN * sizeof(u32));
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6b7c027e497ed..2f670e3c61d80 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2170,9 +2170,6 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 	if (!skb)
 		goto drop;
 
-	if (from_pool)
-		skb_mark_for_recycle(skb);
-
 	skb->dev = napi->dev;
 
 	skb->protocol = eth_type_trans(skb, ndev);
diff --git a/drivers/net/ethernet/mucse/rnpgbe/rnpgbe_lib.c b/drivers/net/ethernet/mucse/rnpgbe/rnpgbe_lib.c
index b7b0c45a0f664..03ba794d6d727 100644
--- a/drivers/net/ethernet/mucse/rnpgbe/rnpgbe_lib.c
+++ b/drivers/net/ethernet/mucse/rnpgbe/rnpgbe_lib.c
@@ -332,7 +332,6 @@ static struct sk_buff *rnpgbe_build_skb(struct mucse_rx_buffer *rx_buffer,
 	/* update pointers within the skb to store the data */
 	skb_reserve(skb, RNPGBE_SKB_PAD);
 	__skb_put(skb, size);
-	skb_mark_for_recycle(skb);
 
 	return skb;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 2543a8ff85476..8b85bb7effdd5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -198,7 +198,6 @@ static struct sk_buff *ionic_rx_build_skb(struct ionic_queue *q,
 		q_to_rx_stats(q)->alloc_err++;
 		return NULL;
 	}
-	skb_mark_for_recycle(skb);
 
 	if (headroom)
 		frag_len = min_t(u16, len,
@@ -249,7 +248,6 @@ static struct sk_buff *ionic_rx_copybreak(struct net_device *netdev,
 		q_to_rx_stats(q)->alloc_err++;
 		return NULL;
 	}
-	skb_mark_for_recycle(skb);
 
 	if (!synced)
 		page_pool_dma_sync_for_cpu(q->page_pool,
diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index e3cd4f7c13804..4d1cd4f8c2d07 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -562,7 +562,6 @@ static int rx_handler(struct rtase_ring *ring, int budget)
 			rtase_rx_csum(tp, skb, desc);
 
 		skb_put(skb, pkt_size);
-		skb_mark_for_recycle(skb);
 		skb->protocol = eth_type_trans(skb, dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5a07cc0180d8b..135081fce0bbd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -877,7 +877,6 @@ static int ravb_rx_gbeth(struct net_device *ndev, int budget, int q)
 							   true);
 					goto refill;
 				}
-				skb_mark_for_recycle(skb);
 				skb_put(skb, desc_len);
 
 				/* Save this skb if the packet spans multiple
@@ -1041,7 +1040,6 @@ static int ravb_rx_rcar(struct net_device *ndev, int budget, int q)
 						   rx_buff->page, 0, true);
 				break;
 			}
-			skb_mark_for_recycle(skb);
 
 			ravb_rx_rcar_hwstamp(priv, q, desc, skb);
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 79a0a324c921d..95da134dc847a 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1044,7 +1044,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 				  "rx failed to build skb\n");
 			break;
 		}
-		skb_mark_for_recycle(skb);
 
 		skb_reserve(skb, xdp.data - xdp.data_hard_start);
 		skb_put(skb, xdp.data_end - xdp.data);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9ded31150fbe6..5ce03aec41024 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6010,7 +6010,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			head_pad_len = ctx.xdp.data - ctx.xdp.data_hard_start;
 			skb_reserve(skb, head_pad_len);
 			skb_put(skb, buf1_len);
-			skb_mark_for_recycle(skb);
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
diff --git a/drivers/net/ethernet/tehuti/tn40.c b/drivers/net/ethernet/tehuti/tn40.c
index 558b791a97edd..c1fcc28e44322 100644
--- a/drivers/net/ethernet/tehuti/tn40.c
+++ b/drivers/net/ethernet/tehuti/tn40.c
@@ -384,7 +384,6 @@ static int tn40_rx_receive(struct tn40_priv *priv, int budget)
 			tn40_recycle_rx_buffer(priv, rxdd);
 			break;
 		}
-		skb_mark_for_recycle(skb);
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, priv->ndev);
 		skb->ip_summed =
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2551554add17a..48be2ba48a7f5 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1353,7 +1353,6 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 	skb_put(skb, pkt_len);
 	if (port->rx_ts_filter)
 		am65_cpts_rx_timestamp(common->cpts, port_id, skb);
-	skb_mark_for_recycle(skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 	am65_cpsw_nuss_rx_csum(skb, csum_info);
 	napi_gro_receive(&flow->napi_rx, skb);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 8d36124520ad3..2ffdd8086b45b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -453,8 +453,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* mark skb for recycling */
-	skb_mark_for_recycle(skb);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 07832cad5e3c2..996b513f349f1 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -397,8 +397,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* mark skb for recycling */
-	skb_mark_for_recycle(skb);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 4a7d1a6f470b1..20c5f44df2578 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -1131,7 +1131,6 @@ static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id, u32 *xdp_state)
 		skb->offload_fwd_mark = emac->offload_fwd_mark;
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	skb_mark_for_recycle(skb);
 	napi_gro_receive(&emac->napi_rx, skb);
 	ndev->stats.rx_bytes += pkt_len;
 	ndev->stats.rx_packets++;
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index dcbf5811046e9..8de18c10de99b 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -259,8 +259,6 @@ static struct sk_buff *wx_build_skb(struct wx_ring *rx_ring,
 			return skb;
 		}
 
-		skb_mark_for_recycle(skb);
-
 		if (!wx_test_staterr(rx_desc, WX_RXD_STAT_EOP))
 			WX_CB(skb)->dma = rx_buffer->dma;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3453689bfd341..9fa7b1a40624f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1930,8 +1930,6 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	skb_mark_for_recycle(skb);
-
 	return skb;
 
 err_xdp:
@@ -1987,10 +1985,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 
 	skb = receive_small_build_skb(vi, xdp_headroom, buf, len, buflen);
-	if (likely(skb)) {
-		skb_mark_for_recycle(skb);
+	if (likely(skb))
 		return skb;
-	}
 
 	u64_stats_inc(&stats->alloc_fail);
 err:
@@ -2313,7 +2309,6 @@ static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
 			break;
 		}
 
-		skb_mark_for_recycle(head_skb);
 		return head_skb;
 
 	case XDP_TX:
@@ -2425,7 +2420,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	skb_mark_for_recycle(head_skb);
 	while (--num_buf) {
 		buf = virtnet_rq_get_buf(rq, &len, &ctx);
 		if (unlikely(!buf)) {
diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
index 5f470499e6002..9d1da8809501a 100644
--- a/drivers/net/vmxnet3/vmxnet3_xdp.c
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
@@ -325,7 +325,6 @@ vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
 	/* bpf prog might change len and data position. */
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
-	skb_mark_for_recycle(skb);
 
 	return skb;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a67880a9281c5..2ba62421c5ae0 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1075,7 +1075,6 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 			goto free_frag;
 
 		skb_reserve(skb, q->buf_offset);
-		skb_mark_for_recycle(skb);
 
 		*(u32 *)skb->cb = info;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index f36da545045b8..7a3fccc74dcce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2041,7 +2041,6 @@ void mt7996_rro_rx_process(struct mt76_dev *mdev, void *data)
 				goto next_page;
 
 			skb_reserve(skb, q->buf_offset);
-			skb_mark_for_recycle(skb);
 			__skb_put(skb, len);
 
 			if (ind_reason == 1 || ind_reason == 2) {
diff --git a/drivers/net/wireless/mediatek/mt76/npu.c b/drivers/net/wireless/mediatek/mt76/npu.c
index c4c7c0af63217..2e018d7116f33 100644
--- a/drivers/net/wireless/mediatek/mt76/npu.c
+++ b/drivers/net/wireless/mediatek/mt76/npu.c
@@ -91,7 +91,6 @@ static struct sk_buff *mt76_npu_dequeue(struct mt76_dev *dev,
 
 			__skb_put(skb, len);
 			skb_reset_mac_header(skb);
-			skb_mark_for_recycle(skb);
 		} else {
 			struct skb_shared_info *shinfo = skb_shinfo(skb);
 			struct page *page = virt_to_head_page(e->buf);
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index be48a88a3ad02..f91f773ddcd68 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -563,7 +563,6 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb,
 		nsgs++;
 	}
 
-	skb_mark_for_recycle(skb);
 	dev->drv->rx_skb(dev, MT_RXQ_MAIN, skb, NULL);
 
 	return nsgs;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index fdcb91042f290..82bef245d6d25 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -286,7 +286,6 @@ static struct sk_buff *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
 		return NULL;
 	}
 	skb_add_rx_frag(skb, 0, page, 0, 0, PAGE_SIZE);
-	skb_mark_for_recycle(skb);
 
 	/* Align ip header to a 16 bytes boundary */
 	skb_reserve(skb, NET_IP_ALIGN);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4eaf4da1f7dad..3dc77734c80a3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5473,11 +5473,6 @@ static inline struct kcov_common_handle_id skb_get_kcov_handle(struct sk_buff *s
 	return skb->kcov_handle;
 }
 
-/* Deprecated: page_pool recycling is now determined per netmem. */
-static inline void skb_mark_for_recycle(struct sk_buff *skb)
-{
-}
-
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize);
 
diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index af3cb65c30416..87aca9efa40ec 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -42,8 +42,7 @@
  * The API keeps track of in-flight pages, in order to let API users know when
  * it is safe to free a page_pool object, the API users must call
  * page_pool_put_page() or page_pool_free_va() to free the page_pool object, or
- * attach the page_pool object to a page_pool-aware object like skbs marked with
- * skb_mark_for_recycle().
+ * attach the page_pool object to a page_pool-aware object like an skb.
  *
  * page_pool_put_page() may be called multiple times on the same page if a page
  * is split into multiple fragments. For the last fragment, it will either
@@ -260,7 +259,7 @@ static inline void page_pool_fragment_netmem(netmem_ref netmem, long nr)
  * pp_ref_count represents the number of outstanding references to the page,
  * which will be freed using page_pool APIs (rather than page allocator APIs
  * like put_page()). Such references are usually held by page_pool-aware
- * objects like skbs marked for page pool recycling.
+ * objects like skbs.
  *
  * This helper allows the caller to take (set) multiple references to a
  * freshly allocated page. The page must be freshly allocated (have a
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e3b969e38db65..400b175a3e1ab 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -967,7 +967,6 @@ int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 
 	skb_reserve(nskb, headroom);
 	skb_copy_header(nskb, skb);
-	skb_mark_for_recycle(nskb);
 
 	err = skb_copy_bits(skb, 0, nskb->data, size);
 	if (err) {
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 6f2b9191af9ec..513a51484ecd1 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -625,8 +625,8 @@ EXPORT_SYMBOL_GPL(xdp_warn);
  *
  * Perform common operations to create a new skb to pass up the stack from
  * &xdp_buff: allocate an skb head from the NAPI percpu cache, initialize
- * skb data pointers and offsets, set the recycle bit if the buff is
- * PP-backed, Rx queue index, protocol and update frags info.
+ * skb data pointers and offsets, Rx queue index, protocol and update frags
+ * info.
  *
  * Return: new &sk_buff on success, %NULL on error.
  */
@@ -654,9 +654,6 @@ struct sk_buff *xdp_build_skb_from_buff(const struct xdp_buff *xdp)
 	if (metalen > 0)
 		skb_metadata_set(skb, metalen);
 
-	if (rxq->mem.type == MEM_TYPE_PAGE_POOL)
-		skb_mark_for_recycle(skb);
-
 	skb_record_rx_queue(skb, rxq->queue_index);
 
 	if (unlikely(nr_frags)) {
@@ -761,7 +758,6 @@ struct sk_buff *xdp_build_skb_from_zc(struct xdp_buff *xdp)
 		goto out;
 	}
 
-	skb_mark_for_recycle(skb);
 	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
 
 	memcpy(__skb_put(skb, len), xdp->data_meta, LARGEST_ALIGN(len));
@@ -836,9 +832,6 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	 * - RX ring dev queue index	(skb_record_rx_queue)
 	 */
 
-	if (xdpf->mem_type == MEM_TYPE_PAGE_POOL)
-		skb_mark_for_recycle(skb);
-
 	/* Allow SKB to reuse area used by xdp_frame */
 	xdp_scrub_frame(xdpf);
 
-- 
2.56.0.385.gac671c819a-goog

