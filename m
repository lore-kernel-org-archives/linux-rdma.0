Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725633;
	b=Yoz1ENMGgaFWEwBsytAyHxFGnVtPnqilHTOEZuR8kXqA/by0KcNPDwEyDCJILvT+Kb0P
	 GLR9NXmE9nmwqYS6DMheJrHys2oLQnnBVUuz3gX9Zi4lPMiAWS9ObmgZCgFsop5PtQ2BB
	 3BYsON/3Xv43srOV5kDvKVBQC3+GS8CLVGBk4JV7ep5UrcWK/JeXLLjc0bCUf4sPhb6OV
	 RyuJO49IN1NFjrWwlx79c0ubIeCLNKc9KGo0YYiwQbsN7Rb+E/MEYQ5vqZiAarqwPutIj
	 nfzWQHWTzx3NSZhgawdKC2uW2Hu8I0meQpVifX8i1RqfzdOqe3OdvqPzrCUeGZ8yDmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725633;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=U+uq6o7h5QCzlT0B6D4QGcxxj9excjN11FXi6rk4g1s=;
	b=Ezt0CPGY3pGO2zXdHXajs1eGRnqSWSIMKwhpa1knN9IdP1fMynzTDsb02pCVW/ZjZiky
	 7nfn1puYG3Vt8s0Y3FtGHva+IYaw9TxqdNxKJcDJw7CS0YoQoVC4EunPbHKzf4RBZ+XtZ
	 XDlO28/F0vjnwcQX5YirClylDHNGZmC1ja4xEVOdcqIXjRcjswA2YsuuzVJOEBCXj76VC
	 yvtQrTdVbGIUGsDSd/F9z0kfR5hva2UzLmv2RjLl51AOChS6FT8LwY7oTLIxnG5QbznSD
	 SuXPOmBsDXNe/fxUsgxSo85wdcpgC+IaZybt/nK2qgMlc+PNH4wVx6LJugHkS8WEHKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iGWyDvgf;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA92606A32C
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 17:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AA92606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iGWyDvgf
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1430eec0070so141233c88.3
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 09:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793725632; x=1794330432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U+uq6o7h5QCzlT0B6D4QGcxxj9excjN11FXi6rk4g1s=;
        b=iGWyDvgfWA7BABkCv2yaRDP+Ci1wwzDKEsG2/WxT2q3MSsLyE3lSmy32j0dnvGTIiE
         G5iBtFTfje+3OwTTkO8OdTrFB7+DyS1zn8lDkvVtr8uh/gazstnu4y5yedxcqwvXkL9k
         45WcsTyH83pI4bphWwo5FHm2HBZ9Go3Sv2CP2HuZv/qD+IgTIGutraHmvob4MydjsFyS
         NIpaywLWw9Ckc+LoCPi3nBL5l3GOWA7ut4LBQd/QIIKPun0kpsJo5KptsWZVy2n4YY8V
         cvRQrKTVD8AhAQKbUEUCQXvbcReKRMhijrvPG849xYBKMVlS10FaUjb2kN+6+cFJy4my
         0R2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793725632; x=1794330432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+uq6o7h5QCzlT0B6D4QGcxxj9excjN11FXi6rk4g1s=;
        b=MrQewplrTAAa8lPsWpepk0Jn/AruDMZUb94lcC7knogOzqyBba7QPJ72KYpIyuQMtY
         vockGfW1j2HB6UKRmmJ1jfKfhXpcIT5USdhEl2CE0I8tKDvP/8S4/qPsk7v+6Cy9VjSJ
         C+mlwws+VWfP3nyNP2Lk8w413Fo6QjAEUmCG0uqJBo87uKvL0fIjlD1wsbaO8FrekBJd
         mUuZYP4fQK6l17cOFliDiCLmXtJTM4qWJ75D6d34ada5eSUFBdEDW6m6HEu94MRHyO8d
         nLAJykbjny87V3iVVDCxByliiAzGlxElpQtAVg+wG9JpaaaZQe9lROCRh/LvtDws/jpA
         c0cA==
X-Gm-Message-State: APuU4Z8vgxc+LEDBocPivggrYOfUO3gzZnvRGoGMKMOLLHOfYGVPcrjJ
	boOL9ctfSq516fGuSEJJ2AtAAQEm02wRSt/5vcNGy0PjZbxpH5Seqwxx
