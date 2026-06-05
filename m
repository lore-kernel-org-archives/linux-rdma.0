Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6E38E126
	for <linux-rdma@vger.kernel.org>; Fri,  5 Jun 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780679707; cv=none; b=CI8VfmHwtpyfgyOFVPtROVLESaLCarsXFMjPf7200mbMiECg8NZUUtH7OfB+LOBy46SkWHGzw+GEysJqttJX+GbFxQaCt2sLQ6iR9ffPaoOMbAIJuaCRvzgVuDPcWtEqQIwttiiRUlekBix+/h3i2hf3IwuUrLa+5lugYmqr7LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780679707; c=relaxed/simple;
	bh=t0WigNGpMZmvf4quse345k2NV+vD6IJLO1Kax3B21/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+O3kK8ai/WoxjG6oYibgope+IDBbczwSNwPKYhf+6Cld6vTjErsYnJp3KsyVu3N80Erz39C+ixyIeek3tM1uysbsn/b67nTjRegGODUVhA4NUfXurzQoUtordY+QPTEX3UjsRRJopg98DHMGBXuUK9btxqULPoGYJvL3SIlOJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6KSm+41; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6KSm+41"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aa68d9d56fso2243330e87.2
        for <linux-rdma@vger.kernel.org>; Fri, 05 Jun 2026 10:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780679698; x=1781284498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNuMWdX3Tuj9FCYORwDrlXKxVIB3eH/elxKfaw867rE=;
        b=j6KSm+41UJX8CQkGFtZ4NbgWVLFEjRn0waSeMoOeHygLFcsQY9rVeA4iu0yFThasBs
         TNsGJ3oLIeIj1EJKkLt045LSgNXSmk8qeyWZdC1eGRp0QrSOT2wz8nYuhPAgDe3FN44g
         wo/CJ1SywfmENkyefa/N4a+25/otSPzwxgdWFwRxRuMsiZ1ZLJj1ZOxL7x42lXCTX+zv
         gaWcDrvQEcjquqfZPC391Lz90pcgFg165d7ao7MvHE7to9UA1fgU0aLY9+K6fyBslssx
         nakPBTtnQGJV5ERq5tVVQM3MM8Au6LRxJoAwRaIloZGG95YdXxxJ0sL/H8tLkIilM7yL
         zc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679698; x=1781284498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lNuMWdX3Tuj9FCYORwDrlXKxVIB3eH/elxKfaw867rE=;
        b=cDzKz1AgSKRwo6SmZecshvF8XtcvMIOrGXb+x37a+7t5PmUTWisa9UqwWea2DD1T+B
         BBfpZu8lplhfdre18lGL/dL84FXF9zsa+CoKBcRLxoQwILPDNzZvWJDuCtCyHEpe2rBu
         jA5KTTQMvKdOGkXgx09E4k1uGYvrdCDlfV9ima0R9XQu1TFsWtN8h75g8CydwvRzZtSh
         O6XJEGfrJTWQ5u6iYWjIAEKj81vxaM9qt2d0Jx/xRebwSmN+oTw2yxifI9QB0Ge+yJSD
         Rt4PuuqU6qiuzByMKBATtNr6kMGmigZk2zlJI8HgDe4Fw0mhnKga15NlXBEAgBLkGaNh
         3vYw==
X-Forwarded-Encrypted: i=1; AFNElJ8J3N3A/c7kSCZCK2cT770e6r59hbBuBWQEXB+o9H6xEWAz40acPAq+p/I4FpdWMJAXT/vBZf1JUdn8@vger.kernel.org
X-Gm-Message-State: AOJu0YwvSC2ADa+pJsyInd3iCzZMAsbD4PaxgFNgpXdcKsCdoMkHJcli
	5z/oXZM8Dp8qCuLaC5oVQYRltcMj5rKTaXcLTepdSxCZHvqn49roOtUQ
