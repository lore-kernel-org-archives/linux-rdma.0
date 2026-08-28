Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E843D6472
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 06:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900221; cv=pass; b=IKmq5VGUbUYbdgGEboeKrs6h3p5ughk7Kd0mG30R3wJxhrgyjHmVRY9rZ3VOAuYPjGy/dIG7RMvrepI9xh4bmgZV1MBUAfE+AT4mewS79AoLiEVLpxIhF5bl+fKtZ7gTyKpCuaRLy4K25x/Eq2ojFj8RMD4vSAg2nf40bQQZG5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900221; c=relaxed/simple;
	bh=pR8lzbcrGU+mduT81ko12cR/81LPWWYiWTahcEa6OJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWyGZ2+BKw9tD0C+aQUKNR/4LrE8oYBCtUkLRwjMln2jciA1erGOr5Lq4vld95l7/Dyj+osJioeFCk50JqVdRjixXnvaJq1GJ/ake38AS/ebiaS8wl92cHMY1479h2ue6Txl2e3vhPJ8vPB2xay+Rm/fVtLXswsQc7O9JWRbhbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=i6bTVJ6w; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="i6bTVJ6w"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2533ebf0b5so7041866b.2
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 23:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787900217; cv=none;
        d=google.com; s=arc-20260327;
        b=OzHRJ3xtqiVH0g+5lsly8EbPlUCRs+FsSAvDV+bIEMCEGVSZnR0D6p2k3K3bfT6uep
         K+rOVUK8V734QopAdINyp8mx+Uiwxwjei3+0QEH7JGTGUkqWDH8O/DXjG2TSdlEibiHV
         dWhZ8JwWGxHtLyrm9UtA/7MGa07chBF8K4+4Y560hEeKSVoqQ1JoGh5tkk1ugGJrjQU3
         E5AsklaGtjc/4fJixQcFYlxuDhVAngVSQ2Sz8JOpO+O689WYsNixw72Mkn0BeZOGyQmY
         bbCojdHZssQi7WGeWbMwoM3+NMNJAk7MuPE0ixN1HjsZyQYJfmwJp1ofzK2Kry14V+yx
         61SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ClJcyzcXv03ttdoVDIVXl7vZcyMM3/8g1hhdRTAECV8=;
        fh=8SlHIhjejoReKvBChs6sNSRaBu8EkebTXrE0f9grlNY=;
        b=QoSruU4X0VlJLiFPGyCuikeG8zX1WlxGSRUiv2vqfyIX2uJQQdgEO4pib2iR/6Riqe
         9fHwjvUAREuoS5D5h3U5JyitxUVr31HY8MgsA/zWsTkCXNHLGwhl79oCuxWBGJjYiNDH
         snwO4Muftf+WFolc+M3ze1G+LGcqdZ0DnekvSUn0HkD8sLI8g9YfHyMnlM1q9JYkmjEp
         ht3BUloBNoGP6JaojGWRGM4VfRcPo4DrxBIHj8AQYmu1ypJydO4RbRdKIUfu41t78x+a
         v8L1mvhnYhwhcGK65kEPKs3usrjeuKpQAgkuMgTxRna6KQ0SjQlw56/jkl0/PSPrNu6D
         HPTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1787900217; x=1788505017; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ClJcyzcXv03ttdoVDIVXl7vZcyMM3/8g1hhdRTAECV8=;
        b=i6bTVJ6wAnY38qnwYo91JD1OK2ype9VuxTINuqhk/xX4p00fPj1Lsqijmxbm7VYm98
         c6EnIjpvKUvvpBK+YrSLlVmV9s3vYS54ar64MnNhessLhEnCzlj/AMp0KrwKYh6TjVtw
         m0U9XwCLlxu/Wm0tzn3ytl8UrZnSs8f+F9EIEleBmf+xucvVW3meJtfP+1WzlJbY3yrI
         VZESC6jIxjCo36QsCj5I2JhJxKZCZuvgYzRaNaunx66WYowOAzb8w1EBOIPE2typs9Bf
         EKgfYTvkd/TIsPmYCt9JebkiijXQsodPobWZ8JFq1RyzWHPtLosF+IKpYgz3nuVGR2al
         YvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787900217; x=1788505017;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ClJcyzcXv03ttdoVDIVXl7vZcyMM3/8g1hhdRTAECV8=;
        b=RyhCAdYvq/PrWvok/zvIfiWYkdHBS/mwVyBJ+I9C0T9sS4V8nK4knYEy2RZjR5Pmiy
         7/4Pgtjz6kSbCvyqJnQRIrlUMqMDUjEGoAyD0O5HEO9wipiyEC8Ms/fUOD/Z2VMHfGNo
         q9q0RnXzckSxz4bdsOuQ1RvMgbWEQIRM0DngCUNpvMt9M8roRUztOY17l0kFPvrGdDnL
         5vEIpFgM3gp8LWgRyoeoehsnoBlumQKk73Xb0Dmt62rVOqY+J3FqBmZr3Pc3RqzZ5hcW
         sTb8aduk7XS4mqLnV0Bpsiz2NHlELgNSjKmjkqvB072DGW8tLcLXbNYC9T8VprND9IMr
         jqbQ==
