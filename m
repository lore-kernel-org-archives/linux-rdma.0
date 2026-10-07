Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AC34DDB39
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791397005; cv=none; b=VQxPcaj7aZ5JkH7qxgQY4culLgvzfQeJEmwLxEgg4K8KzsQ+3WH+Mvq0bsVlT9+k8XBZ470zoaeL/lV01+7eAima5oth2OKB8uO1BeKvG2P8BwsT/iGohjLCgMYn4t089ylaXJoc4mMnhppHQaM/K8Uyff7qc7xeaQn+fpIY8JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791397005; c=relaxed/simple;
	bh=SzoPfHs/Y0Yp5wMeUYR89lBIZmoL94dSQOZucEHgjz8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jirZWYSum7sZjql4hw47X8jh0J3/XyOUeIcU89p46464mX6xqbeTHjEF4Yjw8CciyYBruqyhATNfiMcDRxnr6VggHczPTwGqZJsWEbYPQCJP7wNSVRjBMUgoaBiwfOH3sZMQl3Ch1fnTz1hoRT5kyb3O/fvkwiCpQVVpD0pBa+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=d4+ANOMq; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="d4+ANOMq"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93e4c00d71aso163416285a.3
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 11:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791397001; x=1792001801; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sSCgQuUXGYAa0Wwwh5eq4aENwa4g4z1qSYLp4/+HlX0=;
        b=d4+ANOMqLQd6vaXq58mBx7KDBFy6O2Dk1NcGS5lbCGIG373CAwwyjgnjLku5vXmwpF
         /4eiox/2pnDftlgDCG9N/k7m/PtCqVFVJCjbEcIu6pTaYcYZklEXbv8YkKuhnURowrcT
         ZA15BmW4/mmR/8u7EH558b6ieLd6UimyhDobXW80oBisJdybcahIm2KKAzYI+9JOWCld
         ZfEFJkRhfvDu4wOzNZopkx6PF/p1+UJLau24I9um0sSByT/xsIJqA3gu9RM8rFYRZ+3p
         p0/3vlq5cYi4v7MOzj09MBz9c6vfcAofj6aR9qQwYdaehuKzbGJXdUr1HvN2NLL9VUIo
         SWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791397001; x=1792001801;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sSCgQuUXGYAa0Wwwh5eq4aENwa4g4z1qSYLp4/+HlX0=;
        b=qm5Lq0KXvbmSTB7uU4POXG5pc+oYBERu5ECETE9betkCIxlXHJY+9o9RZTrjCdsUgb
         Ukrqa1uLGUs99nnp3kG+DTqwbBSxTybP2Tde4Kx5hGfdCCuvJwV4izPYPczu7QFFjD4Z
         gBYdPnTyqhCuxPJ37tILNz2gUpfdnYuiufoM+dT5PHwsR4zQyfPjyjEg9+VYXrsGONQ7
         fMNpCJI07y3fVwLTmaEQoLL9BW95h1r5yTEaqKL10HTmEJhRhxkB0GPVt9hcBQJZwxqq
         59OeTyw3ZxPc2dFSQNA3MAQi21u48n7SHFvfQYiAG1xYZeck+MyltcZkeM9VtbOmYlfV
         zszw==
X-Forwarded-Encrypted: i=1; AKwUvByPrgF6AYxtPmhZGS1usrMzhtRDczjRx0xXyi2WaOT9tQj58fgCc3iohpVcIcU77fALsSAnCBsuEX2v@vger.kernel.org
X-Gm-Message-State: AFuF++mmL25MMbwCbhXYE9r0n24cVK7CDy7ON6H5/NLV86VHfa/8wUHs
	uapfxu0ROqLA1o+YNrn4x7+D4bl7xEKtbhdi67keZ/kqY60+cJyCajRtO/yhSSx0liA=
X-Gm-Gg: AYBFou0wpRlrJALsLBPn8iCG0bhH+5mlA7q5cA/+CzBMRwEmdi64MmrO/6+V5GRSY3c
	ZTLuGzwjSyZfxeJZ4C6lLCsWVyfE80PCa6uuMsrr5b3BH63XBKQvYwvzX7onE2doRXmBwwLoyBt
	li2aaKDVnTplGQea2WxsuOUZ4XQnW4SE5CCsjkvJl64GB+eyC50G1l9msmqotswY+pg4rCMTGvx
	+bzODFzJlY+V+HVcYuoM6OwHfYMWDUVO+wM9zyDKwz+P/Jle1ymtaswhnTAtIv+aACEykechMJN
	YnvdG2x0zp/Ibbfzt6cci8utnZxg/iqlpWB6LDSlossRl1+7yl9bs3ANNIOgyz/gDNhOnuqw+zd
	hgFvS3wYVjweiIaWbGKinG98OB+7bgu9/vKWOUTHH2DAYOM9t80QcBvrAA8W6ScHKwC4aycl5h2
	vOS+LOlGzwTz6ebF6cVkxVinGzKoYKuDJxpNYgJJe4/Bi4EH2Zo7jcmiXFiXLnsh5OHBYcsUB11
	NeAflxR5TzkKsI=
X-Received: by 2002:a05:620a:29c7:b0:936:dc4c:3bf4 with SMTP id af79cd13be357-93e9b7436bamr598926085a.28.1791397000824;
        Wed, 07 Oct 2026 11:16:40 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93e9915a259sm272174685a.22.2026.10.07.11.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 11:16:40 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 07 Oct 2026 18:16:17 +0000
Subject: [PATCH net-next 4/9] xen/netfront: check for failure when pulling
 in xennet_fill_frags()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-b4-pskb-pull-tail-drivers-v1-4-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1791396985; l=2095;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=SzoPfHs/Y0Yp5wMeUYR89lBIZmoL94dSQOZucEHgjz8=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QE2mPs8pQLqezwaIQAKe007VJT1pjZBj9lcqG8tW/4kuSaDQpOlcqMEPoJV+xlZe2oi4kfjBSKZ
 BVy2K6gSrcAQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

When the skb already has MAX_SKB_FRAGS frags, xennet_fill_frags() pulls
the start of the packet into the head to try to free up a frag slot.
It ignores the return value of __pskb_pull_tail(), which works out only
because the nr_frags check right after it drops the packet if no slot
was freed.

Use pskb_may_pull() and take the error path explicitly if it fails.
pskb_may_pull() does nothing if the head already holds pull_to bytes,
so the BUG_ON() for pull_to < skb_headlen(skb), which protected the
subtraction, can go.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/xen-netfront.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 2ed673649c48..6e01a883cc64 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1174,18 +1174,11 @@ static int xennet_fill_frags(struct netfront_queue *queue,
 
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
+		if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS &&
+		    unlikely(!pskb_may_pull(skb, NETFRONT_SKB_CB(skb)->pull_to)))
+			goto err;
+		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS))
+			goto err;
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				skb_frag_page(nfrag),
@@ -1198,6 +1191,11 @@ static int xennet_fill_frags(struct netfront_queue *queue,
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

