Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794578243;
	b=NjkhbADEbo+O08xAqjd2LEKGV5YBgsT/fqaoomg3pTlBeYtngQ7WEu/ePwvm/vsPONoD
	 8BO/Zyc3I2766MILs/dz0qYaPxL00OC6QBqZFaSEPKpjcVuolbeS8zcN5EOYHtMwOxlYf
	 3Pl9EhYPimfi9TBaJTRbZiSxfkl84BZ9lGJLds2nJ5mEWoy2vXovZ6alQPEb2SFxCXbV+
	 jQjuM9Sc/SEfl1IyXhZkTT8aP0r55xc2KbewQDoAixsITXKZxPEGQBxSgqbgacMD0lVno
	 mLou5n1tpsaNxqwrNB/yETqDvPVDwDzn6JYraxthC8O9qRFHXkVw4AOaqhkIhvCFvCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578243;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DgpYO/VSAfAhMfvdbl5shO5wtKU1LiPu1ETvfgfLye0=;
	b=B73lyguhS0eoXpHhYuaH52k6ndAhJmiWjqg8aIEmYmXmB0hQ3MyfslHvcpUMuRl3Rv8Z
	 kJIoCHcdZeSci1W6WpNdn4Fz/m3Sxl5PcHLyEX+XMnOHV10sAmkI2PcXON7qfFjtHLBlx
	 jhwppbwfkCYYYYYc7qHNshk2kLR/ImwOKU1+0VFS4PhCXWAwxOXRoYazKP80O2uP/OHJQ
	 KEKpmj9rCuvJFzOwIMlAZobshuxDBPs29SShH4A/hFsNWa12RRivDyH1JOg+by1v2vJBg
	 OEuN2fOQNjG0b/imrJ5IuNSXieDs3oHfYBNi8Tcr6X4QhOmv/sWj4XzYjCJ7g88o8Lw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDpcg874;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF89606A33F;
	Fri, 13 Nov 2026 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDpcg874
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794578243;
	b=J2+lQAtycUP4YJP52ciZvNub8jZcUpzxeBAGpGqVHvgoBLIZrQ5nXtWcqZVi0T5jrV/b
	 HIOTHrtO68NgduvaMA6m2UJTQNQxmEZV8oPZtsP4jNo2MTZKyG1YcEzNFNKLIGw5XlQ9m
	 8a2aVlXAty6rQUP1rLhA9JDOtEFwSs53rFnMYDVotpKBX+90ZA4NnMTmDjOrtV0/ObmQd
	 oo+2wKRQA+TIUvwxIcGNomS4v+ECNKAUNfqWvwcpeRxOQtjt0X6tc97GFxgkPaJYG3GJv
	 xQqfcNlJQcRB/O8YCaJk7j6uHaJxlU+pBhBjD7+LdYOhRUdUNkHecRj/+48RHLxAukA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794578243;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DgpYO/VSAfAhMfvdbl5shO5wtKU1LiPu1ETvfgfLye0=;
	b=2kYlbIIHNqFRQk/Pl8JPQpgT4vhRU/lwwUlQjNAAqJT+9j9KtRhEWz9dI0KeyO3euvaK
	 miN7VNs0IiNNEuYSQ/EipVO1Y8qphtu2yrSMMBTA6DHwPIwQF8o8nbwh2HPXnR16Hi2CF
	 GVsr2XOFk5zCNHyasHzsTeYSOW+7AQHfR6aVriudL3KnDjr0x8PCSdQ3RBWip+pgxxskj
	 u6KmKBOPLU4sRevoP8y/qZ+p6aKZmNL/m/52sKRSpnrqYsVCngHXJ3INn0d9e/HX6/Ou0
	 WpAFXhJIlqX4uQsO2QvVm9MgQ7BkOw+tUtj8FOPoTueTdGHwAnyNygc056v8aQXRmLg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BC1E01F000CC;
	Fri, 13 Nov 2026 13:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578243;
	bh=DgpYO/VSAfAhMfvdbl5shO5wtKU1LiPu1ETvfgfLye0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QDpcg8740wJvqj3Kr2m7tIcWDvYzZkZ0wItMwSHaGw2zq6El8Z5EGlsl6wOegLQdL
	 VMjB7s5g4BoNmWchWUKtZEV0TgiWUD0x2/JrpcghO7DpRSVqflQD+htDYf1D2/nnQA
	 0M59mkzPvdWp1iSMFlJQ1R5XAVAnxdn/CVepG74wcu4hvDBeMlwOpkktzRjFnkauYh
	 mEgfRi3R7DldVuKKcpAg+uCj1gxvqPK0rnM90F1XgJyShtRn5qY8Jb4cDM+CtLKfT5
	 Xim/NQ3f+/7d1P9QRrWqFJmtugNWb1pKpO0/AtiNRc6cNX4A7D8TracvK2vkLa6Gxr
	 tUCKAjZn4FhQA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 34870477DC;
	Fri, 13 Nov 2026 13:57:22 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 13 Nov 2026 08:57:22 -0500
Subject: [PATCH net 1/2] dibs: loopback: reset the client id when the owner
 unregisters a DMB
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
Message-Id: <20261113-b4-disp-19244662-v1-1-39b256b70ca7@proton.me>
References: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
In-Reply-To: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dust Li <dust.li@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Alexandra Winter <wintera@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, 
 Julian Ruess <julianr@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>, 
 linux-rdma@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794578241; l=2169;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=KBghDMOoyAS0OHozRJLfnD9xGKdfuhieCEeZH/+0AEo=;
 b=ao6MdYbeFjNiyBLA7eJqe9r9q2xkL2cdgXwtEyuVBujzXfzJIpbt5P9JOAQEMFhWLELS87+4N
 /5PQytpKWyoDJQ0VsWP2hm/PVfQL0T5vwqmVwScun/vXLqHMaJHLej8
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


