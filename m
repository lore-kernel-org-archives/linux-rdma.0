Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101212;
	b=3/RjaOFRjbReuOxo3o5po1dwjFPVkbRaz0vTc5oSzU04o6OaJQnPztN/geA6qWk2eQ7i
	 gFuPk+rwcdqF1zt3TP4YVZtFIOXP9iEtl7aWOD5YZZ9A8j70kk3f5S8qzxpGW21jWpVXH
	 E/HZKAP4Wur+8fqSxKvg5cjayVdZg0BMAMHaBfCJPJrildS07TniIuiHSKi3aZKaDlTG2
	 bC8EjthpCH4OUkSXrcQQfmguGfBd4lW26IUBjJNEdOQXZChiKrpHXykiuDEKBgiv2Vj56
	 MGaoOhbzNmInuUtaikYBGuuHH+aibO/zuChMK+hDJ5KON/OhZNkeIbN1DodQLKWopyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NPAAhd5Z1XLOgPjtVPbAXMB35nuWOck8Yvyy1q9vcpA=;
	b=b/LXJIBZVLd+Bxd0KbH75qUzxmeBKrxi1oH/7y6ziGSodGeJpgHF2nR7AGaWwDoIz2NQ
	 KM9aCm8+JFJBIKZ5SiEtRcLPB16/g1/ylgTJ9QT6iwcrIYD4PN22wFRUTk053zlPkHYaC
	 0s34tmSTIbO52Fu8eWtnw1Y+z0YmURPh1d3V1iy6yidyPAu/nsqLqx6wvhcgWkSlIvKGJ
	 4T5dxX6IUksvnwlcI2aYGmM95fJu1YcZAeVij92ZVrGsbZDa0k0HsnDFF1a/QL97bY0r1
	 OkJlU+swFFMy0PV4KCqY23OR/6kLz8AA6tqDc+0imT8JiKGoBTfqRbx8C5G7UJ+14Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m9y72N7r;
	arc=none smtp.remote-ip=209.85.222.172
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41333606A324
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 15:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41333606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m9y72N7r
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-94962d80d34so167899585a.2
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 07:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795101210; x=1795706010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NPAAhd5Z1XLOgPjtVPbAXMB35nuWOck8Yvyy1q9vcpA=;
        b=m9y72N7rhWtG1yZ4EgJX21sPwOO0BQqE4pxTYM9+4N1xL9xtR2tfZKBZk2/r7nZNq0
         OFW7cP7YHA/Ua2LqTnDgIJ/D92G4lTcKhcjhmj/IwIKqmlvoUDuDR30Jjji2S59ODcr6
         pSSQ/crm4xbFXXTZxL+/GkyIYoKrRVgXcgoEojNupBE9mfFMVTc0RD/zZG59w53mR0JR
         idnzyeLuj4sxOZmBo18QOi9pv5Hjk1dakyDOhKobbc3jYkEqgs4K1BBlhcjxaBgmzs8n
         R9aIj8jZtmzlP8VQHFDqmC6ZfNH+ChxbUu9ejurJKgjmwrofnxAtlDm4Yf9CP3tr6o84
         5PfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795101210; x=1795706010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NPAAhd5Z1XLOgPjtVPbAXMB35nuWOck8Yvyy1q9vcpA=;
        b=NJ0iZlrwASqESCCndrBYljKE6TAgEmwjDVZ0rAbIOkC+Q1wddYAbURKgFuqnU2hueX
         3kgaJP9baByEIGwuliBhEpfszxJmZ52liRGEl37SRBzJMn2VEPD7+JfiS2dGHOVCTk8E
         IQhI+z5XjZ5fx0Ky2+h1fMqYJKI98wmaPYhIuinECNGURvF4y4ZZ7k9SAcAlPqPYQClP
         XNQ+FnttjHiayMpHtKzUCybBkSrU5qniILWA3qOy8Bw3dXiIeQnjjvQQFKed1zjLQubt
         13hLjWScCUS4rbpl2DJj9jIgzl4Oh6Jgp7hpTUhC94uWpKFkCL/dFXTd9/psXHd6Ck9D
         RF7g==
X-Forwarded-Encrypted: i=1; AL+hErEoV8WuO824LtG7yISYZREzzoMpB4rQ+dAGGO6RE96Gh0e6pdo1qcYUzS5H1TjuvpftEjcn0wLNC9ap@vger.kernel.org
X-Gm-Message-State: APuU4Z/E25SyjZglgBg9zfbyP/DcKFKcGimr0sLeOgOc9TCoBKUUS+9f
	3iZHX1HVqgI26Vw+Mc9sJ9N1kVT9pq6zt1Tgr+kN24kqwgN0y36NM7QY
