Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153C84DEC2E
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791396996; cv=none; b=Qyqej9mhfw10UKrynv8sXwP71AtrpAr2Hn3zecpkO9cC5aS8h4pjkO5iVp1vox+HFLrfMms3WwF1L/aLynI/ZwRHbkWuoDos6yJaH+NBg6lvINtJ9b18JiZGmAOwQcmhs80VlAbDZCJKnc/QNNP1pCPljNV/YWm2YFKvdKTdU8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791396996; c=relaxed/simple;
	bh=YaVSidg1Bo1cVWoGQJzV4z/nBT+SLxbK+9NmCYkL+oY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Uya9tupgcKL5J1iOl8ojWyxQaQcuZlJnEj1xH7OxfcrHLQvPq2tAjM9HgGWZNC2FZoszfLCZ1zTbKZOpNP0Ddq3K40sw5c92KZxfVc5cYQ1Kr0tbTjiV/ELpz0ZDV0H/CAI5bAdhkQWmprk2K39nQIXCeo/uPXW5HHiDBdguHio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=lvQCrl+R; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="lvQCrl+R"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-53506b44151so32689171cf.0
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 11:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791396994; x=1792001794; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a3FpKl0vN7petfzZgqIhlc2NP9KQ4OIDsR/ta4Cqq6o=;
        b=lvQCrl+RoI+yFumjZBSAaszStUuxGwx6XRx6oEqnfHCSH7HACC4TJOH2ezqbmxnSM9
         QeCrOqDxLbAlYJJ1MZd4z8u4MQOq/MUVqjpmROQRRfLlSfpmQmkNnQ63UxQuRhMXxpBa
         1jD/J5AtAvEB1v8PnIg6KBNR2c2PtrCBfb+5dyWZZRVvk1NY0lDBF0DyXtMxNR6B4zO1
         h7UrHzrGyeg6AFq2/2ESr2MEeJ0vjPV6eLJ76C5AedOmFu6B3hIc6R9mbQOkRYGKGTXn
         qHSF5EaNs0bRUFeSySTL2u6BMZRQI32QMs4+RQ6TM1zP1KEIjeXLlZZ2E2dwSEDi/LpD
         usuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791396994; x=1792001794;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a3FpKl0vN7petfzZgqIhlc2NP9KQ4OIDsR/ta4Cqq6o=;
        b=GfU42/+9jZMywdxNrOy3ebTmQU3O0F63SQlEQjpn1A5kIRKrWihiOknmjgX55qefOm
         diaLJiT3YZ0jbWiHHmU8dS5cByqMJAXzGtx+m5vJCqWfZY3KgcTZQVejfZygGV48kSjW
         ayKRm5J5TsCof+TSZ7WSVJXu96agkTtm75O4ZZXBUe3WYw+EVEY6yRkUhO/tEzFLleO/
         ASbgaxNDRa8NyUtnCWoM3Qx4/6fEPMqMP+sIw5fR3lkq6252YBXAGZDCMZVsfjUQy/fX
         zmIxKxiflf/8MwAlw95SvMR1QISQFtSeCZ3qhINAJTH8kVLLkrJEBQUqnc0pnk4YwFVO
         24jQ==
X-Forwarded-Encrypted: i=1; AKwUvByqDw8lI2Eg4jE94zUn16kKu4mBStmEsUBHp4nJRLOLBPMfUQcZwwqbfdMc9Ntmwf1QXRp2Q9kegqRF@vger.kernel.org
X-Gm-Message-State: AFuF++kVhPcjfkF7D0eNa/uPXa1EiGL9jFW/42mAO4nqxhWeJrqZLVyl
	t60wKYZWbkOvLMcLx0rKqJ+tJl2HxST2zqQdfuONkiSVNgd1kZAejPcdJgDHzJc1pjA=
X-Gm-Gg: AYBFou36mI8sUSbnvw/qUd/hpfLJkhQ3jZuw1uBYXwLwSk7SrC9pusC0oLQmM0dgMVt
	I/LZ5B8soJG4cbeqJKScj7wphfO/9p+CKTg8Yv4TKFVgUxZkx1mgy1MHZ4j7lcEQfAvt0K38IBg
	YgONhwPjQED7XaWjQO+Z/8F5LonPryc1DaHrEuL1VaDX+YkFb/9+nlBiS/KJraT3qDs5BLVqcGO
	UpjSS6K900tLOOaxElAZzkJ8sQoFtqnZ93SBdAwdazhZWi/fTcSsj5pkZcgNiuQ7n4t6fNCXo/o
	jfqTuzAGttsbb/zL5XIaDXHp/i5sg5ufbhZTlrZlQplMngBCYC//JyXtBY3QJvTYGj1qh9/2tLr
	vpBbjKuxgeB0MZqwCRy74GfIJr7Zm97bSquQZm0bKuZBEnPJZp8+WGGbP9k2/G1x9bfDLmmEvRG
	Ak7+qNdBALOvOO6VgQxDiAjtrCHr1ASNS+zWwi8bJaDa2QODqZrc8bsF+t5wtrd5HcKUHGp/cFY
	BHH5Gj16eF6z/dT8+oq2IfcSw==
X-Received: by 2002:a05:622a:e113:20b0:535:8607:d2e2 with SMTP id d75a77b69052e-5358607f4bamr14319421cf.56.1791396994064;
        Wed, 07 Oct 2026 11:16:34 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53572163ceesm25476671cf.20.2026.10.07.11.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 11:16:33 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 07 Oct 2026 18:16:14 +0000
Subject: [PATCH net-next 1/9] net: ftmac100: check for failure when pulling
 in the RX header
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-b4-pskb-pull-tail-drivers-v1-1-9512b0fb977b@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1791396985; l=1745;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=YaVSidg1Bo1cVWoGQJzV4z/nBT+SLxbK+9NmCYkL+oY=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLi6NM2cH1GaCjQ09bIeFY42DV/aexWSzx1/i1cHNG8H1PuIyQKikelvwnWe7Tmx+A2sBSVuNWU
 /fPwJUm49cAs=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

ftmac100_rx_packet() uses __pskb_pull_tail() to pull either the
Ethernet header or, for small frames, the whole frame into the skb
head, and ignores the return value.  If that pull ever failed,
eth_type_trans() would find less than ETH_HLEN in the head and BUG()
in __skb_pull().

It doesn't fail today because the skb is freshly allocated, isn't
shared and has room in the head, but that's only true because of how
this driver allocates.  Use pskb_may_pull() for the header and
__skb_linearize() for small frames, which is what the two pulls are
doing, and drop the frame if either fails.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 40ba001d4b3f..a1eb04ead2d8 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -469,15 +469,21 @@ static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
 	if (length > 128) {
 		skb->truesize += PAGE_SIZE;
 		/* We pull the minimum amount into linear part */
-		__pskb_pull_tail(skb, ETH_HLEN);
+		ret = pskb_may_pull(skb, ETH_HLEN);
 	} else {
 		/* Small frames are copied into linear part to free one page */
-		__pskb_pull_tail(skb, length);
+		ret = !__skb_linearize(skb);
 	}
 	ftmac100_alloc_rx_page(priv, rxdes, GFP_ATOMIC);
 
 	ftmac100_rx_pointer_advance(priv);
 
+	if (unlikely(!ret)) {
+		netdev->stats.rx_dropped++;
+		kfree_skb(skb);
+		return true;
+	}
+
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	netdev->stats.rx_packets++;

-- 
2.55.0

