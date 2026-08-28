Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D983D6CC9
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900271; cv=pass; b=RMKfuU4gF+Z0K3d9OX7J1ONP2AeNQ2QWFUxMGwjc5qfNrQfDopNMpU5CRED1Q4iyLbhOPdg/OE/U3VjCRRwkVq+xwtpEKsMmhl6xxOS770l1mZzJdfTuOWSwISL4/8o5umgMeN343Wzsv+ct5EYMv28SFRWeN/66QRBMuPeHjeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900271; c=relaxed/simple;
	bh=5pi7fFl5d9CkpMFuaL7iKJCS9k9esNIMTbygfQPyjT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VmeGkXKp7vMsmhUJsEhvA8XfPjOoFDwlCysDPoskD9ZiWmNHczLIRWdKYTHDCkHnxA8967zOa6PZBm36sG/7RE/5fDqnrlE0lG84DNNKzszcUl6nKAb9BsYtYvpWc1eQR5ZlORjU1troK3pSg1DC3fmW8p6WdAo9q1aH5RxPdB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=JvrsRWQb; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="JvrsRWQb"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c20e4487bdaso6690266b.2
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 23:57:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787900266; cv=none;
        d=google.com; s=arc-20260327;
        b=HdbYWQTGLt/h509zj3pb0rUmCtLDKpgCKFPZ5osikDTjmYjj8fgbvJ8JYyCu6LewOl
         AKb8GXa/JGGTO76bFj0EKGcuzoCpEIcNOMJxqGrZGtQadfhQnG7+7/VoIdrgorT9KEMO
         LYKtk7bVXd619mPdbnCnw4Np5eZvkgxbx5c0+FOCHGVpKAeT6vM1LXqzNM2yT5KOkylJ
         eyCx8CFwe2lF26xQHNlGWIZMErc15xcJb/LGz89YQ1dXClaMaNHIcZ/v0WzNUwqIxxtN
         WKEGj00KsTuoKiAYAt6RZfjkNKJ3Pm9s+tbLGVFXaDdPSUrfJrO4DEtPU4mxlQtpQHWs
         493w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=biVRj6RyrYDWGOfQG4W6ncxtDNbl4Dahs41I0q/fYzU=;
        fh=Od/FLBemErGXRB85ahShblv2hfyWR0E5sz8HDR+xy4Q=;
        b=mEo7oxLmMoxQZ6e2WeUCOhvH/rjoAv/VZ+JtqKshsSlpAxsT694+Qb0w1JYCEFkzcj
         xNJlLS5+GgdNytxZgxbCrSg5WqnSEGIwrKIaMdZ+mnHdaXzB5IZochAiayguEmqe0zkg
         TxQ6P15a2h/nZUdYlL6QIm4dz1OcMpI69+34d+NDiezNr0ymIwrMyoZvcj7T4QzVwINQ
         pGHLG08mFg9jF1ch5Qh7KPVRSyZtkV1KCMazNaltQOCok4Hpj5SHsNPZi/GwFghmGq68
         9TFmapNt/xcpSkdv0IePgioldlYe+OSvQB8XX5dSL41vYqJ3xuYWfC8ncFunAZkY+N20
         O63w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1787900266; x=1788505066; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=biVRj6RyrYDWGOfQG4W6ncxtDNbl4Dahs41I0q/fYzU=;
        b=JvrsRWQbckhvfwwHWZggkj1KRTBs6wVMsRVFKbgZV1rk3PBPsfgNQUjVgP6RqgaFwN
         i/WkIgSUsEnfmtzDBypb9axJz8U6VmEg9QFZToVC3qJMMqeF0yYSX/x7ijsOtUX3V3Sn
         5ctmLF0Zpe1PqRmQdfJf+XTTH6Adheo7okCKmeKVWXYi20r121Hodym+Uvgg/Q5X2emC
         8iScwlZQljymmX6KaUDUfnmmtgx9ao5HSkvb0lLhM3NiOuNzhsmLaeMit+kHa2wwY4ZW
         h+t5U6fqwmRy2V3qiyAxtEGVGghO4A4KhrFkCqdxAnuBvQJEyQ+ZpnLdT0JvgcW0iUAK
         32qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787900266; x=1788505066;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=biVRj6RyrYDWGOfQG4W6ncxtDNbl4Dahs41I0q/fYzU=;
        b=Yy5394r2SR1LrAhtTiCGHK6F5K+EMQkcpfVFKOpS7qP6TT+jxkq9fPxOeJWerG9G0e
         46QxDs91PH0Lal7foYQagejcxGsyvLLk0PIBNa1y0QKhozyPG8TMb9EzhUVcHyvtnkvK
         xivw6Bwv7XWix0gyY5S83gJr7p3lRpVq+L7piS9hdutVsRoSuG5kB47bu5qe65lWHRzU
         tT4zA8Jb6xz5wXRRdyKMAPXa6XMEjYCV5ZVkJfhcpiaS+XOs+Knhjgkew1/Lo1vshuOu
         j1XsmV84ET8LI4zlDynS0o1HVxN8d5B1cA6482ZnkeKQjAMw7V+oEaoYaWfqYQUExNBz
         ENdQ==
