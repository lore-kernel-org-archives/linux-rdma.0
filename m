Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917272;
	b=YZ1Xy1TYfag+o7D1ZSnrqBquF9I3BYeEzjrCUTrqZKDzwuOUJjcjoWqPh6dKt0lDf+Il
	 lLa98nXr4VTCdjv9jbnQCwrv3vLsIX9A00HB4kEs2yL5rn4PayD6pSQ1Pypmh6pdnHJts
	 Xq4GQqMyDW2L6Be8x7g3Y/jKdUTK498ZI9dvRmJqC2ahppIc7J6yJX/sGOQ4DTK8DUwZy
	 HpFOb5M17B4NKq19EQ9w2i17NApelw07odmJ1KQT3R8GZB6r1kxnnzIXc3KAImUVKqQhe
	 9bkHNaVH/ajcPMYIeIHNfAJfJcECfXciOdhBhwsrfg2v4ZhW+TzUr/o8U4y61yz687Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917272;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Acd/QpdNjaZoFfEYKM7452m8zFvnMYypavI01EcAq44=;
	b=QGFcbUqdqVt0+daxDsryw1VFqpbuChK/mtlKOog/2TDGvPb1FivoyDxLRtK4MbGwgDXK
	 WV3498z/qp/reGU6eVkeoW7vRWTc0oC2OQ5mBU6qBbH1kHexOY1QAvN527GKKY3/dg/Sz
	 DDLzsFzj7c5vlj84+/XOk1Qkvc6XC0VD5XEVxZYMWsbY/QbGdtC76D1b950SGXVB58Xui
	 UtbpAtRdxan7HazDtaBR1E+s67U5T8uyttygFwpXD72e4zxOPXORkvvqoBYx7w0iimQY0
	 4gnG3zhkT2un/7vdA1GHHuX9ZUpIncnOAEo6YfgIooF0n36844iTTt4JtEJsrBU/qBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gpahHltS;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F6F606EE91
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4F6F606EE91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gpahHltS
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36a315ed211so67583eec.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917271; x=1794522071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Acd/QpdNjaZoFfEYKM7452m8zFvnMYypavI01EcAq44=;
        b=gpahHltSOyFyzTfMXDIYVv/IO8fAwDTU17+d5bpsCt+yDVFs0wG1xrAMoRJicRmKPa
         gKI8s57ZpODIASUIp5wXVVvn0dIMueFV6tmFExcufTlIvRDJ4FwcnjfpO1YiuNJYskh9
         wLBlCA5zt/TFk4FPt/ikmVcTIxK+DS/GQI6BDUCn7xk5eRTj+QDNPe7/IfzP0+PoqJDO
         f6Klxp95jMLnpk15i8axVytxSGb3KcE2gi3iZOQscKPFpp/t5tmXo2nxodEhCP4PNuci
         E7Zsalf+0684reRO+DpFrYWLcmSLFMcGH2zy2tw6XNi9+YUIR+sge4x6dG1zkuero/lF
         dJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917271; x=1794522071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Acd/QpdNjaZoFfEYKM7452m8zFvnMYypavI01EcAq44=;
        b=XY03ZIyGZhpDmEcWpgQRAAqIJ/SfugZAZxBO654ZbYxjpG3LOSU+0RxspUR06giPwp
         wLS87M3k1o84u5FVFYO89nnB0PRyRSg/1vrsFnonP1KdEvyjMlwzMzDoeZSWzwv23iac
         wal3Tm3XNQw+GM4ulqDO1M+Iik8H07zyHCXz+PxkHB765j1JZ2Wh6kuI62qBaKyvYxjd
         HIsGGnfSYo827LQi88J4vsJkxPiTB3aV0mQ7pYdUZpHc1pGtlCEa5PjbyDF9xrsE2QIW
         IkyNaIjVy6x9wb9DCMj8cA8RHBmYf3Obb4PIuoX3zyyqb8fOjzwaeZEOYbmuBs3fm/x3
         Hu6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwpc35ds05Wa0GN4rRWgROxxcAf553tF2uUDeRKJRx5ntIEBORXe7vICOB/mbOoIChhepUJ2FcUK0oc@vger.kernel.org
X-Gm-Message-State: APuU4Z8qQDLYSoTAqp5x6hFrDPqOK4NWEvarcfkB3pffkyX3DdW54Uo7
	YLOKgokFrpe/GMSDcZ2cYdj/cxEfQ8pUVR8oBF3REDtmcXYHmlYSVIw4
X-Gm-Gg: AYBFou0lHmS8Uv7iexZ1wrnC1eYrVgnsu1b28GQVrC3oIsmZPCFAygI/KkM4IkZbu9O
	8WwR+kQ2GPqhhBySPCZ2BfAyTw+7aiwL3tKjutMv9AstXVYgo6qrNnnVg5YOq1BumtkgFXI2UR9
	9qiNYGjsmGuZJ1BLWo361XFzCAJOBevo7e28FUGQmxRHDykZJ2PSx+ACoi9EYXxFaiFUFTlDtFm
	wA3/bl8z/o3lJIDJdahlkdkmh2e2qMGrkLOg80U+70E/HYI0KrrXkafaP7uMxXo4PrYIgbxR0hp
	HqoOLpQ9fEh1t4GByoml0F27SstVuIhFFU7ro7MC/6rpsjfDPkgpPVicguM2uGmeDC77Rk8IqB+
	b1RDt1I715rFYPOcJ5xGKJSuCEfFihwNv2sy9GVQS/m0KBcyRUyuTUgNv+ZZOanByK9tuE6w7WU
	gyLfdrAm40PAqkFQ4U4Iarii8YxRvtiPGCnqzaQ2jMy1zWf9kw+OFWMDFeDkUXZwELrTzGvVDTg
	b8PcsphwEkASCjZXEBnUcq5l6D28wlAuP2tg64DfQBvCF3vvVE7nrtNDJx5PMSepKmjkDWKMBLl
	9YsjvJPWPxPBHWgoL9/BbUM=