X-Gm-Gg: AYBFou0WKk/g4lf83QMJgkwsUIZoz3nRThkcK5zHLwqOBwOLQAC2iJ2+G5V5x1/5SD8
	Oc0feiN6/m1ey6CN+TN+VUHccIGbO/eOUR++ewFB69/sJJB4dIFXlpz2hm3GViEtwPgLfh98JOE
	zJPN6cLY/Pu8pCHzcC8q+PxdceDxfThBcdfvLSSS83lp891Ln1kh7Ms9XEixKRENdZ/8QHDcAFe
	fPyCIOtx9hHuPlI+NX7QQLmLa9NJppFCIYddfMaHckA1ExFhyYzAGWiCOM1C8M2U2Jmq6pNLhrt
	4ol5j/FBgD1w4DgnFxwNt0wfx3RwNsElPXXzd00W6hWen1qedeCv9SioruvvobESHn35psDkTQ8
	I64X/G0G4ydeB7J4RtqxlXgiRE8bZxyuWdulv44kXuvsBfTd1ySBwRg4/5v9DWWIbI4LEywQThV
	2ot1E/6jzQQcwMK0FXt+kdyEgpAixoNQ/PBNim0nU7py10nnbW/Ngvt96jQYui8tMewJKm2qVr4
	rqexWdhO7w2ZEBZGdnV5qEOX7dP1CY2FjZTK2dg3ekJICn9f7yFkoYeQFFTr74K9Brd4eHfLN4P
	SLvkXeCYMtWErKvA8AYqq4+uUosoegvjx1zwsh/FHZSz95oGBk65W6TLHGqT5rHXRRecz8Wa5gU
	Ib7cWfto+4LfeFR61iqwM0PwxYffHCS7GUiwrHbfvUF0qxtO95tTiAnlJ0oszUgKqDgAM78PcAK
	cZe5GpD/SNEp0Z+WKH2TRVidMal1A=
X-Received: by 2002:a05:620a:4890:b0:949:5c62:e78f with SMTP id af79cd13be357-9499959d372mr1158164485a.25.1795101209851;
        Thu, 19 Nov 2026 07:13:29 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c935:f347:a919:9f78])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949b9a44123sm13915285a.20.2026.11.19.07.13.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:13:29 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/rxe: Fix NULL dereference when invalidating an unbound MW
Date: Thu, 19 Nov 2026 10:13:27 -0500
Message-ID: <20261119151327.95446-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
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

A type 2 memory window has no QP or MR attached while it is in
RXE_MW_STATE_FREE, which is its state after it is allocated and again
after it is invalidated. rxe_check_invalidate_mw() rejects
RXE_MW_STATE_INVALID but not RXE_MW_STATE_FREE, so invalidating a FREE
window reaches rxe_do_invalidate_mw(), which dereferences the NULL
mw->qp and mw->mr.

An IB_WR_LOCAL_INV for the rkey of a type 2 MW that was never bound
panics the kernel. So does a second IB_WR_LOCAL_INV for the same rkey
after a bind and an invalidate, and a received SEND with Invalidate
naming a never-bound window's rkey.

The first case, run by an unprivileged user under KASAN:

  BUG: KASAN: null-ptr-deref in rxe_invalidate_mw+0x156/0x310
  Write of size 4 at addr 00000000000003b4 by task kworker/u8:1/30
  Workqueue: rxe_wq do_work
  Call Trace:
   rxe_invalidate_mw+0x156/0x310
   rxe_requester+0x20d4/0x5640
   rxe_sender+0xe/0x30
   do_work+0x144/0x470
  Kernel panic - not syncing: Fatal exception in interrupt

Only invalidate a window in RXE_MW_STATE_VALID. rxe_invalidate_mw()
now returns -EINVAL for a FREE window, as it does for a type 1 window.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with the same tool and reviewed
by me.

Fixes: 3902b429ca14 ("RDMA/rxe: Implement invalidate MW operations")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---

Tested in QEMU with KASAN on v7.4-rc3, and on v7.4-rc3 with the RDMA
code from rdma for-next (7404c82cbf12). The reproducers are short
libibverbs programs; I can send them off-list.

 drivers/infiniband/sw/rxe/rxe_mw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index a2e3a6ce0946..82a20a96a351 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -228,7 +228,7 @@ int rxe_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 
 static int rxe_check_invalidate_mw(struct rxe_qp *qp, struct rxe_mw *mw)
 {
-	if (unlikely(mw->state == RXE_MW_STATE_INVALID))
+	if (unlikely(mw->state != RXE_MW_STATE_VALID))
 		return -EINVAL;
 
 	/* o10-37.2.26 */

base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
-- 
2.43.0

