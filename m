Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794683369;
	b=xMWQOUoBEdxT9HCIjukw8LdjbHgcK4TDeOFQmoC1h0KqG9pz5kfbsXvaJFbjqKYZYG0h
	 6aZiKnEbTEJNWIgp+ZDWz+OPAfYpXiUnKqaDh/l5TFJYRUsTeXMmUGcy00DyHjMGIJ2D6
	 u6BtTMPFfuVAycUCAA4S030Tz3mJs2Qi250/3f5MHw2z4d6ytDyY7LqSPlEdaHRsojivO
	 bNvsQGD3rhaH9cikGxmxrM3ZZLu5BZ4sUbbbSZtEzZet/xV8diSzvHIRTxgl1e24rosjm
	 1hiKVNS+L60n3uLko1c8VEyIGT8TjN9KXnFrPRvicU5nBd6TBULkKqw7F0ApaZtKNuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794683369;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DgpYO/VSAfAhMfvdbl5shO5wtKU1LiPu1ETvfgfLye0=;
	b=wKdBCKedzm5iVnPKpIOjcbHEuBGgOUL4aADU+3+zFqFY+HcA7XFByaMwhCJ4VrpQykuY
	 EddwYAREd3P8z6hEFC/CXDIpv3gI8z56BGxodTbYddhVWSCf2xZDf7DwQyl40Tp7EGlxL
	 cTNH3ujuiEXQ+d8qezSfBlKJaDOdPmyMwVanETKzYsMvf7Q/bBwaLbpwNNGChP8l0T1tz
	 ABrzqhrhqBO/erQ49J56MOBiuMANapasdQtwtTMMeYLt/zZy1iyLmEjK61C2fAeB5i5D+
	 rXuYF8CRx+1kVZkbd1gftle95cVQldj2JWEOtENdcoRXkF3wFmNLia8yBjJGhGOjQ5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5o62hjG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE0B606A327;
	Sat, 14 Nov 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5o62hjG
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794683369;
	b=v0+FXH3ujV66egQAqsg3Ets65w10eAN/1pfKA8X1r5vfj6A3ONgqVBmCoAlGHw3e3Atg
	 uFHZr3Pg+sY83zugZ7ec94jMUtFpEbMgKRS4nxYbvYN3Krb/QrgsfXtTtGFh2jPo61c+X
	 O2uD+HwhRVHypG4b86tOxcY9BGfsHmxJGso9/j3I17gstK7RQRY5OsjYcqKchq6bVDXLu
	 V+PG0eoBB4DdYVKqBHHUoB6hiVX6434dLiwHh6kWXxsuLBkdKeNyzQMDQvn8rreFSSb9K
	 B/axO1GggyZBHSwOGIchorFad0xUxQEdOhroze6rdRyNFlOR7+JR3JhE9h5eeV4Ro8Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794683369;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DgpYO/VSAfAhMfvdbl5shO5wtKU1LiPu1ETvfgfLye0=;
	b=1Gv9EJKkWMqM13+HQorYOCHUAOEOIDYAbLy7tcB9Zrjpt4p0hp1oJd75KqCRiwKdhfH3
	 ZJcCUqPqHvOjCGPPSoBXu4DwHjnFrFkHES2moa5VIMoRLaaXvW+4mGRwcfrDIyWC+k5eu
	 X5d/wsGdPlWkQTNYEBByKuxw9tnrbbga4u3dTVIoSADlKPmE243XpSzMaarP9WUtTJtqh
	 WLIIL9QJGTW2WJluegBgpPpvnp/yZkMV62d8f31YHBK6B5qPyMPvgYl4cPU7jCUCHiBYO
	 0ANsLP64TT0QJ4YpSq6YCt4qj+AMKGorFponkKOu2Nj3HLogen7LSbkXN+RclgNgqew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B3C801F000C4;
	Sat, 14 Nov 2026 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794683369;
	bh=DgpYO/VSAfAhMfvdbl5shO5wtKU1LiPu1ETvfgfLye0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=b5o62hjGuh5zTpsuAztcENuS/XaJ7Asc2pOomM2eqLRH/loCPnPjM48CvMuutVuhN
	 YNBv04w1ca0yKZPMIv6JLxnlKXVuKuqdIID9xKg2cupzRrGhg4LyYRNVs7SIMtkb/5
	 abRL6DsSZ6JQiqMD0HfYn9fXBCtAgcSbKBYUO6BG3AEd7gMZvGH/hR4ZZTb7ZiYLGZ
	 FV1hGeRv3BFmcfpw/SJfnZuvI+ofHT6alNJDXV4xD8VfvmuG2vbcVxC6sP4fQ6opsL
	 UZdJDN0SOPGjtRMH4rv2pmzszIXwpie90Hurvp1yCFRUALOKav7viGENLvaWaHokuc
	 w6NAwlV948hMg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3D7BF49E36;
	Sat, 14 Nov 2026 19:09:28 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 14 Nov 2026 14:09:28 -0500
