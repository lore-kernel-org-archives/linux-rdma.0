Received: from mail-pj2-f17.google.com (mail-pj2-f17.google.com [74.125.227.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F13374A12
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090630; cv=none; b=g+sXJkE0mcri8jMb0oJGMOMFAt6lVWkJTwykjbQBNS3vdO0EzdnrQ9r1c1CkU65KwntYH9OUgeF11x/mKkMSBmI3xO7++dR5By9ug3+mJREnmFTqI8R3HVFfE6gswsc5gTo2V9WqAmTkrMm3GxUlJYB5znpELnt88tj+JZSdTVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090630; c=relaxed/simple;
	bh=wUM6fb0tuOzagzfkYb4kCS8D/QCp3V/7KkQWbozSFKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GpZz7ghpWDdUEsGIIt35GTv5+HZ+pc1fwZ2t6Hsc9ogq3jq5lrJ52wOMhgjrvjDDhMJp31Du/D8fZv1YVpDI3uMJ9u+IzvHP4Q4cQVgWP7MNoGuh/v+YA7iqJqqMSKUcvw/VpGh95tClNJ5gjjBJiiQPx0d2EcaIxr00ZwDiYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0R0EPdG; arc=none smtp.client-ip=74.125.227.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0R0EPdG"
Received: by mail-pj2-f17.google.com with SMTP id d9443c01a7336-2db1ca06a25so30765445ad.2
        for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 08:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790090628; x=1790695428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N5nWO2H5iRZirg/RaIY9a9oyFRHWVOmzKpoAp4+ltrw=;
        b=Y0R0EPdGSd1CTJpXm9XP59V5MUmnW0ZgsjRA4+SB4CegPtlU8zS9l0AvGaiWTSs6kp
         4JCXLTllqAA8hn0YltjERdTrX7GNPZBmcsJbU8auVRrItK50/uH0k4tyQ5Tt6f59KaCC
         6xbsUX/WVgScAqcpPWNk7Z7UMqcqKV4UbC8NRAfPihIXFB40MQn6TrVU5IYlqoiKsZt1
         hI34bCoBuq5w2b3b12NrCIqFLVYuehHBb4A2kmUs5itqhr727kWz6o1eHuVDMzFAMZL4
         TObPCcuOQo+s0tbv4h/E7FPtWf+nU+5dSlnsFnpavU6lVnWYy98tJ/yuYiQefCvY974i
         1gsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090628; x=1790695428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N5nWO2H5iRZirg/RaIY9a9oyFRHWVOmzKpoAp4+ltrw=;
        b=n8HJIOCZ8aGZaGSZmiQ/Y5NO4xAPklREwvJkl60Fk+e0gplMGXsyIQtj4ALOZGVE0v
         s2L3D6VmvAOHPIN+lR2b4jzU/SPsiuC89m5tV5fItAoihIsjEwHex2zW5fgxJgZIM3ov
         KCIrK3cJ7K2DEJBOU18Hq5Of2Be/aUFfW7uo0dx/eUC1ckQnCzxYogkZPzrZyzA0BLg9
         L67KUebag/0IIqz/qIqDQucCHpEfglR75yyD5g2j18eAyB3VxMwVefAdiyMoXNC1BsWM
         vjc4gJJ9KXoZnVimGsm0RAJkWwpAMHUsCamqQ2K4kmJPqkVAdU6+sgXRlnsxnGedii2g
         ZbBQ==
X-Gm-Message-State: AFuF++kBNeiHfgszGmje1d3wrch8ADToRT4/PL1NM9Us0UH8dqybkFL1
	nQrDipDkNLQPCCzF9IZ4/Tp2OAF6NVKslBoDGwuvVRWM5ObFCcTxpIR6qYV0iTvjZO6Nog==
X-Gm-Gg: AYBFou2Jzz2al29LUvQmm73fJyVEBUiMTBS9USuTh4adUw8y8/b4pKCb4uMOoGwzKhb
	kGJW+rchcTz3yZKDne/MUi1poG3siyIfWfpyE0ohtQqD1iGt0lRSFNxLq2Ql1ir/CNKEfHtduJx
	/55AhfoxLIhq6LXxxOgykq2V4EF5pGqy/dHy+2GU9OudiZoiVgE+22H+bjxjIO47kfvt5PiTjmQ
	aFeXPyZMg5vnOz1jL6szJaSoS+QEgmDm6X4Krnx0CS3uLBlKqv7SFVRiOohRCt7nAj4IFTxWwTm
	dNbIHUgK8CVHdmKVW5xPpHFElvVckl2+I6v96zX12gFRSEvCpumV59ha9NqD2tmJWBftQSuhlKr
	h85DpH1Yvw5LclCp7Xvga56hNGrepYrG2mlWzV2H8cg3nPyMyh0zPWZmHqYzp+K56X6lOoj5vPN
	2JO86C0zThRCPA4U+cpAO3emh8gnHan9eGi1KPLZUT0J4Lh4FTJ++5djIYMT79uNd/0LADwA==
X-Received: by 2002:a17:903:2f0e:b0:2dd:c1a0:c7e0 with SMTP id d9443c01a7336-2df609d446fmr17792025ad.15.1790090627746;
        Tue, 22 Sep 2026 08:23:47 -0700 (PDT)
Received: from localhost ([180.184.49.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d047c35sm12892635ad.53.2026.09.22.08.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:23:47 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: security@kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dairui Zhang <zhangdairui@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] IB/mad: fix UAF and double-free in RMPP receive reassembly
Date: Tue, 22 Sep 2026 23:23:42 +0800
Message-ID: <20260922152342.1474845-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mad_rmpp_recv.state is protected by two locks that do not exclude
each other: recv_timeout_handler() (port workqueue) uses agent->lock,
continue_rmpp() (CQ softirq) uses rmpp_recv->lock. Nothing serializes
the check-then-set sequence on the state word:

  T1 (CQ softirq)              T2 (port workqueue)
  continue_rmpp()
    lock(rmpp_recv->lock)
    state == ACTIVE  [passes]
                               recv_timeout_handler()
                                 lock(agent->lock)
                                 state = TIMEOUT
                                 list_del(&rmpp_recv->list)
                                 unlock(agent->lock)
                                 destroy_rmpp_recv()
                                   wait_for_completion()
                                   [blocks on T1's ref]
    state = COMPLETE
    unlock(rmpp_recv->lock)
    complete_rmpp()
      queue cleanup_work (+10s)
    deref()
                               [unblocks]
                               kfree(rmpp_recv)
                               ib_free_recv_mad(done_wc)

  +10s: recv_cleanup_handler() runs lock/list_del/destroy on the
        freed rmpp_recv -> UAF write and double free; nothing can
        cancel that cleanup_work anymore, the entry is already off
        agent->rmpp_list. done_wc is also returned to
        ib_mad_complete_recv() and freed again -> UAF read and
        double free.

Reaching this requires sending MADs to a kernel RMPP agent from the
InfiniBand/RoCE fabric: the per-port sa_query agent accepts subnet
manager responses whose SLID/GID/TID are not authenticated on the
fabric, and legacy user_mad agents registered without
IB_USER_MAD_USER_RMPP start reassembly on any incoming RMPP DATA
MAD with an attacker-chosen TID, no in-flight send required. The
attacker controls segment timing and can run many transactions in
parallel (agent->rmpp_list has no cap), so landing the
microseconds-wide receive critical section on the 40-second timeout
boundary is a matter of patience, not luck.

Unify state transitions under rmpp_recv->lock in
recv_timeout_handler(), keeping list manipulation under agent->lock
(which preserves the agent->lock -> rmpp_recv->lock ordering used
by continue_rmpp()). State check/set in both paths is then
serialized, so the loser of the race always observes the final
state and bails out. recv_cleanup_handler() needs no change: with
transitions serialized, a cleanup_work can only be pending after
COMPLETE, in which case the timeout handler exits early.

The race is as old as the RMPP implementation itself.

Fixes: fa619a77046b ("[PATCH] IB: Add RMPP implementation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
Earlier version was shared privately with security@kernel.org;
posted publicly at Leon's request with a reworked commit message
(race description as a function ladder, reachability wording).

 drivers/infiniband/core/mad_rmpp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 17c4c52..f05e9ce 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -245,12 +245,15 @@ static void recv_timeout_handler(struct work_struct *work)
 	struct ib_mad_recv_wc *rmpp_wc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rmpp_recv->agent->lock, flags);
+	spin_lock_irqsave(&rmpp_recv->lock, flags);
 	if (rmpp_recv->state != RMPP_STATE_ACTIVE) {
-		spin_unlock_irqrestore(&rmpp_recv->agent->lock, flags);
+		spin_unlock_irqrestore(&rmpp_recv->lock, flags);
 		return;
 	}
 	rmpp_recv->state = RMPP_STATE_TIMEOUT;
+	spin_unlock_irqrestore(&rmpp_recv->lock, flags);
+
+	spin_lock_irqsave(&rmpp_recv->agent->lock, flags);
 	list_del(&rmpp_recv->list);
 	spin_unlock_irqrestore(&rmpp_recv->agent->lock, flags);
 
-- 
2.53.0

