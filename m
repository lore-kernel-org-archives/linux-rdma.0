Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB694E0214
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791397008; cv=none; b=lKaslBVJl9cW+ZNjRL9ZBsVuOARNJ6FIp9gK88M+NEJCFcbebe8VX0pUm+4sKOnH0DDtR7BwImYPXqcI+DHCkJr4s+7DUO37kaRmMzrI2vyo2dnZxlDouEHoMMZXbAwyiHMUfqe1OUurINYPG3naKsT03agriJawWgHhf5kuPsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791397008; c=relaxed/simple;
	bh=2XY23bjEEEbmilzyi/OT0dLNP6D+zOB3zspYb8/aVZ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L/jZreVQabQsFc/vg696kyBPhCEIdEjFg6dqtBpHrGWUGW4TYjLBPRjstloavGRA3dY+nJwEeCA93vU21TSxVQ0GGST+BTmxcwJvch1hBxL24A6DdvcIbdGcCYimZgG2HGSI533M8vs1q2ez49a68pxgVCI9PoAFNJgpZXSEUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=qOmy5FJI; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="qOmy5FJI"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-917b78dfe30so30940976d6.0
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 11:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791397005; x=1792001805; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pgpiLoGoqA0xV5yWN2rO1XVw1oOPWsG2lgMDpzrz1ts=;
        b=qOmy5FJIFA9FgCRq/fAH4VNPjynO8hT/VcxYkbF6DB+9R9uzsJYBWSg8r0D+5uy0rZ
         vfmmVeQQMv5ZZXmJrMECkVpZ97DB3sy9/ch4lHeAN/ktUuG4QRVDCh8Huey3rZX8G90X
         aVvzXkhmtZRHqYvqyGK52JsjfRZDHVwt9SI1fyJQTg2XbSW157ywLBiOSYDE3k8bjpzR
         tXf2YjeuBU2fapXXNghankocvJPOuTzYWFd4TwBBkMH0KDHdL2OBOZ0I58i+jTvgUCkh
         0n3xow66uh0zXYQz1IOdlX2GRkBrlgA8qgU2Ho/F3nunZyqJqAxFQcIYQyG2d6M3H0ea
         u/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791397005; x=1792001805;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pgpiLoGoqA0xV5yWN2rO1XVw1oOPWsG2lgMDpzrz1ts=;
        b=WFLhmeU+Fe0Kf94sBTRuZPALp/gcrf1sIKIuGxPtPsltU6nMUprP1MXGXHoOEzhRUg
         UVmviiIh4HP8Te9vg8VhNI3hCvKQ5pgj+WdVXIBT5vh7pU7m/cmNfuauUNpkqdYrKptQ
         nEPXQUqeMYJT4C2JVnblaAdU3YN8rmM0EB5KXoCTkFU08eJP5yohbkbGp8PtDuR3/Opk
         6vFLso3pwB3nOzZd1uG5x7Khbm4iaQsxqYqTqhRIlUV/Xxhr3DegsXECuv8yB21VTtwn
         p4e9QYfIQIFq4w2WJGTxlpktfkYTGVHcdSXQL1S55r+a/FesXh1YMNcLtf6NSAa6CJT/
         3SJg==
X-Forwarded-Encrypted: i=1; AKwUvByS8yvvJ5SQ3PB5uBbbMdFRn1SVGTPT1ib1GGAH1kEqTu+9SD1kVDpw/+Qi/OiB7wimszL6gM7ecb3e@vger.kernel.org
X-Gm-Message-State: AFuF++nbv61v31hTnNuJF3NbOynBWzcCmVFH+z1Nf4GPLv47H0tcB7gO
	J5hHrQnu7kpjbRwGt9i85KqaxwNHa+0wqTNDAySqVg3f55MC7VXj8ErGgRED6SHdBqOrYQqNpGS
	X0IhUBwpiQg==
X-Gm-Gg: AYBFou1EajbC9E8vALfQMbcL4E3NrzlL8Si+xkGeCzCQLIQlSOgmeYt6snxlz+I+vMN
	EdW99iKL9p9Z4zk5Znhf8FrCLge12Jv3EXvyr8z8QQNlSvNbKVNUR3SPtRqXUykadI8xgjXEkOE
	cwJYT7ARS9V9VKxwsegThmhedBUuRNWFVJhyXyKyFKQ4gK4LYLPYuX5tZJEiBHG3P/Qzxoha7Fj
	TGdV4qrH62YB7ejQAbLMhGWhDhFOgXgfQYlaIFpuuR03UrHPFSKw488nOxOVnHfct7j0SBapRM4
	SSULZdFgfZjoQma3vuKlwmj7qyRCLtogBgQvTTFUNd4ySPAJ7LLt5244xAB+lbcwbeTbKFyN9Ks
	3L6obyPko12zarWshvOqqCy6b6jfy12PRNJjUdVDnNv+/FkOZBIHykgujQy30+4QP1VSLzJVcyk
	l6ygKnEbmQrbWPV9MLQe2nNzfy0YoY1HOSXUSBaJJSbU51yPdL2+87N3m0f3xi2DMmEDwvIZydG
	gAW4zzemRK3m1Y=
X-Received: by 2002:a05:6214:2408:b0:90f:5154:6a93 with SMTP id 6a1803df08f44-919977eb9a4mr57210916d6.11.1791397004534;
        Wed, 07 Oct 2026 11:16:44 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-919aa0ff38esm986706d6.26.2026.10.07.11.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 11:16:43 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 07 Oct 2026 18:16:19 +0000
Subject: [PATCH net-next 6/9] e1000e: use pskb_may_pull() in the 82571/2/3
 TSO workaround
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-b4-pskb-pull-tail-drivers-v1-6-9512b0fb977b@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1791396985; l=1188;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=2XY23bjEEEbmilzyi/OT0dLNP6D+zOB3zspYb8/aVZ4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCZC1nd2AgIaYMzIFdyfEIqZLuxEhag0euZBWHhtKoqomivMvwvOvEoJ6R+5XulLE3AuLwN94C9
 RAHLj79e6mAY=
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

