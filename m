Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D199543B6EC
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493419; cv=none; b=Z6wGVCh+pc+Q+OiE7t0Pit7lBKFTzPgNiuEiQmQiiY07roeyY93fvu6B2KAtkNAR8VmKaw5CufUj5eqYRCZV564MbIPJkz5woGs3LOl7NIvdWLfEfTRTwKIE0AlGyjm17Y2e+csUgNY6iP4nMGcHBa0P5umdBlHgM63H9W1LAHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493419; c=relaxed/simple;
	bh=eg6ZiA9VrIpAG1HGYjPkKMEWwjo8D3VwigBhj0jOQMI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qr3obxLtHwMcASgn9NESZ/piCV8bcAONx+6pUr/fkwCfRyKeo9dEz/sAzI46vZPDi9WU1L6DW3SpdxwHsLddZJYWg5WK9waZH7sSZzlzn6TYiTwRXpVDcF1DgNl6QDoE71tq3Z8QFvM35ferRejrIuIXLi+d1qdOIR6nOH00Ybw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=YRK3ADz0; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="YRK3ADz0"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53391022dc0so36962341cf.2
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 14:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791493413; x=1792098213; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jXT5xqnUz/gqqG3F9wxnjnCJ7kPBk+m9Im3cz1NP6m0=;
        b=YRK3ADz0+hVZ7K+hfPF/hdt/Z9G46F8iuh3Tai54g+aiuP/kTbub+RY1VS9e7ZyaPO
         3FV/plDWv4vVxCsXSnqyTnhWgyyCXZHR4tKGFEXQNy/KRbW3y70tIiKburGK6xrdOoUg
         rUHKlsifMKyuwQZ5pSu8vDzzKVddmbPUrdL2vhUNmYQx2SdLh5JwoUthCmyANxDlRoea
         FDghV9wBdpO7MWw8iXitbN4pOyuP4sfBzqNUZ1PlNilBrhfmbj9y3IDdqjekZqluOXNd
         54fakGnvgLOaY/5Ywy2PeElX2Ps1jqMKLgGceLRiwpQKsc39jOz6LcAyseWjDhmMnOU0
         ukjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493413; x=1792098213;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jXT5xqnUz/gqqG3F9wxnjnCJ7kPBk+m9Im3cz1NP6m0=;
        b=uNbDUUW8n+rSwPKMO+eegre2+O66Org1TXLwwOt1z1FQvLubjUJU+mlgxQSagDok2q
         VUQeZExdlqWAAHZUTU4aH/KRb5Hn+zsvEFHp4aUsfZjOy3K5LwKendo2/3lV9HKiM3ul
         jWVo10I8/g2loLKBuru7NpcT4PL9nMQnouEdvi0lLHKcZ89yPJNhahqmADej8s0ryTsO
         bi1HoOk35f8wW540SwQcQ3M18RBBxOIZFn728DwPYNFUcK+q9fBNprcD80agkI/FP+Nc
         GEDNZMUEX3LKIcKD3fYulwxTmQKS/TLBP+n1Pbv8p38PH5JAoFhxSKpdWpqNVTNJJ/r+
         15rA==
X-Forwarded-Encrypted: i=1; AKwUvBwtiik6mZKLX9ZqmoyEn6nTGW4WizYgsI78B+Dv9M80WkSz/Dpi9HlJf9cs8+4mS9wy41AxxshSBPbG@vger.kernel.org
X-Gm-Message-State: AFuF++msYv3Hn3DAvvcgfMpSBgksCbg1eBkWejlhlCX9emQ7XZ0LREBi
	WeS2n4uBQhRqGmLbvjXoI9BAey6omqWHbT1pdV3IxTHCeBIlZjAX5YcbJ874T6/Qc40=
