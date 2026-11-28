Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795878311;
	b=o1jDfGTnXtKv9dgANQFStK4LbMO0K5+c39wTd3+DxFDYa1wEmz5KoLG7m+tl3DpRI1G+
	 PMU4EeGrx7wFq4Ew6Pf2gq8uQDZRWRSKiFjqqOwm9wTfO3MmAUdZMsQ9hcndAG0d8Y4ae
	 rqItufpEkpJ+VR6IHTGrCgvSfcHnJV0z8oWRBjHNDf6Z+ikEWDyFW4US5Qg4bIA9D7Vs5
	 zdEGFqvCu2IcSZEv2UmDns56jONQ683jUDKF/yKGR9Tg5Atz1mDk4oAx5SFhcO4nM7i6l
	 p5t82MaqzdmHetkGWZUQZPbunMwG12+vuLSUctcGmXldo9AiEs2cCa9kPoPwlR8eRbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878311;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jjUK3mTmNs6/+OO/6Li9H4he+8cJ1blaQGPAJ3xuvy8=;
	b=usy3iqaMvCgdYjPt1YS1Vji9FJjKGgYYTv+SmiYA6YFPHLVhbtbQKE5HjIZvAewHXVDi
	 VYAP5WbvQrLmwVQ+I2r8arNLJouaId7ufilk/uIWA1pNLs1Jok99GkQdaZy4MIVVppwZD
	 nxGC0UteC6cd+QN6D5OTy6oARYtoBawgu386sB93ruKyWLzaqAoGVxAJ3Qz9a4LkYiK5K
	 iWqREOSdK3xdwUhhe3gCeSqrdbAWpBpQFA+L0Dky/56RRlqOZxxsrPclsQmt0tcQ5b62B
	 074IxWE2qgPw6kTC06x+19X1BSRcR6Ai4sKWx+hdhpwepnrGrYp+w6hzomIan2Lkybw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzZwS195;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B11606A31C;
	Sat, 28 Nov 2026 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzZwS195
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795878311;
	b=3pHN0KeIEsWxsoarrw2hq44cMaT+Sk3qYdqxP1BNWGF9XXBSf3IOvMHgnaVMYZiuTki3
	 rtPxF2mlRRyz6+hwajLbLhR+dFfP/NDHvex3paU7v4wlNCd/aopCzx1WjmjwpkT6Vyhv+
	 dl/23w/aO6LdgYjJv6YTNy/JjEp45Usuk9AuP1l/VCrvmSzdv6gE4VPZA07fcvQU4UEjk
	 Xi9p+itiRK0lC0tnqLSulOFJkiEHuoZREBNTU2KH145ZHt/pgOZ0xUZLDCJA51JvFpsvZ
	 RB62SUVokOeFwMgJO3zk2BkPTSO+WBQmbgGzM9345u+CGHdGt2JHLUQaflkF0EVA0tw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795878311;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jjUK3mTmNs6/+OO/6Li9H4he+8cJ1blaQGPAJ3xuvy8=;
	b=3nDaIbfiPmHRGE69hPy2EPiccTrKCQ3O+G8BB1pmoXhoueNz5V81g8+h1ZOPLT25MNaI
	 0acY/oXgeeJ4ltZDreAe/DgSk7ZVN40Bcjov5WX2oAXOKd7yzNGJlfQyV+MkGfQiNUxGw
	 8nWPrd/powxo03SlswtbQohaZ8kD7D4dVpTVH0kSft8zdl17WRXWvVMN0sRbz+sryVkQJ
	 h8kewsoOASKY/HZ0ZrhRQbijaUhqm0bYe4ThDBsMpsYb1vP1Pfa60ye0I8qHs1frpytsU
	 Nwr5Ae8EYlZQfpljAAC5Un6kVyijiO6PXux1SG5D1WXTIGS4b+WoPNCwpgQleVypjYQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7142F1F00893;
	Sat, 28 Nov 2026 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795878311;
	bh=jjUK3mTmNs6/+OO/6Li9H4he+8cJ1blaQGPAJ3xuvy8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GzZwS195tkEk6XxEQtJLbvI7iJ7GE54BpQDdPIMyf2sqqAMjc3a/8fhKwJ5AFV4CU
	 LLl/9xyDi450JMjaNbW6x21nVr3KBLCVH65iRZDArVrnsn50osXN4lSlkO+27Hp6mU
	 k0I96JCliIL9dE01r7Zsn66qOAE5QJ14zyko/1YockP4Qknejdv5t+rOd8W+b/Vq+9
	 DzDFHW3Im9AJyNdkV31/DXr+noDzLAbuWHVZmjawKtcY2if7xtXGpiC8PUsLGHn1D9
	 NvQbtf8h2WS2kb8luI0KzUMqodVazsBKSohWctwfV9rvbYxaL9Y+qHp1CzjI0NGczN
	 socgzcJ3ICj6w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 003DD4E122;
	Sat, 28 Nov 2026 15:05:07 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 10:05:07 -0500
Subject: [PATCH net v3 1/2] dibs: loopback: reset the client id when the
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
Message-Id: <20261128-b4-disp-2c190c90-v3-1-c566f64196c8@proton.me>
References: <20261128-b4-disp-2c190c90-v3-0-c566f64196c8@proton.me>
In-Reply-To: <20261128-b4-disp-2c190c90-v3-0-c566f64196c8@proton.me>
To: Jakub Kicinski <kuba@kernel.org>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Alexandra Winter <wintera@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
 Julian Ruess <julianr@linux.ibm.com>, netdev@vger.kernel.org, 
 linux-s390@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795878306; l=2224;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=BId6+i8yz1UdldMut/1HZZyea15lkC/2fvpL/Mxf3K0=;
 b=8+mC+8pdV7DLe/+o5eXWyh9JMDbSjq6/5vRHuTqPEYQf8YL1ttvTBppAzwY7P8LS4c8bhGAtF
 RvUdu8KJBecBDuxfFBrZnQj1NDls29ccUcJn9xBl2dHQmEPhx3FaaPQ
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
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
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
2.56.1


