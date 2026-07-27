Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAB03CB572
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 08:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785139732; cv=none; b=jbhrSAHbwAPqebamdJ1+lq0wNiK5afQbio+MD3LnasrJcdReVwKCD/Zok/0PC0VXWImwfU2ZvJTzFN8KNFXSbMZNgBswspj8n7XGwb2qsXgE/GpFeSVr1YCBnS7dcx4wK8giG3GfPeXnkDiVnngQYVkTUaETE/+YGbO5rjJTv0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785139732; c=relaxed/simple;
	bh=7IqMYuGLNcc8jNSZv4ilnT6iMTY6vyzoaMhT2i1dSv0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oYaad/ZKg1/jsrtq9j8sOeW/EyV+I/4YYOS1Fy1IZNThg5lxrRP+H4yJJBovtRox2rSCvp0iVbYkXL1qgIHlKWHwJSjSXoMu+t2RIxqr0gcKgXzUxuaup3zZM1aOKOt0cj6dWywi7mqJmMsc8k7WfsF35x6StKW9uvJOtEg5jQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=SS7BMseP; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="SS7BMseP"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1740c36c5cso322925766b.2
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 01:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1785139729; x=1785744529; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TRzKQhkQG9d5Ld52L/+LqQChotB4vodPn+v0XyewMGo=;
        b=SS7BMsePnX2m9bYuPV9pP8TfrZ8wlXCC8vwzo3dWm2Wsur38hpgLb0KVWt6M6m40YZ
         QxhB/Ht7oe4/ZMPIsQmTy7+DGBiafjVaWcENn4wqOd2kON9Wkf5XpTLmKS/cuWlXu4yu
         Dl6DWtBoQTLMKIIP4DDpUyOGOErLOMzFrsfQp5bekKwQewAQZPix+82NZsWNm+Br5tB1
         zf7ugQrLZbtmBXChSS6t6GW9MkpuH0knfKl4UWT5JDPpDho4DmKvRKtAI12qtOVO1r1R
         8qUsXQXTMQfqTCc/0jxUNhiD9Hi8L4Ml6qakVxdDj+lMNKlao6xK3UfqNMAcXZg74W54
         gT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785139729; x=1785744529;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TRzKQhkQG9d5Ld52L/+LqQChotB4vodPn+v0XyewMGo=;
        b=DKFmsd8Kz1ScW0ZZ1p/GcV3VLs9zBBGC+zZdWb8iqwKHTdohNtmW0IaIgx/GQQiaCh
         oYlcwWHbwbA+DlJViWqNW6kUXZTIBmBK5YBs6DgNsQ/iHC3og0jGDHoQbzyt6V92c4z1
         vr0NrWo/xTFx4bp11XITUcS6E5XnBSBIWUKFcFlvtsr7n2TGrkfd7fxh4aYkXYl5sN7L
         b0KMSd4taR7ezAeoA39rsAF5vOM5HgKGGjhYj13xGlnMXBDYDzQncgo0nmcOyQLnZyMn
         xIUmOYGGDdztsuGvYWgKvNS1tlbNOWlD2hk9dDBZGa0ozdJUF1+5Au5Azb20HmUnSP0g
         HB1w==
X-Gm-Message-State: AOJu0YxuLzz+0G1e9y4fzZu5vO6jQhWM2qZgfEJt27Vc/Jh0nwcVkcnd
	BLuKjzf8iGf6B1DF65q/gMKJ06TQNLdChxHR9xB6/ovksGBRbIDuApXQRxBPGD3SBcJ6ikIHpZs
	vf3kiMZf9KA==
X-Gm-Gg: AR+sD116uoZr4w1XDkzJx4Waf/xWoqKNvCq30hTsy0WIsHkh3jXhnQVo+u3HYbzmWs8
	Ii3LO3f7HBROox0YSSwcX8j+Vf802dUsnkmoRnblKyGIO9yAD/1M9mOSBPZ2huSgPZ8SiO87ODA
	6a9pT5sBANoCdPaJXR8BrBWNg+KXp9jY3PwAvfUyK231UnQxSTPXuCyXooEmlnTjv7C1b6p0Kbv
	PHra/AXr3Ei5c9kYXl6107E0f0EibhdwS4kiCfcti8mfkKSXvx+12f6Uk7RwRBpEzZXGmV1JFDY
	OloxWmr0bemiIMkczOfXzsqX6PKtHWxzhrdcIF/NssreCF6+plpAuBor5geCwfyGphPzZn93z4/
	mxhnbe26CSaX1eLBCIWWyXpf7W6Ndzyl4M93Ikdn4v3oXOpV4tzDT3UgMIXMxXkho+W/QSYogk6
	bBdpOs+lSO0xT2eQyiEqs13hIdEPrAUA0mQ+ESez93/wsQEvNH5QSghoCiiTja0fvjtvtDbHXNl
	B2FM5qZJPAZS7O+1bPkmdX5jBxbOGnuI8did+qTjGiB+Q4=
