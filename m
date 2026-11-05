Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917267;
	b=TRI+jFC52/xmMNwwTFztOJdBfJYDR8JkjQM8r1enFtmxm2VfH+fm62hr/iJcJQtEroo2
	 r/YNDA+vJ0xh4tKmkak1K/EOyr3e2ssNgcKjJb7Mn5mm/t8ROoEdpTYy8oe9MOIy19t/i
	 5J2088sxF/ANsLbgpx3Fzt+mopi5VkEJ5pG1gIxtK9p2nf5XjDTXyQ5wqZ86qwOzbohMj
	 TTXlmHB2N3vkz/UwDlH4qsBJeePP4OTZ8JX+YKkjUwpF8nKGg+5REUswaJnxTR6CHXl8l
	 4V707lTC5Ty5svImOsR5BxjiNd4SjUiczGCLWh4axAhnm+I2aiHqu7HRN+2o+TSLGxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917267;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6YYrjHk+nB8Qt9ThWiyhnTgXhSxUl+9UI8ospp2Q6VI=;
	b=xiY9Y8ksvR11cSA461MKN7dCzO1I7KE4lpLErpgBesw+V33GCv3VfzUJiuZwoyu06I56
	 haVy1otp7EQkO9AtebKCz8rJ1uzOeWpE4JA+m0pSpJkN0kVYFFfKEwGBStauvVz0/x+uV
	 qLozpHVgmvEIm5gGQJ2hgd6e8MlEvo9WSrqeNYcN+vOGO+KH5R75AmhRjlMBMPJG8Qk6v
	 9yeIMJ1suEQhrShkhTP+K/jTJDsQW+PwZNXnbZBC2fBCZZFFwzeVffoC9o35IWqBXlLIk
	 LYVOsO+KxIiHdYC3PiIwtU+p8fIMGPcpMLVeaGcasrKAN3l0luRAVTDZ9mCfProbF4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qbldxGQz;
	arc=none smtp.remote-ip=74.125.229.131
Received: from mail-dl2-f3.google.com (mail-dl2-f3.google.com [74.125.229.131])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434ED606D815
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 434ED606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qbldxGQz
Received: by mail-dl2-f3.google.com with SMTP id a92af1059eb24-1521c45a248so138852c88.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917265; x=1794522065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6YYrjHk+nB8Qt9ThWiyhnTgXhSxUl+9UI8ospp2Q6VI=;
        b=qbldxGQz8ySn5OTVN0MzE2NHWTJ5of5pmpV2gl0mwPzMVoPNOzEqQx8BBOtBfleLZA
         DgwXUvYDiPtuFEls04z8RJqJvrkG6l3pHum1BEO4It6bfM3zYd0lrmWRYXSXGoX3UMra
         /q0i9BjelbNEoRQjGZSmziVesSuwDEE+mc8pt1m9iji8MSzsV+Egs4TwMKnx68UJi/nS
         bSeiPSvAdVPUg5TLkdoG1oFTlqOwCwWlj/mJski4Zej2z/MUcRo+FQwgCPx36M7GCWwF
         GJb1caxzYeeiGcf0DKtd35S6M3udphZNwJwDBZfZ9r3T7CpBL70nR87LfgQPO3irZ4Ye
         4TrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917265; x=1794522065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6YYrjHk+nB8Qt9ThWiyhnTgXhSxUl+9UI8ospp2Q6VI=;
        b=e27cUljHvMDzIhOFG7zewemt/44auoC5U4f0gbybzBhUnrgN+LqseYrrfaEwkR7BcC
         JtifC+peAwxgpGnQPIUBdRYWoUesWCZwFspU08/lKKLxP2g8wVfe8cn6Iq3Kyn/znntA
         QOJ7JP6U9VP3kvgk3bjFO01NILTxyrEENzBoolNCAt2vafg2OwJvfLQ8va2qx624iLZr
         s7MOFUBtL8UwUdV8w39F6qyGuXfX08wkLpX5ycYdW+S3tc+2isngDBAKYH7N8GCam9xE
         bF2lnsYIbIGR9EENhq9kljYoCt68u5XrjvgAL8Go8SmnL0iTf9kY4suDYIdqjwcvJ/31
         IvIA==
X-Forwarded-Encrypted: i=1; AKwUvByefQ48LkQbq+Ca34SnPE1pg0nH2OHTs6C51TiMjQgf+2lLQkxtUP1ZhagZ4ZRA7bP4pN1tAiYkdiDE@vger.kernel.org
X-Gm-Message-State: APuU4Z8QQDAHgUBqwv+eS+80T9qhnEdkUDZnulAeheUOL+ZRkQDxpIhb
	nzzmBAj2sNcibbRnVhyX14TepR431MXm+dwDGa+VAr0GihcZ+bLjcmQS
X-Gm-Gg: AYBFou2fsjp+50sDOxKvf1bAQyTXezGyjWoCdKsxlMAfI3eMGVL//0cp7cXxFHZhj5R
	oLnHiiBLe0yIhcafdOlozlucYSnQUQb5dBipZjBqVzVtT4L2RYkZ1ClXq9ycRM4BuNt4DWsed2J
	O+mYEfnQxE361oFU/VTAYf+gs/R+cy0NU5nMiibMk4HqacCLc7vCopQX2TTUowgiQ3WLv2NSh8g
	HnBGSLr74ds/XF4Q0HIKGyv5hzUM4OTprRH6JHE+cBXDZVsiJ/FRIp2tUuTEl9UdOOMelgdPlTC
	OyDgm/ZENBW3p1BaBC5HgCZFygqQ9tbtrbnJ2RNZwxbcyGhylsockMB9QqdPPJtCVSUp0oJAk7R
	pM6A/L6V1sQgp9VJ84KC9ycJrr3c8SiLIXmdIAfgukOZwKGfAHxdAeV2E5KppUYILHk3dW2sPpb
	iZSypj9ptge+kqtk7g9JfeBxjEOjlmNuHWoEQpVQ3SLDPAthB20YJAQDgjuivYpoQA6xdN/iU7W
	smuHQ9AJo3+PABMVNkhu8hZLDX9TpfprrGLmVicJoO8SLg8aLfYLgtHuc4K0ruOM/HIykr4fmob
	Aay0ofOxD/aRrXR4uB0k857/kHd5Ji6Nfi0hEJf2Yt8ReQ==