X-Gm-Gg: AYBFou3ti6VV/hwhB8ZVuKfvhbKannQ5J1J2PfQzSgvQ40x7onQpjmtEeU7HiBS0UoG
	eG68++x1EGbVyVwNOokdQ8wVKGSK9CDNzK8lH7ab/i3j3cvncvqvQQKF4e+LKpE2V5TAlgfzwn4
	LDmW/1w2VC/mBIlvidyF7PWC0fBWVJEYMfbScLWXnCr4Ebyg3rXVvygCX23K19nrG7xtM7q+Rw9
	sGtK6p/cATHvVeUx5xNpYZlJ2H/1PJnfr2chvIFKPEle6ZMzuZIZb1jC3wwxZnGrKnv0lTjRcNA
	jymqJXeSPg5keVzZVq+yaeAIqV4Q6/PU9nTdXVlIDP7f8Xh/Hh8RV6r5GX1x9dYwP7G7WdzbXn5
	h1ErbWw3Mn5qJz0nK662eK4vrI8j6Hp2EGXuDvx0gRIqBsTbq1n3qYqSugjVAv+MaeMBSv15gSh
	1iQS3nGVKDkOCHWvaejNoO5GmTOZIfKhjmHIPBqHJ0atCRb8HTXg92O/g7nebl99Sso285klOOs
	52mYVU/qEQ2/RGePULi9OmqUyuubF6h7OCQD69QlyUqvNErx4tjF2nUHPCv8a4Owh0zt5r/0/up
	MVrnFUeOPnY0HBVeYgkpApNaAiiXV1Kvd748Gb60OA==
X-Received: by 2002:a05:701b:2515:b0:17f:641e:7f6b with SMTP id a92af1059eb24-1ac5904ae73mr28989298c88.1.1793725632414;
        Tue, 03 Nov 2026 09:07:12 -0800 (PST)
Received: from CRASHEDROM.localdomain ([142.249.36.161])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b87c4asm305684c88.3.2026.11.03.09.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 09:07:12 -0800 (PST)
From: Chengyu Liu <lui2012qwq@gmail.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	Chengyu Liu <lui2012qwq@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/ipoib: cancel the AH reaper work synchronously
Date: Wed,  4 Nov 2026 01:07:03 +0800
Message-Id: <20261103170703.1600310-1-lui2012qwq@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ipoib_stop_ah_reaper() uses cancel_delayed_work(), which cannot stop a
callback that is already running.  ipoib_reap_ah() re-arms itself after
an unlocked test_bit(IPOIB_STOP_REAPER) check, so a callback that has
passed the check but has not re-armed yet still queues the delayed work
after the "stop":

  CPU0 (reaper)                     CPU1 (stop/teardown)
  test_bit(STOP_REAPER) == 0
                                    set_bit(STOP_REAPER)
                                    cancel_delayed_work()  (no-op)
                                    ... destroy_workqueue(priv->wq)
  queue_delayed_work(priv->wq, ...)  <- delayed work sits on the timer

destroy_workqueue() cannot see a delayed work that is pending on the
timer wheel, so the re-armed work fires after the workqueue is
destroyed and priv is freed: both the queueing onto the dead queue and
the callback's container_of() on freed memory are use-after-free.

Use cancel_delayed_work_sync(), which waits for a running callback and
prevents its re-arm from taking effect.

The comment above claims ipoib_reap_dead_ahs() "ensures the work is
really stopped", but it never touches the work item - it only walks the
dead_ahs list under priv->lock.  The stop guarantee comes from the
cancel; fix the comment along with it.

Found by static analysis.  The race was reproduced on a KASAN build
with a small module exercising this exact guard/cancel/free pattern
(no Infiniband hardware available); PoC and splat are below.

Cc: stable@vger.kernel.org
Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>
---