X-Received: by 2002:a05:693c:8854:b0:36c:a1bc:6102 with SMTP id 5a478bee46e88-36f6f88bc79mr764065eec.0.1793917270504;
        Thu, 05 Nov 2026 14:21:10 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:72::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8d44500sm51197eec.5.2026.11.05.14.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:09 -0800 (PST)
From: Stanislav Fomichev <sdf.kernel@gmail.com>
X-Google-Original-From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	edumazet@kernel.org,
	horms@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	michael.chan@broadcom.com,
	pavan.chebbi@broadcom.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	alexanderduyck@fb.com,
	kernel-team@meta.com,
	sdf@fomichev.me,
	dimitri.daskalakis1@gmail.com,
	almasrymina@google.com,
	dtatulea@nvidia.com,
	bobbyeshleman@meta.com,
	asml.silence@gmail.com,
	daniel@iogearbox.net,
	razor@blackwall.org,
	leitao@debian.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net-next v3 8/9] net: devmem: size TX net_iovs from the dmabuf sg table
Date: Thu,  5 Nov 2026 14:20:57 -0800
Message-ID: <20261105222058.944293-9-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105222058.944293-1-sdf@fomichev.me>
References: <20261105222058.944293-1-sdf@fomichev.me>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PAGE_SIZE TX net_iovs cap devmem skbs at MAX_SKB_FRAGS pages (~68KB),
which makes BIG TCP ineffective.

TX net_iovs only need to be DMA contiguous. Use the largest power of 2,
from PAGE_SIZE up to 2MB, which aligns every DMA segment of the dmabuf:
- 2MB hugepage-backed udmabufs get 2MB net_iovs
- no UAPI change, TX addresses are dmabuf offsets
- skbs are still bounded by TCP's size_goal, only frags get larger

The net_iov size doesn't depend on the device: frags are capped to the
device limit when they are built, and many frags share a net_iov.
Capping the net_iov instead would only split frags at net_iov
boundaries and allocate more net_iovs.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 net/core/devmem.c      | 28 ++++++++++++++++++++++++++--
 net/core/netdev-genl.c |  2 +-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 19c039ed2cb2..98c9594dbf99 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -181,6 +181,20 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 	return err;
 }
 
+static bool net_devmem_sgt_aligned(struct sg_table *sgt, size_t size)
+{
+	struct scatterlist *sg;
+	unsigned int i;
+
+	for_each_sgtable_dma_sg(sgt, sg, i) {
+		if (!IS_ALIGNED(sg_dma_address(sg), size) ||
+		    !IS_ALIGNED(sg_dma_len(sg), size))
+			return false;
+	}
+	return true;
+}
+
+/* niov_shift == 0 picks the net_iov size from the dmabuf, TX only */
 struct net_devmem_dmabuf_binding *
 net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		       struct device *dma_dev,
@@ -191,11 +205,11 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		       struct netlink_ext_ack *extack)
 {
 	struct net_devmem_dmabuf_binding *binding;
-	size_t niov_size = 1UL << niov_shift;
 	static u32 id_alloc_next;
 	struct scatterlist *sg;
 	struct dma_buf *dmabuf;
 	unsigned int sg_idx;
+	size_t niov_size;
 	size_t niov_idx;
 	size_t i;
 	long err;
@@ -221,7 +235,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	binding->tx_max_frag_size = dev->netmem_tx_max_frag_size;
 	write_pnet(&binding->net, sock_net(nl_sk));
 	binding->uid = sk_uid(nl_sk);
-	binding->niov_shift = niov_shift;
 	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
 
 	err = percpu_ref_init(&binding->ref,
@@ -266,6 +279,17 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		goto err_unmap;
 	}
 
+	if (!niov_shift) {
+		niov_size = SZ_2M;
+		while (niov_size > PAGE_SIZE &&
+		       (!IS_ALIGNED(dmabuf->size, niov_size) ||
+			!net_devmem_sgt_aligned(binding->sgt, niov_size)))
+			niov_size /= 2;
+		niov_shift = ilog2(niov_size);
+	}
+	binding->niov_shift = niov_shift;
+	niov_size = 1UL << niov_shift;
+
 	if (!IS_ALIGNED(dmabuf->size, niov_size)) {
 		err = -EINVAL;
 		NL_SET_ERR_MSG_FMT(extack,
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 384fdc5ae514..bfd229bd31ca 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -1261,7 +1261,7 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 	binding = net_devmem_bind_dmabuf(bind_dev,
 					 bind_dev != netdev ? netdev : NULL,
 					 dma_dev, DMA_TO_DEVICE, dmabuf_fd,
-					 PAGE_SHIFT, priv, NETLINK_CB(skb).sk,
+					 0, priv, NETLINK_CB(skb).sk,
 					 info->extack);
 	if (IS_ERR(binding)) {
 		err = PTR_ERR(binding);
-- 
2.53.0-Meta

