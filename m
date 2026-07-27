Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6B3DA7E3
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 08:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785139588; cv=none; b=H/fOe0p8Gl7HFJJyx2CygQX2ujPa9k6fJ1kuCqYfo1URnkR9ovhLE7jR6smdp0xZ6Dgr3FEdDkUIog58jcRDfsyAWBWPFw/IyX35dsp+y7iqQMI/BZLXQWWsizFxv1o1xbL3juvWCFkiFoAsffX/BvL1ls3O4qShvRpTHvL/O7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785139588; c=relaxed/simple;
	bh=0s48hfKcd98jMAYnDB+U6WRvvUTgwPw6ZiJrJ5Z6xzk=;
	h=From:Content-Type:Mime-Version:Date:Subject:Cc:To:Message-Id; b=MPy9NzBdlpCxyJ+EW34j11YbVR9blTpANZUp0Qk77DOIdBHJDroRLA2RBzfcP1j+egdqPGgYguOqfQIOWhMVoGFMhRzdo+HVKb+feeTZ3ZR3VD+hfk3P8eXmT86hh/X8VOEO7FtNOvYK3t5Qj+NtufYoUoYSvw8BP0Mg6jYVj6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=FMeQBOV+; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="FMeQBOV+"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15b33f7b23so365970866b.3
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 01:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1785139584; x=1785744384; darn=vger.kernel.org;
        h=message-id:to:cc:subject:date:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MJtb+Ipvp6kpiMlrk8c96Y6Ej4W50EHU5eVBSRO7Se4=;
        b=FMeQBOV+QX3peDQTi/trAOLEpsbD6PWiGdPd4HtFM/s2GUGnERvzK7HdgQr18UAFK6
         nMlHG4d8rNodeF+VLKot1fEdUnREvAra0YWy1/L8KpgRPGLutmMIjuAwMfMlCPN5WLtl
         pjAu8x03q/7IvNXEXWqWq6N80T8/XIveIJaWwfo5Hf+bMHKkAam0rIPx6iNM6IiNGKzc
         krsfNydx8mAzUKs8tinXjwoe64RZbaP86M2cPuDASPH7U9UlqrOyMxsMK728qogww2xV
         VvVyRiCDtGUrGT9tJSI2i0d+ZKGrn8ReL4yaW2/G446NumiEzvmCotoOWmnHVzGkV/eh
         8SLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785139584; x=1785744384;
        h=message-id:to:cc:subject:date:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MJtb+Ipvp6kpiMlrk8c96Y6Ej4W50EHU5eVBSRO7Se4=;
        b=f3RmIRnku/y8QY0FKCkuKyaWnWHMgcLTqDwhAOWVrC+zN/Qcre6fFSNd8if1qMICRo
         xxdPr8V+Q7SZCViiXdLOF0oJBp8fbLzCK2nmIvH3Lrm96A/67E697hjhyTMkqTGuyUvB
         yiHlT5ZeWAYYud1Jj1mMicOhPwZ7D7I+nnoZfBTj5VYPFx483xButlqd/IZZ7xlc3jUy
         No0Y45BcmjAs5EyvSuX17u8CX1QLNE9SdxIGX+l88WEL7/Nbg5zL4jPOrh6LD/SC788l
         HtW7OntuUYFsOKsp6/y/sKxnKWvXfxxwUrz4fmsaYEEkzahSVgUBFChtitjbDHc2hZCY
         YAug==
X-Gm-Message-State: AOJu0YzI3qEv2OQvaU3EjGt2XvXARwtbj3CiuL5feExUUosr2RASi1mI
	TIbnzU0tlgbJa9R5pZ/c880HeWYe06J/SiIRKJhI+hFQz71/kn2kyD4jVcLKhFyfevMAlAGv+xe
	GPQwhMXaTzQ==
