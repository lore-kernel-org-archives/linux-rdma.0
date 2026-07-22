Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A731F41CB3A
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 20:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750575; cv=pass; b=t3zNTs62W6fhgqvmYcXRLyDfX4MR+yeNtup9wYAIdJ+7UogYHop6Qzwx/yJveamJPIGv21iPv6sPQq3tsWlqm8Cp4/0miLZ/YyMIQEidM8uDEAp4FbXhu6S4ShrVHTvSIXph4aHFnAR3zQuWFvUwDkYFK2Y9Q4lUef/mmtg4TJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750575; c=relaxed/simple;
	bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=koKnGsqR+S2uf0d4UwGXZfUsbGkTYR/7j8t+2LFaPo9FgxucSj6+GKaiDJJv3BuxPIAftT2ehLAVQjCAQfJQ/y1xcs4Eh+oCuP16qJFIrUH6p/BAFDC9xXvPIW/AYBGY2tckt+uV8LSAGHHUir7jTiP7FpSDSu8jDykfXG4CpSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=fVqSFWa8; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="fVqSFWa8"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38759bcd877so11710167a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 13:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784750574; cv=none;
        d=google.com; s=arc-20260327;
        b=pXPa4P7N5+W0yoq7gnveN0+7GWNsfpkOZFHqX0ubBU5UoghK5pxZNkjFnw+FgVnYxo
         UjXRUIh8YdaTIna42KkCzEFvD3w9EoSprj359bbrErbTZoLJnIcvMNX2+NidZ8R+z7fx
         l+5QC3hrdNp6JwudfJ+T/8YLkdVtfqn9N/GglSZ2z4g6qFM49pGwnXFvsL0N5e4Jylq9
         2uspROQrAntR338N3ts6S/HVvmUFOxNmWq364TQo684gNwmpTWldmPaNllqZCf0S5pFX
         CtWaMLlJElJHfAF3FxFOjbclV9CGc1ZND0/JiOALZJ55JjyU0XE9et6WdDdqh7lpI6BR
         4lTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
        fh=5Q4m/6fhqEXxEhurMLyh0x6r5jipd5mhm253DupIBHY=;
        b=TEGts6MA9clYrqKJI+X0xEQVgrIgqjgwszpd9O5j+XYBbQ395cVupYlc+C5nxP58dd
         LzDQ5Zx/bkXzIWDc5sQmwnjGTqQxnIBCuqAWzaXPVKRMIKXs87VIRHxX3aJ9GS/VJ7Pn
         IQkKjne8p1oZGdm2GBRkP/N+YjSeA3AydTsQ3pN4cflc8GvWoXjHOs8RRNm7z5So6kvt
         bsvNVBu99psGbuIhYSwrDzrkULzPXjggFLAjTQ6GqqapgiKEsfAzFMMjTGXdOJcw/WQQ
         JvQyYEojaPC0R/VFX3xUwAdvaGY0TRjfJldt9riDYEnbOsA/b4G36B73pKTdrp+fce5C
         t0dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784750574; x=1785355374; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
        b=fVqSFWa8CR4WGP03THynVHBaqIQzRh1S9Vl7PP6rUAN/da1I02prdrIB2JF1bbV1L1
         jHKk3cp7aLmOGxcp8y0PLLD7sZMFWl7a3pBjaCJUK3J71I5PCfocLuZiopCUpIXu+sxc
         BqX6U5InP7Xn9YJ65cTQQJTHDnd3tuWpL3HpGZCceJkKdASxEA+FTIYKo03SN1HBJfms
         CP8NrqIzfmwRbKqLu0AvRKYacacnwzJh1HiFGTm2kgQbtz7nNj1TKnS4wmGAaHF+t0tR
         7Y4IFgR2kWg/Ef3Ej0Tcvd5EeTM+FiGokqFpY+964NguHyTc9n5FCXVcfXaAzqJ1xbnf
         pRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784750574; x=1785355374;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
        b=pJgL/vvLtrOtwjdyiGvl0UjgRTYETnNZpRNrMSrX/eMI6iZ36KvRhMCuX7724i5Lhx
         ounfolC29ux28D/SKhMKpQW9hTphxF2MunSei0hrqzbviGZcvrUZjGfzxvJ2kcT5Atyb
         mZluRQtmLymhzsHcd034znNJtyZmq/n2NiBt0na/KKT1dFWnW2W9ngWcxyePmYhmezwE
         uBPAzr6WAyGgEDC/mbixKQaMxfeAF7jYzmdzONqCCr8eitoqWr3v49Y9+N5qCVM54FCM
         +cmcu6EsS4zHjw7eE7lgF817eAlEPUSxM3321vLkkSEBU0oXWr5IEUH8pJCB+2BtEctp
         l92g==
X-Forwarded-Encrypted: i=1; AHgh+Rrem2JbKy6Xd1r6NtARIguHRT4B0VjlvtK4cwfbmCENwGWK06mDcRwzbfhiuPJclt31qwgoxQ+3rcd6@vger.kernel.org
X-Gm-Message-State: AOJu0YyBsy/VV9kdkTGs/GVDmqszZaPzK9ToG2cbDDWhaEkxsxPPo/9t
	gYI1eHlC0AY4mIG+w4HFyYA9mRcVkuoAvFWYDlxlCv2FOIUIhuYs4CEyIdoZT6itPqSrPKb2v9o
	yUpN0aLdlTTlbn4ex0yG+hdfPATEGhG+ukHIU1l3q
X-Gm-Gg: AR+sD10FewcUxGwYT4l8pIxLm91G5ywpkHjM5DWJ/Q5eVvJTHaCDDoYkSX+F+fySJ5D
	IJaGKOuwK8hzH6YJkFUEHIJZbBxeWQMIb0Mv5Edzjze6+2wkf9gwNuRb0rPuiNw4+zXHLFoZ0Y5
	SYr1Lrf2ECUhFw7wHOYxP6Ce16bUbHXBL77wrk5XM11Rs4JkTdWhmOclaKVCazUPnz91LcY7Lut
	zswtQ3IICu21UMH7HmoDCOkw/F+U8dAQ+/6RMT/eRjPlvA7ieMNWap9RrAx25KPZiGCooIXwdei
	DrbJMEs+OpKfyELiE/Plo8rMxjGLDuB3AlaaMavQBDpYGLbJXJUbJlDQYYyEiU/4ptO3CM4FDEf
	+CJygR7gcVPSa/WuI7KTjixWQr6w7v6YLvX1dBt8=
X-Received: by 2002:a17:90b:2d10:b0:38c:a59b:5189 with SMTP id
 98e67ed59e1d1-38ec698af76mr113249a91.15.1784750573899; Wed, 22 Jul 2026
 13:02:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722185841.449934-1-mykola@meshstor.io> <20260722185841.449934-9-mykola@meshstor.io>
 <536428fd-9c23-45c3-be0a-5eaaf8f3939a@deltatee.com>
In-Reply-To: <536428fd-9c23-45c3-be0a-5eaaf8f3939a@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 22:02:41 +0200
X-Gm-Features: AUfX_my0hGYZfb89FIks6uN6jtY1SapXkJQfTk3Dh1NK0AxygDAcUpRTP3iNF6Y
Message-ID: <CAPzsNDscnb+fH0XZF3qBDgxkREmgh6F=rp0GO18Wy7gLc=4Ldw@mail.gmail.com>
Subject: Re: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I think it would be better to
> move the code more towards similarity with raid1 instead of diverging it
> further.

I'll move bio = r10_bio->devs[slot].bio; up into the declaration so
raid10 matches raid1 in v5.

Thank you!