Subject: [PATCH net v2 1/2] dibs: loopback: reset the client id when the
 owner unregisters a DMB
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
Message-Id: <20261114-b4-disp-4e6374c2-v2-1-3b7050bddef7@proton.me>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Alexandra Winter <wintera@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, 
 Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794683367; l=2169;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=KBghDMOoyAS0OHozRJLfnD9xGKdfuhieCEeZH/+0AEo=;
 b=/9l8QPQYZLAIou3waAEOmy+zpFjlJVw19f5ZDrxH/n1Pdo4KNR8nNujFrK+VzFgABmShbGPew
 W6a1rVU+4TLC7ExKV491fm+hkAuA4Or/R3n7Sqkr50NmdSy6nTUKyVp
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

dibs_lo_unregister_dmb() resets the DMB's dmb_clientid_arr[] entry only
on the last put. If an attacher still holds the DMB, as when an SMC link
group is freed while a peer is still attached, the entry stays set after
the attacher's dibs_lo_detach_dmb() frees the DMB.
dibs_unregister_client() then warns at rmmod smc and returns -EBUSY,
which smc_ism_exit() ignores: smc stays in clients[] and dibs->subs[],
and a later dibs_dev_add() or dibs_dev_del() (rmmod dibs, ISM hotplug)
calls into the unloaded module.

Reset the entry when the owner unregisters, before its put, as
ism_unregister_dmb() does. The index stays allocated until the last put,
and the attacher's writes no longer raise an interrupt for a client that
gave the DMB up.

Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/dibs/dibs_loopback.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dibs/dibs_loopback.c b/drivers/dibs/dibs_loopback.c
index 44a2e74c2efc..566e61a013d0 100644
--- a/drivers/dibs/dibs_loopback.c
+++ b/drivers/dibs/dibs_loopback.c
@@ -138,6 +138,13 @@ static int dibs_lo_unregister_dmb(struct dibs_dev *dibs, struct dibs_dmb *dmb)
 
 	ldev = dibs->drv_priv;
 
+	/* Reset before the owner's put: after it, an attacher's detach can
+	 * free the index for a new DMB.
+	 */
+	spin_lock_irqsave(&dibs->lock, flags);
+	dibs->dmb_clientid_arr[dmb->idx] = NO_DIBS_CLIENT;
+	spin_unlock_irqrestore(&dibs->lock, flags);
+
 	/* find dmb from hash table */
 	write_lock_bh(&ldev->dmb_ht_lock);
 	hash_for_each_possible(ldev->dmb_ht, tmp_node, list, dmb->dmb_tok) {
@@ -155,13 +162,8 @@ static int dibs_lo_unregister_dmb(struct dibs_dev *dibs, struct dibs_dmb *dmb)
 		hash_del(&dmb_node->list);
 	write_unlock_bh(&ldev->dmb_ht_lock);
 
-	if (last) {
-		spin_lock_irqsave(&dibs->lock, flags);
-		dibs->dmb_clientid_arr[dmb_node->sba_idx] = NO_DIBS_CLIENT;
-		spin_unlock_irqrestore(&dibs->lock, flags);
-
+	if (last)
 		dibs_lo_free_dmb(ldev, dmb_node);
-	}
 	return 0;
 }
 

-- 
2.56.0