X-Gm-Gg: AR+sD12hloKSAFtr8Llg6EMgSh9z5MFJa8K4sFTrXGqpuqR1BqLfw3QeFC2o8EI6Nc3
	FIq/38MoKJQWVPV7uSm/QsH66dIC9NfXd5ceFNZzxVlVufegDsV0G+QQHRky9Ni/NHZaDv27HUK
	02jnvKGJXkB66gGnivbKnQouJZoXnU7/TJDLFD1jZLKvIuJsoKy0qG4Dxg/dGHpaKXVkOjYCmuM
	V/vKl0jzA0iaC4W4Qepe/ThNca5m7fGB3vMbTae7kkco+ImzWiQaYq1P3AOVdijrGh2IPaHFmp2
	xZAo95Hd8OHPijicWxuQDJDPYeoABNIihUFcK9m9/tqePt+nR6budjKl1615RHpSmP1aNfxhTV3
	kyWAqjHhqHrokCXoi8Eqh/AIFPW1Fxq3weCcOT2StZUj8PWl2BOW6DzyWDJ+Z7GoFZZxX1EX25E
	bzreiLbVl+MtcboaQGIFI2DF8p3mR715YaY1kAGuagpTEWf+f33wk89ozUkfAdtZK3+RiSG4yWa
	fwZQGHXxUZAeG+OFsAeuHOiw8EsIRmJ2zv7dlRh35UP/S5sg/n2eA15hw==
X-Received: by 2002:a17:907:c081:b0:c12:8fe9:3a42 with SMTP id a640c23a62f3a-c1f1f09fc91mr274689066b.35.1785139584544;
        Mon, 27 Jul 2026 01:06:24 -0700 (PDT)
Received: from smtpclient.apple (83.10.16.193.ipv4.supernova.orange.pl. [83.10.16.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ac8c4bsm607038466b.18.2026.07.27.01.06.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2026 01:06:23 -0700 (PDT)
From: Norbert Szetei <norbert@doyensec.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Date: Mon, 27 Jul 2026 10:06:12 +0200
Subject: [PATCH rdma-rc 1/2] RDMA/ucma: Lock the handler in
 ucma_write_cm_event()
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org
Message-Id: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
X-Mailer: Apple Mail (2.3826.700.81.1.4)

ctx->file may only be changed under the handler lock and the xa_lock, =
which
is what stops uevents being queued for a ctx while ucma_migrate_id() =
moves
it to another file.  The CM core takes that lock before invoking
ucma_event_handler(), but the write() paths that queue uevents =
themselves
do not.

ucma_write_cm_event() re-reads ctx->file for each of its four =
dereferences,
so ucma_migrate_id() can swap it mid-sequence:

	mutex_lock(&ctx->file->mut);			/* file A */
	list_add_tail(&uevent->list, &ctx->file->event_list);	/* file =
B */
	mutex_unlock(&ctx->file->mut);			/* file B */
	wake_up_interruptible(&ctx->file->poll_wait);	/* file B */

The window is the mutex_lock() itself: the writer sleeps in it while the
migration reassigns ctx->file.  The list_add_tail() then runs on file =
B's
event_list holding only file A's mutex:

  list_add corruption. prev->next should be next (ffff888101320f30),
    but was ffff88814a08c418. (prev=3Dffff88814a075c18).
  kernel BUG at lib/list_debug.c:32!
  Call Trace:
   ucma_write_cm_event+0x36e/0x5e0

and file A's mut is left held forever, wedging its next writer in D =
state.
The uevent is also stranded on a list ucma_cleanup_ctx_events() will not
walk, so it outlives its context.  /dev/infiniband/rdma_cm is 0666 and =
no
RDMA device is involved, so an unprivileged user reaches all of this.

Take the handler lock, as ucma_cleanup_mc_events() does; ctx->cm_id is
pinned by the ucma_get_ctx() reference.

Fixes: a3c9d0fcd371 ("RDMA/ucma: Support write an event into a CM")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
 drivers/infiniband/core/ucma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/ucma.c =
b/drivers/infiniband/core/ucma.c
index 878561fa1cb5..ba4dfa7f12de 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1784,10 +1784,12 @@ static ssize_t ucma_write_cm_event(struct =
ucma_file *file,
 	memcpy(uevent->resp.param.arg32, &event.param.arg,
 	       sizeof(event.param.arg));
=20
+	rdma_lock_handler(ctx->cm_id);
 	mutex_lock(&ctx->file->mut);
 	list_add_tail(&uevent->list, &ctx->file->event_list);
 	mutex_unlock(&ctx->file->mut);
 	wake_up_interruptible(&ctx->file->poll_wait);
+	rdma_unlock_handler(ctx->cm_id);
=20
 out:
 	ucma_put_ctx(ctx);
--=20
2.55.0=