X-Forwarded-Encrypted: i=1; AHgh+RosJ957Ucs3u22BbxO+DdfO8Y9h3YbIcwo7RZB3AjLiwo7zvqkG7PuzvlDH/+n52Q2/mawuy7Wi+B9w@vger.kernel.org
X-Gm-Message-State: AFuF++lJN67ZQz1UFWqQF+hwiTu0htJ2/bYUICbqECjT4BIf2e+rMvrR
	NX+PXqVynlknB1Zsf1kotkh7163d9yCSWzGQIt2H/G9GTN6BmuC96QVPrHvZqwtZbM4FQpTilcY
	gsFk3gMolSL9l9CT9mRk1mDIIEypyxtJ2wQ+L65NoYibEjXS0lqeQ7ce5/w==
X-Gm-Gg: AR+sD10+t6rgJhsdBk9fZoJCeyhIbHE/7d7IyfItNQ/EpWkxswAUijE9xUEDh+mXkrR
	Y1MVJaevu2zJJ058T7HBk1p+2CLkDeveX8xqBUhIv/eSpODJz91lpEzG9Qx9gm77nX8Hcl0shqh
	aqD5AF3UNCGAKVp4aIEtssZx8NNl9cS+0ymaBrYcfioRgdE4yEZmCdOhmueZPVC5WEsIIru2Lsd
	9Oi++Rrbsz5qNYnjVNAgp2VglT5wKQZqMn6qRV9LFZD/Of+rr472nI6gD+JcrxKBJ5X56f/IKK1
	bYNWfvs8Q/VXA4ZoZUmg7972p5ycU+4fd0jARfX4+XsPdLm8V+Ndi+S3beDrU53Rhkw+CLvlO2K
	bfQ==
X-Received: by 2002:a17:906:6a0a:b0:c16:604a:b2bd with SMTP id
 a640c23a62f3a-c255741932cmr146374966b.3.1787900266006; Thu, 27 Aug 2026
 23:57:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com>
In-Reply-To: <CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Fri, 28 Aug 2026 08:57:34 +0200
X-Gm-Features: AcwNN1VrhfZp_YYYRkwlkfKyqT9N2jCjAFzaObmAGZGcec2LVIMYMxZlFYy8fIU
Message-ID: <CAMGffEkpFHusGEe5ukWiO0kFjAiVaCj1WgO_ES4D7QZ-TjEYTg@mail.gmail.com>
Subject: Re: [BUG] WARNING in ib_drain_rq
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, 
	"Md . Haris Iqbal" <haris.iqbal@ionos.com>, falemi@asu.edu, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 7:52=E2=80=AFAM Farhad Alemi <farhad.alemi@berkeley=
.edu> wrote:
>
> Hello,
>
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
>
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/198-warnin=
g-in-ib-drain-rq/
>
>   failed to drain recv queue: -12
>   WARNING: drivers/infiniband/core/verbs.c:2948 at __ib_drain_rq
> drivers/infiniband/core/verbs.c:2948 [inline], CPU#1: kworker/1:3/5056
>   WARNING: drivers/infiniband/core/verbs.c:2948 at
> ib_drain_rq+0x30c/0x590 drivers/infiniband/core/verbs.c:3078, CPU#1:
> kworker/1:3/5056
>   RIP: 0010:ib_drain_rq+0x30f/0x590 drivers/infiniband/core/verbs.c:3078
>   Call Trace:
>    ib_drain_rq+0x30f/0x590 drivers/infiniband/core/verbs.c:3078
>    ib_drain_qp+0x1bb/0x430 drivers/infiniband/core/verbs.c:3102
>    stop_cm drivers/infiniband/ulp/rtrs/rtrs-clt.c:1763 [inline]
>    rtrs_clt_stop_and_destroy_conns+0x216/0x1650
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:2210
>    rtrs_clt_err_recovery_work+0x67/0xc0
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:1524
>    process_scheduled_works+0x881/0x1170 kernel/workqueue.c:3397
>    worker_thread+0x988/0xde0 kernel/workqueue.c:3478
>    kthread+0x333/0x420 kernel/kthread.c:436
>   Kernel panic - not syncing: kernel: panic_on_warn set ...
>
> Our reproducer.c is available upon request.
Hi Farhad,

Thanks for the report. Please share the reproducer.c so we can take a
closer look.

Thanks,
>
> Happy to test a patch if that would help.
>
> Regards,
