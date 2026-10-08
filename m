Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB03455608
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 21:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493423; cv=none; b=bhSQ3M0QQjdwTsQq+4OHIalPkmRDTwh4yPUzvIJPwkck64oA5Rz8yI5NFDDxwRekbnuYCYy69YaK/xvK2+IxzwlFezb3Z3TQqYbLWB1gWewKabMVVVKEJnyWgn32vAmtcKmsljaxLIHnQaxSZdYCug0QK2zWgiS7iaIWMl9bXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493423; c=relaxed/simple;
	bh=2XY23bjEEEbmilzyi/OT0dLNP6D+zOB3zspYb8/aVZ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a+TZ50T/ACSHYY6t03cQdw7zUGyCzqNJySedEJp9dPEC6LO5r57RAXcziugsbEFye6IE7gyIC/YulWeVTHkwJezq/7tnlgwngnkOxUx0+3TOJ77d9d9Z4Z8VCC3obk0jxnd5EhbaJMtTC0LJYGaV5jNZxLQaeEcljhvhu5p7ufA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=iJe9mSuI; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="iJe9mSuI"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5350cc60b51so54327621cf.1
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 14:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791493418; x=1792098218; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pgpiLoGoqA0xV5yWN2rO1XVw1oOPWsG2lgMDpzrz1ts=;
        b=iJe9mSuI+Cqf6SYJ3kO6iDzcVJ1nbec3USAXCzXLrFkPle9Yjxm1g6soBsr0vfersx
         6kg5IecuO31dQO2C5BZnNV7FOnAYUJ05unx+pxsJc8PTDVQU+FZHuLlAkuA4f4mvrZF7
         a2SdfFxB3aT66a6YWor0vVok3TviBJtr2WMgugbR3lUVbNlCWifig/Ic5pYAISCvGFs7
         OD8/QS5yL7WFhnDeO8jUoC6swIZbyMmcOQiZRAZkaPXNrRuqSpEqFdhjctwkUdQS/KEj
         wwp5rGu1cMI7UABeyGv/QTgTePsLf0ufzfWpPvFF8O1X7WPVtnjGnPNpuleeGR9dkIu2
         /WHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493418; x=1792098218;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pgpiLoGoqA0xV5yWN2rO1XVw1oOPWsG2lgMDpzrz1ts=;
        b=AUtTSuBfM1sKSI8FoNTsWTRxtek0biryBqkuAgo0a7yhhwlrQeCxt7fi88YU9TME0J
         LGGXYaEsHqJQGnkuZLEVEDEA/yaOrB9k5T6Uk3zr9QnKSqrl6AMsXcmbKn8fNr+E9Vbt
         M/z2EHptrayBM8cEb8vnVGA6+MZrY60W/rUceAkyIwS2+9RpFfOpW+2wuBvdQg4kvvqX
         0hsgsyFK2NQ5DGcnR2QofH35bWE+E5ggGYrm3Cjc94pZvNsHclgJyPva5I5OyfHKvh/F
         05vBMif5V1cNA3H7pe+ZG4XkMZi/nL0rJywqZUSBOnYeZGfjM2+ssU2WXxL8kFnzQbFU
         wUsA==
X-Forwarded-Encrypted: i=1; AKwUvBwIAv4Hj7lIidy+aVIzqBxJyTddDt3ywTTN0pWyeew2etEMCW9D2BkF7rF+8kpoI45QGM3P5kIi7vXm@vger.kernel.org
X-Gm-Message-State: AFuF++kMjz4OpiQdrAjnuRVkG86SeDPBlX19KquMDvx2RfqHJrn4TSMS
	r/CxYxWGTWC4b6lTtYSl6hvhbmbX9fl2OqbhdhqimN5mIVNM1vn52kJTqXuQ6sZ9VV8=
X-Gm-Gg: AYBFou2wzMJnvJ8D2lt2VPFSgTTmGkiisiITTfevxkSycnOc6ev2Z/F7U8KCviuQcUD
	sVD5xyDBDmeh+yCifTrRc5iTjcaTM3LUlnDUC+/P/opiQQR/0l5dnuE6QHJ85JHS/+OpNsEe5D4
	/X326h4cC99+oJ1pvFO6MKowgG+wOWPrkTtWJ9CjxkaKt/xK2Ma+bFx59ThTo5787UW6BcpGJ2Q
	XEn/nqgp7Oj62reVUfXUxnBFZFpNyi7K0CuAJB3zD1Qz69mdEnsu9Rw1iG+nDdaAhlFmfxqitCP
	c83FXo9kVYyDgcq4BTRzZw4HiBV6KEveQGXUlTQphditSpxrUVFk+Qe0c0hX+AvnKgKTE+r8gom
	dpOIs6Q2lI71C1koEeAXa/jC2p/ISW28Q/DxNpN8Hao7n5nJKm47NFWZcfM8MSTaBh/r3CJg5jP
	8/5TS6aK2EUYgLMG6kTRa4E4rHiaZtZLVeVkikU7hfa3L1K2dclgyF3/2pCrz1cMS4iim/MQFGo
	Q0+Tg0F2sBgf30=
X-Received: by 2002:a05:622a:90a:b0:530:e52a:8ef0 with SMTP id d75a77b69052e-535754fe4e9mr117963541cf.26.1791493418024;
        Thu, 08 Oct 2026 14:03:38 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b7ecccdsm3179791cf.30.2026.10.08.14.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:03:37 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 08 Oct 2026 21:02:54 +0000
Subject: [PATCH net-next v2 07/10] e1000e: use pskb_may_pull() in the
 82571/2/3 TSO workaround
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-pskb-pull-tail-drivers-v2-7-8f2bd9bee138@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1791493385; l=1188;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=2XY23bjEEEbmilzyi/OT0dLNP6D+zOB3zspYb8/aVZ4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QAo/dBnlSZS1Mj/EC08Jadkujj6NZVKDZ6T6FMxXeYq/Bm8xNWGafGFpWL2jadSBYVOawvF0VKq
 O0PAtfO9A+w0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

e1000_xmit_frame() uses __pskb_pull_tail() to pull up to 4 bytes of
payload into the head when the head holds only the TSO headers.  It
already checks the result.  Switch to pskb_may_pull(), which takes the
length the head should end up with and checks it against the skb, so
this driver no longer calls __pskb_pull_tail() directly.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 844f31ab37ad..e216868e15cb 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5859,8 +5859,8 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 			unsigned int pull_size;
 
 			pull_size = min_t(unsigned int, 4, skb->data_len);
-			if (!__pskb_pull_tail(skb, pull_size)) {
-				e_err("__pskb_pull_tail failed.\n");
+			if (!pskb_may_pull(skb, len + pull_size)) {
+				e_err("pskb_may_pull failed.\n");
 				dev_kfree_skb_any(skb);
 				return NETDEV_TX_OK;
 			}

-- 
2.55.0