X-Received: by 2002:a17:907:fd18:b0:bff:738c:7a64 with SMTP id a640c23a62f3a-c1f1f076055mr243056966b.49.1785139728791;
        Mon, 27 Jul 2026 01:08:48 -0700 (PDT)
Received: from smtpclient.apple (83.10.16.193.ipv4.supernova.orange.pl. [83.10.16.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ebb98dsm590589666b.48.2026.07.27.01.08.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2026 01:08:48 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: [PATCH rdma-rc 2/2] RDMA/ucma: Lock the handler in ucma_set_ib_path()
From: Norbert Szetei <norbert@doyensec.com>
In-Reply-To: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
Date: Mon, 27 Jul 2026 10:08:36 +0200
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2823D190-92D5-4714-8769-4FB643C64FF3@doyensec.com>
References: <60544A67-EFD6-4D5D-974C-D983445F1070@doyensec.com>
To: linux-rdma@vger.kernel.org
X-Mailer: Apple Mail (2.3826.700.81.1.4)

ucma_set_ib_path() calls ucma_event_handler() straight from the write()
path, without the handler lock that keeps ctx->file stable while a =
uevent
is queued.  The handler re-reads ctx->file for every dereference:

	mutex_lock(&ctx->file->mut);			/* file A */
	list_add_tail(&uevent->list, &ctx->file->event_list);	/* file =
B */
	mutex_unlock(&ctx->file->mut);			/* file B */
	wake_up_interruptible(&ctx->file->poll_wait);	/* file B */

A concurrent ucma_migrate_id() reassigns ctx->file while the SET_OPTION
caller sleeps in mutex_lock(), so the list_add_tail() lands on file B's
event_list while only file A's mutex is held, racing every other user of
that list:

  BUG: KASAN: slab-use-after-free in =
__list_add_valid_or_report+0x1aa/0x1c0
  Read of size 8 at addr ffff888153c6a418 by task poc_corr/486
  Call Trace:
   __list_add_valid_or_report+0x1aa/0x1c0
   ucma_event_handler+0x1be/0xc00
   ucma_set_ib_path+0x45e/0x710
   ucma_set_option+0x32e/0x590
   ucma_write+0x1f9/0x330
  Allocated by task 505:
   ucma_write_cm_event+0x1a1/0x660
  Freed by task 505:
   kfree+0x1da/0x4c0
   ucma_get_event+0x5d5/0x7e0

The freed object is a ucma_event that another thread dequeued from file =
B's
list under file B's mutex.  File A's mut is left held on top of that,
wedging its next writer in uninterruptible sleep.

This path needs a bound and address-resolved cm_id, so it requires an =
RDMA
device to be present.

Take the handler lock around the call.

Fixes: f5449e74802c ("RDMA/ucma: Rework ucma_migrate_id() to avoid races =
with destroy")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
 drivers/infiniband/core/ucma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c =
b/drivers/infiniband/core/ucma.c
index ba4dfa7f12de..2347c0c59b90 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1404,7 +1404,10 @@ static int ucma_set_ib_path(struct ucma_context =
*ctx,
=20
 	memset(&event, 0, sizeof event);
 	event.event =3D RDMA_CM_EVENT_ROUTE_RESOLVED;
-	return ucma_event_handler(ctx->cm_id, &event);
+	rdma_lock_handler(ctx->cm_id);
+	ret =3D ucma_event_handler(ctx->cm_id, &event);
+	rdma_unlock_handler(ctx->cm_id);
+	return ret;
 }
=20
 static int ucma_set_option_ib(struct ucma_context *ctx, int optname,
--=20
2.55.0=