X-Gm-Gg: Acq92OHPR3RNydM1royBt+B0SsPWv1TDdBcov6lOc1aTwskKfqn3NP00UeMDkZNgMj7
	n8L1h3JuT4t9GrQbKP06lKuDGNP/FpVzZ68VoxF7WmuqnNaEq9lTIEpnL0JBiobQEPkw1/N7LIN
	MfUTJJIHDKPt8cynrG0/+ahZ+FIJDrNOhxymoWc5AGFo9A3MRLWJTbHYwYcwqemSsDs7WX6wzhm
	/v+neObKieqHnizHLimetKOSpB6UHaxc5t3JI/J3hsgRxx4ki29/xcWaXua93nn5ijva9rxIaTE
	qokBGX0bOZw1Pu/1t3P4aeheUgY2iofVLXTbYu7TL/TrQAn0iSgR/0bk+bhAt7fPHXZLUtfFAlc
	PSHEfs1kjMCsb4zy/SSfVQIhvZmzln86FtbnjEpWF8G58mpUREZ9jQDpDMCYi6uP4kyC1TmbN2x
	+XCrySuAQnyb6L/P6+S/2WgzvrjcZns8WXnQVgLLpvD/ac3aHqxMDahZ1zupL1Pnvx1faV
X-Received: by 2002:a05:6512:1344:b0:5aa:62cf:751d with SMTP id 2adb3069b0e04-5aa87bef9admr1395413e87.30.1780679698201;
        Fri, 05 Jun 2026 10:14:58 -0700 (PDT)
Received: from c0624c666cc5.devsec.astralinux.ru ([93.188.205.42])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b991b4bsm1991133e87.73.2026.06.05.10.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 10:14:57 -0700 (PDT)
From: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vladislav Nikolaev <vlad102nikolaev@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Doug Ledford <dledford@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Haggai Eran <haggaie@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Amir Vadai <amirv@mellanox.com>,
	Moni Shoua <monis@mellanox.com>,
	Yonatan Cohen <yonatanc@mellanox.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhu Yanjun <yanjunz@nvidia.com>,
	lvc-project@linuxtesting.org,
	syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH v3 5.10/5.15 1/2] RDMA/rxe: Fix the error "trying to register non-static key in rxe_cleanup_task"
Date: Fri,  5 Jun 2026 20:14:42 +0300
Message-ID: <20260605171449.1760-2-vlad102nikolaev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260605171449.1760-1-vlad102nikolaev@gmail.com>
References: <20260605171449.1760-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhu Yanjun <yanjun.zhu@linux.dev>

commit b2b1ddc457458fecd1c6f385baa9fbda5f0c63ad upstream.

In the function rxe_create_qp(), rxe_qp_from_init() is called to
initialize qp, internally things like rxe_init_task are not setup until
rxe_qp_init_req().

If an error occurred before this point then the unwind will call
rxe_cleanup() and eventually to rxe_qp_do_cleanup()/rxe_cleanup_task()
which will oops when trying to access the uninitialized spinlock.

If rxe_init_task is not executed, rxe_cleanup_task will not be called.

Reported-by: syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=fd85757b74b3eb59f904138486f755f71e090df8
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Fixes: 2d4b21e0a291 ("IB/rxe: Prevent from completer to operate on non valid QP")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20230413101115.1366068-1-yanjun.zhu@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ Vladislav: add the missing resp.task.func check and keep the cleanup
order used by upstream after 960ebe97e523 ("RDMA/rxe: Remove
__rxe_do_task()"). Moving rxe_cleanup_task(&qp->resp.task) after the RC
timer cleanup is independent from that commit: timer deletion does not
depend on the responder task cleanup, and placing all task cleanup after
the timers matches the final upstream ordering while keeping this fix
minimal for 5.10/5.15. ]
Signed-off-by: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 4c938d841f76..0532c446760d 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -760,15 +760,20 @@ void rxe_qp_destroy(struct rxe_qp *qp)
 {
 	qp->valid = 0;
 	qp->qp_timeout_jiffies = 0;
-	rxe_cleanup_task(&qp->resp.task);
 
 	if (qp_type(qp) == IB_QPT_RC) {
 		del_timer_sync(&qp->retrans_timer);
 		del_timer_sync(&qp->rnr_nak_timer);
 	}
 
-	rxe_cleanup_task(&qp->req.task);
-	rxe_cleanup_task(&qp->comp.task);
+	if (qp->resp.task.func)
+		rxe_cleanup_task(&qp->resp.task);
+
+	if (qp->req.task.func)
+		rxe_cleanup_task(&qp->req.task);
+
+	if (qp->comp.task.func)
+		rxe_cleanup_task(&qp->comp.task);
 
 	/* flush out any receive wr's or pending requests */
 	if (qp->req.task.func)
-- 
2.39.5