X-Gm-Gg: AYBFou3jipv61xIScUSs0pVAbM1unfOXzubGfMRg96Lrv8tipwhbiFcjSd0dtctO5CS
	tFbZH4AJRUdlO/78VdRiP9LHWgqC81Rv9vEyZARihiBZ2uDpw1agTrdm185HshjOgH9xtHW4WIA
	zwWvFhzNXycv+FzVLmBTPNpqiA9/MHNrHv+gHevzQptN2fsJXHteKv8K4Rp1v0dA2tV8qqCE47y
	IMevLkBli8BuHjw+dbP/ch/PDugu5wMdgwGjBZcpZyx/XCHvU9a83g6f2AT4FMkwVljfmi0HQyV
	M+DYJPTxPjlwslk71vYumL2ganJ+HFDhggC35vTfQmC7ydtQv8CzSF/dmi0i1ESQOhVLNi+f/m4
	TmZHXHEDtyK5bpeL4gAB2pOhBqp2GfjOYMUOfDXSm+irvIEebtSJAY3haPnnF2h+3TQI3c8vRWh
	I3YB/YwX5QiJjI4mSNxIaadw+dInJFpLfAq3zm3tmo1EpokfWl2ixEaxNxyeH7Anww2ac8xk/EC
	dMeN0YSsiGQQOc=
X-Received: by 2002:a05:622a:1a91:b0:535:70c4:9a94 with SMTP id d75a77b69052e-535757c8eecmr123953171cf.74.1791493413537;
        Thu, 08 Oct 2026 14:03:33 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b46dda0sm3472151cf.4.2026.10.08.14.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:03:32 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 08 Oct 2026 21:02:52 +0000
Subject: [PATCH net-next v2 05/10] xen/netfront: check for failure when
 pulling in xennet_fill_frags()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-pskb-pull-tail-drivers-v2-5-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
To: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Manish Chopra <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>, 
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, 
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1791493385; l=2516;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=eg6ZiA9VrIpAG1HGYjPkKMEWwjo8D3VwigBhj0jOQMI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QAYzg3nASJLuLmRvMNvnGKJmwP15K/QJrV/X+gIw+dmiWX6S/LgMrQ8OB+kIWHKPWdMQHYgaFiD
 sh9Hj7FexRAU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

When the skb already has MAX_SKB_FRAGS frags, xennet_fill_frags() calls
__pskb_pull_tail() to free up a frag slot.  That frees slots in two
ways: it pulls the start of the packet into the head, and it releases
empty frags, even when there's nothing left to pull.  The second part
is what commit d81c5054a5d1 ("xen/netfront: tolerate frags with no
data") relies on.  The return value is ignored, which works out only
because the nr_frags check right after it drops the packet if no slot
was freed.

Use pskb_may_pull() followed by skb_drop_empty_frags(), and take the
error path explicitly if either fails.  pskb_may_pull() does nothing if
the head already holds pull_to bytes, so the BUG_ON() for pull_to <
skb_headlen(skb), which protected the subtraction, can go.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/xen-netfront.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 2ed673649c48..007fa3bbc9e6 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1174,18 +1174,15 @@ static int xennet_fill_frags(struct netfront_queue *queue,
 
 		RING_COPY_RESPONSE(&queue->rx, ++cons, &rx);
 
-		if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS) {
-			unsigned int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
-
-			BUG_ON(pull_to < skb_headlen(skb));
-			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
-		}
-		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
-			xennet_set_rx_rsp_cons(queue,
-					       ++cons + skb_queue_len(list));
-			kfree_skb(nskb);
-			return -ENOENT;
-		}
+		/* Out of frag slots: pull the start of the packet into the
+		 * head and drop empty frags to make room.
+		 */
+		if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS &&
+		    unlikely(!pskb_may_pull(skb, NETFRONT_SKB_CB(skb)->pull_to) ||
+			     skb_drop_empty_frags(skb, GFP_ATOMIC)))
+			goto err;
+		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS))
+			goto err;
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				skb_frag_page(nfrag),
@@ -1198,6 +1195,11 @@ static int xennet_fill_frags(struct netfront_queue *queue,
 	xennet_set_rx_rsp_cons(queue, cons);
 
 	return 0;
+
+err:
+	xennet_set_rx_rsp_cons(queue, ++cons + skb_queue_len(list));
+	kfree_skb(nskb);
+	return -ENOENT;
 }
 
 static int checksum_setup(struct net_device *dev, struct sk_buff *skb)

-- 
2.55.0