X-Received: by 2002:a05:701b:454d:20b0:19a:bbe8:41a8 with SMTP id a92af1059eb24-1b25d3186f8mr494812c88.20.1793917265224;
        Thu, 05 Nov 2026 14:21:05 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:60::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c69c3fsm18985071c88.20.2026.11.05.14.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:04 -0800 (PST)
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
Subject: [PATCH net-next v3 4/9] net: devmem: add a per-device netmem TX frag size limit
Date: Thu,  5 Nov 2026 14:20:53 -0800
Message-ID: <20261105222058.944293-5-sdf@fomichev.me>
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

Devmem TX frags are bounded only by the net_iov size, which is about
to grow up to 2MB, more than some devices can describe in a single TX
descriptor.

Add netmem_tx_max_frag_size and cap devmem TX frags to the limit of the
device the binding is attached to. Default it to PAGE_SIZE, the largest
TX frag today, so drivers opt in to larger frags.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 Documentation/networking/net_cachelines/net_device.rst | 1 +
 Documentation/networking/netmem.rst                    | 7 +++++++
 include/linux/netdevice.h                              | 2 ++
 net/core/datagram.c                                    | 1 +
 net/core/dev.c                                         | 1 +
 net/core/devmem.c                                      | 1 +
 net/core/devmem.h                                      | 1 +
 7 files changed, 14 insertions(+)

diff --git a/Documentation/networking/net_cachelines/net_device.rst b/Documentation/networking/net_cachelines/net_device.rst
index 8eceaa80b686..4f5fd5b99154 100644
--- a/Documentation/networking/net_cachelines/net_device.rst
+++ b/Documentation/networking/net_cachelines/net_device.rst
@@ -76,6 +76,7 @@ unsigned_short                      dev_id
 unsigned_short                      dev_port
 spinlock_t                          addr_list_lock
 int                                 irq
+u32                                 netmem_tx_max_frag_size
 struct netdev_hw_addr_list          uc
 struct netdev_hw_addr_list          mc
 struct netdev_hw_addr_list          dev_addrs
diff --git a/Documentation/networking/netmem.rst b/Documentation/networking/netmem.rst
index 6871dcdd700c..a7b5bbe1cc65 100644
--- a/Documentation/networking/netmem.rst
+++ b/Documentation/networking/netmem.rst
@@ -155,3 +155,10 @@ Driver TX Requirements
 
    - `NETMEM_TX_NO_DMA`: for virtual or passthrough devices that do
      not DMA, but still support handling of netmem-backed skbs.
+
+3. Devmem TX frags are capped at `netdev->netmem_tx_max_frag_size`,
+   PAGE_SIZE by default. Drivers which can describe larger TX buffers
+   may raise it, up to the largest buffer a single TX descriptor can
+   describe. A frag can then span a whole net_iov, which may be much
+   larger than a page. The value is read when the dmabuf binding is
+   created.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c0ae442c4344..4453b80bf7ea 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1845,6 +1845,7 @@ enum netdev_reg_state {
  *			drivers. Mainly used by logical interfaces, such as
  *			bonding and tunnels
  *	@netmem_tx:	device netmem TX mode
+ *	@netmem_tx_max_frag_size: max size of a netmem TX frag
  *	@pacing_offload: enable EDT pacing offload.
  *
  *	@name:	This is the first field of the "visible" part of this structure
@@ -2342,6 +2343,7 @@ struct net_device {
 	unsigned short          dev_port;
 	int			irq;
 	u32			priv_len;
+	u32			netmem_tx_max_frag_size;
 
 	spinlock_t		addr_list_lock;
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 489d92fe6dae..a8d3f87d38c5 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -734,6 +734,7 @@ zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
 
 		size = min_t(size_t, size, length);
 		size = min_t(size_t, size, iter_iov_len(from));
+		size = min_t(size_t, size, binding->tx_max_frag_size);
 
 		netmem_inc_ref(net_iov_to_netmem(niov));
 		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), off,
diff --git a/net/core/dev.c b/net/core/dev.c
index 3ac700d37e59..0af4e4debcc8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12350,6 +12350,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gro_ipv4_max_size = GRO_LEGACY_MAX_SIZE;
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
 	dev->tso_max_segs = TSO_MAX_SEGS;
+	dev->netmem_tx_max_frag_size = PAGE_SIZE;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 6339f221bc82..19c039ed2cb2 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -218,6 +218,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 
 	binding->dev = dev;
 	binding->vdev = vdev;
+	binding->tx_max_frag_size = dev->netmem_tx_max_frag_size;
 	write_pnet(&binding->net, sock_net(nl_sk));
 	binding->uid = sk_uid(nl_sk);
 	binding->niov_shift = niov_shift;
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 8fa089776610..97ff1f13fb84 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -79,6 +79,7 @@ struct net_devmem_dmabuf_binding {
 	struct net_iov **tx_vec;
 
 	unsigned int niov_shift;
+	u32 tx_max_frag_size;
 
 	struct work_struct unbind_w;
 };
-- 
2.53.0-Meta