Reproducer notes (PoC source below; a module parameter selects the
shape): mode=3 (cancel_delayed_work + lockless guard race, this bug's shape) produces

    [    2.05] BUG: KASAN: slab-use-after-free in queue_delayed_work_on+0x27/0x70
    [    2.05] Workqueue: events pm_td_cb [pm_flush_poc]

after the teardown frees the container; mode=1
(cancel_delayed_work_sync, i.e. this fix) stays clean.

---------------------------- reproducer: pm_flush_poc.c ----------------------------
// SPDX-License-Identifier: GPL-2.0
/*
 * pm_teardown_poc - mechanism PoC for the drv-teardown-sync C/D variants
 * (F-026 ipoib / F-028 epf-ntb / F-029 habanalabs).
 *
 * Modes (module parameter):
 *   0  F-029 vuln shape:  flush_delayed_work + lockless guard
 *   1  control:           cancel_delayed_work_sync (>=6.9 swallows re-arm)
 *   2  F-028 vuln shape:  cancel_delayed_work (non-sync) + unconditional re-arm
 *   3  F-026 vuln shape:  cancel_delayed_work (non-sync) + guard check/queue
 *                         race window (test passes, teardown slips in before
 *                         the queue_delayed_work)
 *
 * Every vuln mode must produce KASAN slab-use-after-free when the orphaned
 * work fires after kfree; the control mode must stay clean.
 */
#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/slab.h>
#include <linux/delay.h>

static int mode;
module_param(mode, int, 0444);
MODULE_PARM_DESC(mode, "0=flush(F-029) 1=cancel_sync(ctrl) 2=cancel_nosync(F-028) 3=cancel_nosync+guard-race(F-026)");

struct pm_td_ctx {
	bool			fini_pending;
	struct delayed_work	work;
};

static struct pm_td_ctx *ctx;

static void pm_td_cb(struct work_struct *w)
{
	struct pm_td_ctx *c = container_of(to_delayed_work(w),
					   struct pm_td_ctx, work);

	pr_info("PM-POC: cb running, fini_pending=%d\n", c->fini_pending);

	switch (mode) {
	case 0:		/* F-029: lockless guard then long body then re-arm */
		if (c->fini_pending)
			return;
		msleep(300);
		schedule_delayed_work(&c->work, HZ / 10);
		pr_info("PM-POC: re-armed (flush shape)\n");
		break;
	case 2:		/* F-028: unconditional re-arm, cancel must catch running cb */
		msleep(300);	/* long body so cancel lands mid-run */
		schedule_delayed_work(&c->work, HZ / 10);
		pr_info("PM-POC: re-armed (no guard)\n");
		break;
	case 3:		/* F-026: guard check passes, THEN teardown slips in */
		if (c->fini_pending)
			return;
		/* widen the check->queue race window like ipoib's 724->725 */
		msleep(300);
		schedule_delayed_work(&c->work, HZ / 10);
		pr_info("PM-POC: re-armed past guard (test-queue race)\n");
		break;
	default:
		break;
	}
}

static int __init pm_poc_init(void)
{
	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
	if (!ctx)
		return -ENOMEM;
	ctx->fini_pending = false;
	INIT_DELAYED_WORK(&ctx->work, pm_td_cb);

	pr_info("PM-POC: arming, mode=%d\n", mode);
	schedule_delayed_work(&ctx->work, 0);

	msleep(50);	/* callback is mid-run now */

	/* teardown sequence for the selected variant */
	ctx->fini_pending = true;
	switch (mode) {
	case 1:
		cancel_delayed_work_sync(&ctx->work);
		break;
	case 0:
		flush_delayed_work(&ctx->work);
		break;
	default:
		cancel_delayed_work(&ctx->work);	/* non-sync: C variants */
		break;
	}

	pr_info("PM-POC: teardown done, freeing ctx\n");
	kfree(ctx);

	msleep(600);
	pr_info("PM-POC: SURVIVED (no KASAN splat)\n");
	return 0;
}

static void __exit pm_poc_exit(void) { }

module_init(pm_poc_init);
module_exit(pm_poc_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("drv-teardown-sync C/D variant mechanism PoC (F-026/028/029)");

 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 81bbb3f7c1..5ed4f709cb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -736,11 +736,11 @@ static void ipoib_start_ah_reaper(struct ipoib_dev_priv *priv)
 static void ipoib_stop_ah_reaper(struct ipoib_dev_priv *priv)
 {
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
-	cancel_delayed_work(&priv->ah_reap_task);
+	cancel_delayed_work_sync(&priv->ah_reap_task);
 	/*
 	 * After ipoib_stop_ah_reaper() we always go through
-	 * ipoib_reap_dead_ahs() which ensures the work is really stopped and
-	 * does a final flush out of the dead_ah's list
+	 * ipoib_reap_dead_ahs() which does a final flush out of the
+	 * dead_ah's list
 	 */
 }
 
-- 
2.25.1