X-Forwarded-Encrypted: i=1; AHgh+RqcRYPq6voBh5KSiB6VlWrMVBqp2G9sD8L6CKhUwtCBQPVIPI7nsImzH4lcwr5So9Wc26EI4y8mCaKD@vger.kernel.org
X-Gm-Message-State: AFuF++lRjwUI+eFRiA1xw7mqIbzsRPLkiMq9b58qiPA1DuJCOooyZjbD
	g53XjhozLK2Ue7oVpJa9EWcZr7N+dHlSV/xDlm6ET50/Hvb9aWaUrpfBpv3yG3cFgldTvwr7Nx4
	jwYmkq9igINXJkJu/Zst44/JqANnY+pxuLamx70yY4w==
X-Gm-Gg: AR+sD13OHK4VwPOpiUGsJs4/SD0mQhR7izI45fBeqxXKiHSQ01V19iqGGm4FWPzW6tX
	iC+cc5tQwyKJL6tlVewedaRNHIJQi/U2KO0eAZXFSAjCIKyJ+87Kp3wTkMoIWpvuGSDfYWkM0lG
	C8mziV1iRzxvU7+FvPNT4f7kcStiGmRGGWH0q5bWUTCCCah2NsOD4f7N7HsRKZ3dxk3vBuRSv/e
	F3nAEuysKZIXCYrN80WjSZBLGmpUX2y1v26PA4MOfb0Xf815hO/vqrGoCDpMrn96T6t9TXSNCsT
	PILrtaNxj4o2rPxF2gVUB7QOnaK4bViqSzAe0rUKGyLTzYQtrc7rxV35b7eyc5zznIwlElBpPUI
	edA==
X-Received: by 2002:a17:907:1b0d:b0:c1f:4754:d87b with SMTP id
 a640c23a62f3a-c2556c18157mr145957266b.1.1787900217282; Thu, 27 Aug 2026
 23:56:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-WratpUE6jczHw@mail.gmail.com>
In-Reply-To: <CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-WratpUE6jczHw@mail.gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Fri, 28 Aug 2026 08:56:45 +0200
X-Gm-Features: AcwNN1WdLy54onDAnumUWqn32SBPHutYhZ4YRkU8KaULyqBmFlcvls2nylPuDos
Message-ID: <CAMGffEkQiuEC7vP9aWzdppJ+2O6pkCEdoqkJhzqVE3Mm-jp0hA@mail.gmail.com>
Subject: Re: [BUG] rtrs-clt: general protection fault in process_io_rsp() / rtrs_clt_rdma_done()
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, falemi@asu.edu, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 7:22=E2=80=AFAM Farhad Alemi <farhad.alemi@berkeley=
.edu> wrote:
>
> Hello,
>
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
>
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/135-rtrs-w=
arn-on-peer-supplied-completion/
>
>   Oops: general protection fault, probably for non-canonical address
> 0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
>   Workqueue: rxe_wq do_work
>   RIP: 0010:process_io_rsp drivers/infiniband/ulp/rtrs/rtrs-clt.c:502 [in=
line]
>   RIP: 0010:rtrs_clt_rdma_done+0x732/0x1450
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:637
>   RBX: 0000000000000058
>   Call Trace:
>    <IRQ>
>    rtrs_clt_rdma_done+0x732/0x1450 drivers/infiniband/ulp/rtrs/rtrs-clt.c=
:637
>    __ib_process_cq+0x149/0x440 drivers/infiniband/core/cq.c:110
>    ib_poll_handler+0x78/0x280 drivers/infiniband/core/cq.c:157
>    irq_poll_softirq+0x1ea/0x500 lib/irq_poll.c:110
>    handle_softirqs+0x191/0x5a0 kernel/softirq.c:622
>    </IRQ>
>    rxe_receiver+0x1224/0xc940 drivers/infiniband/sw/rxe/rxe_resp.c:1567
>    do_task drivers/infiniband/sw/rxe/rxe_task.c:127 [inline]
>    do_work+0x1aa/0x720 drivers/infiniband/sw/rxe/rxe_task.c:191
>   Kernel panic - not syncing: Fatal exception in interrupt
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
