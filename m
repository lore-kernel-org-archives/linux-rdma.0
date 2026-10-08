Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F134B45D913
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 21:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493431; cv=none; b=sWWdTSjwf+jPpszQpIO5oYxkHxojAhWfoeEH8EHp99rWcxljnMLjFt4kpzIk2wg70QP2Qcr9JRyc9DkR7fnDaCw4vfy/psjgIAV/EDWPKSTGjoiGLQz428s9tch/5/CkmJtovTZ/jJ6ybz1m83fwzFKTehN6iRIHaEWF7+9cCM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493431; c=relaxed/simple;
	bh=ySH+2yHpni3G+Qu86hbeGyzGTFoSfZJVBnTvasjUVEw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nkRb179NTN6OOaFE5DLMtGnMj5TCAkobGM+QopJBi1rzoVkEqv+/GnqXQf9tEcpNVBEgCJz5jGJrJPpSzQDDpxVg1G3tQfalSzOVRw9PMEumHuB6R+IHKn+GyCeBtNi+AmvPLYNf3P3lfRd5f59uvz+q6Bf/XXKHmdFrs5NjGXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=Wp6QSne/; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="Wp6QSne/"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5350c1b9e0dso70325631cf.0
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 14:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791493422; x=1792098222; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=soiW+4bnwYoMWX+4s8jp0T9nXKlporFXyr3eC0IUFGM=;
        b=Wp6QSne/U1g2tAbxpoJGXXElPPKvwRG7qHAd2CyRr6yYlSUclR6DJXa1AJVbQy/PUd
         snN+/rNCdKO2rv32A8sBI+zfcr/mzuKnPs/EELhIER2KDHbZq2goiULPAUw5cRwHWEyr
         QsiO/3/wE3yOW/imb4JuBVwA2e8xcMCp9b/s4TWOhcMMMOXBqKWGImKQ85ZjrAaneHPR
         l0WJdx2k1t0zP+Bla23WKithJzZAFkuN5yTfH8qURoqjs+lqF4RKQWnSWQpVsDqSzxco
         UPdyNAoBFstOsz2yVn5aC1cjgma3xjcD6MNWUqzNomSx1bu6tGCOZrlPLtTFpTx1CW/2
         oPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493422; x=1792098222;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=soiW+4bnwYoMWX+4s8jp0T9nXKlporFXyr3eC0IUFGM=;
        b=mhxsgdpoNKjnROJrkBBwSeu3d/bqjpuLJyGNKHbMt6TkyXU6LKblTXJpdzkEioYow2
         MXNwueXN9VS7nVeULE4l3QLdJSLHRUWd/YcV14fiS1FyTtM04re1tFSAIK7HWwnB9cif
         I2u0piN8BxLfWL9Dbm+QUXxwMHJ6K0PDqWIGQZOtNTAKEjeVlvVp5yGu6ru68XmnVbaG
         M1I0QIR9W/KJDoI7RKZZyfUXZ3BE5vmP/m0nvE9lB1nKLSqdw1n3IIW2o5fWMtCJZBSc
         +GDNJ7azlAcT/bon3mCUBvjD7rpNmp+GYijJGVNajdvAceFBNhtBkVy6O/xids3LDcUU
         fTBw==
X-Forwarded-Encrypted: i=1; AKwUvByqXf7eav0NaHYJDppBJXVD5aOnKWlna/AxHH/35r6PcNKNvXWziS77MgS+inOiH45m+ofdXPUeA0AZ@vger.kernel.org
X-Gm-Message-State: AFuF++meA0ki/cHxth8OVBEMgWwQZrS0bKBEnTvOWKlcox26QPDsfq6o
	3hhoQ+7aq3RMnqAGzqE7rDxpMVyk7OvjmTytiLHlhs7jaROFdr8cRFX9zJSsF8fbrJw=
X-Gm-Gg: AYBFou3N5EjaygekoR3Pka5Q8CjZFIdJYTLBA9pXWQKU5pTprSQSDAVXGO1s5H9WWcR
	lv8+HLfJkkPK8A3JvdS9LVQusupd7mZ9yeU4KkB+aPPaAvBDrBsIDckfUrwR2ETSZrTf/PPAW2E
	jutsbiFyWNf3Oz4xEQZreyCyVjXnLwcZnn22JLqpe1s8a3dUQRnfNEf1hQyc9FBowsmoaPMa528
	/jks6oYM40j8Sq74+/FnTh0+ZgXN9GXHrUAG6/KARv147TUyRueWn0GHtRt1at44svlpoM35guS
	4g8DXx75sle0krS2y2hghcteAtRpfdxnPxknNiua90y3qxG5V/nT/zaZMomRabTehZJ2EDZuNRm
	nHM4HefuvZCQ7Ed/B/3ffJz7LLzs8qHbj9XanXwH44Y8USnnBRm9Qytn7Sx7Ju6LvGiYFUSXAbD
	+uZRDom/8jKAn8kKVmPTdR0eP18xCGbv9nkDRtmPS4cDaETNxiG846VseNgfkkh4JSbpbtTgcSA
	UX00l/wDoPuVh0=
X-Received: by 2002:a05:622a:4016:b0:530:f634:467f with SMTP id d75a77b69052e-53575391446mr121614331cf.15.1791493421782;
        Thu, 08 Oct 2026 14:03:41 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b6fa262sm3360381cf.6.2026.10.08.14.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:03:41 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 08 Oct 2026 21:02:56 +0000
Subject: [PATCH net-next v2 09/10] qlcnic: use pskb_may_pull() to pull
 excess TX frags into the head
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-pskb-pull-tail-drivers-v2-9-8f2bd9bee138@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1791493385; l=1476;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=ySH+2yHpni3G+Qu86hbeGyzGTFoSfZJVBnTvasjUVEw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QPIm2UmKVJ/FEKcAKGan3gEEsd83c98i++zBisuax140+xkclErvJSJq3lYfXk1tL7clYoB6cuo
 y7erG0zM7/wc=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

qlcnic_xmit_frame() pulls the frags that don't fit in a TX descriptor
into the head with __pskb_pull_tail().  It already checks the result.
Switch to pskb_may_pull(), which takes the length the head should end up
with and checks it against the skb, so this driver no longer calls
__pskb_pull_tail() directly.

__pskb_pull_tail() also releases empty frags, even when there's nothing
to pull, so if the frags being pulled are all empty it still gets the
frag count under the limit.  pskb_may_pull() returns early in that case,
so follow it with skb_drop_empty_frags().

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 761ef3bc8193..e7ab5586798b 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -682,7 +682,8 @@ netdev_tx_t qlcnic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		for (i = 0; i < (frag_count - QLCNIC_MAX_FRAGS_PER_TX); i++)
 			delta += skb_frag_size(&skb_shinfo(skb)->frags[i]);
 
-		if (!__pskb_pull_tail(skb, delta))
+		if (!pskb_may_pull(skb, skb_headlen(skb) + delta) ||
+		    skb_drop_empty_frags(skb, GFP_ATOMIC))
 			goto drop_packet;
 
 		frag_count = 1 + skb_shinfo(skb)->nr_frags;

-- 
2.55.0

