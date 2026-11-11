Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794418550;
	b=ekKwpuS84I3Qi/0Rdfq/BAiYQ4c0u7I2jQowWruCjISnBOjeB7jaHip9Mr8Gi3nrNshU
	 lxO1A6ej5nCLS/wfk6IVJgBdZrAYfZ+aUIvXgbzZJkifEunGWlb7d6tmFvliZMjPHalih
	 vKoCn6ek7yLru65JyDVutCiURB5rw6oKLbfjAB6ahDOg+ag4ZKOTMZX00Cb8A9WO+qtYg
	 t4U9jT6TUWsZs2qRtB6N+08X6MXDKdl5SNum5+dZbGlD1pG4kB6m9ThdsLBsFC3qrAz+j
	 por5mLA6Cy8jTAYVbn121D/Tire9qn8FRpjcAj5HXj4xL/usFB6PMkqN78al1wpgm3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418550;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rze7Z0eQK7AqMt9RdC+BLJSkX48Eh5M3Ql7thr+dG0Q=;
	b=4bP779TfUSF2AMCkZobCU5cjgHTNBbyWEjs6FIR/87dg8+XO5q3yvSzxP2ni+H6y3pyp
	 hSKYrU8rp6BQ1nm/5ACgBOxpre0yJkqBG9Q8Y1ehiWFalXq8Hfb2p8E1qqG9tv8VRKC5j
	 WNIDeiICl/5o+68lrzOI35Jol01kOVbZOEoBcVPl7Ckk8x2yJQaniBQ35bWafQ6I+LYOI
	 pRY1NxBVxkyF66HTOGtj7thmLjLGfH9Roncpkyu7SFUKey6EzfTrcSw3jHE+/lDeK0BPe
	 XIbuCjbPeipO1dAzyCR2cVzTMkHWKuBT8MF2dzpfz8jEeB+Ddwv7kYl8GzMqDzH4y0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IkC0eirw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 17:35:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A27D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IkC0eirw
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5383c97c8cfso245081cf.1
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 09:35:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794418548; cv=none;
        d=google.com; s=arc-20260327;
        b=Go8DswpCvt9d3aCQ2C9gko3kWJUW2dJRBPpWaUA3mXaWylO1P5H12PIVYSaUBZwrCF
         2PZVI62XxSX7IAk393meLZzU59N6Z+RzzkxxTIoUoSaT194uEPUWzjjvX0z9JTkYhp5F
         se5IO9GusQJiwUcSqoTViZUg+mwsmqgoBlwJoL9/urBMInEmfhJSBXLJ0pjYEaAOHyrZ
         Er1c9hxKBVNAsrZnZy2tsBXW8DynrZHpPyaSW8Lze79GoOv4oOegh1GopfUzuNrdqSls
         vrC9NWltLQfM/gh7gQGNSPHCTkt4JmH6SdcBF6JW/2mmd6KC8b+gFz/tbma+SEj0k5G7
         Wzdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rze7Z0eQK7AqMt9RdC+BLJSkX48Eh5M3Ql7thr+dG0Q=;
        fh=OTE2xHXhD/EfMnD1QpggksW3Qf4X9i4T7mm3g/8oGx0=;
        b=EC42YsrtLra+L+u0X3w/LxLQ+zWiMhq2PsD7PvfkJRfs9JxI0JNHMbBMDEuqUgjTuu
         +2LHEtYQpvbPMIH+YHhN8wgNaHq3lOd1JZ9xO3btj35E5Tv+ObesmQfZnC6Lyxk4IQs5
         KmSlGZRV5CbzgEPAG0e4PTu52KWkNm3/vXxlUYnGDC/J2/ICAUOqocU32FMvFlQ8yfZo
         PqBXIh5CPQ+nHtMdeWRdVX+PKBTB6zB/g3k0MAte4BVhmu15a/h0f6MzgrVNR89bcApl
         /uyhHx5FzuFCswCHAzURd5FM9RTWhdAAV/Nk7B5xqjEehb8+eYwFpLhzP4mmpjHg3iM6
         5C0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794418548; x=1795023348; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rze7Z0eQK7AqMt9RdC+BLJSkX48Eh5M3Ql7thr+dG0Q=;
        b=IkC0eirwlEe7MNOEfGkeXCfoBJnEvwG7EAZ1rM5fwsp8yplFuI/xD1D3bBc7rVsduF
         IEOyIaM0QMN4DkEU1PFucRq1qcH08BOV3tiM44jzmTd3R6UBYPDAhO7QCacBx45xgLsC
         3USBBW21eK73JLNXGZ2okflamitE1v6YQXO7d428vDSTiWp63WDEaRsGNDL10QFQF1na
         43pQR9J3hwrilQWNfPf6NY7y9Pamz+Z+Tmg27EuHYo/z+5gnJGp1FJr6ynJLsA8e8M2t
         wtMObUuSYt5fimycZsGWC6PdtQ5L/OvhtGzQ2/aQZI2KR1Gyc0qIwZxRSwPY6dFBQuZ9
         Scxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794418548; x=1795023348;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rze7Z0eQK7AqMt9RdC+BLJSkX48Eh5M3Ql7thr+dG0Q=;
        b=sBXowF353frPAeR3pHzLjwssu0JvY8T771hZuzUF1+LA17Xv4Nipg7gdWrI0ajPUHQ
         nUIpnDzjc4FCny0dncNotOTKoHK3EyMHKJhO0P89VA7As1k9ArB2djjWFQRsbgzJ2ESL
         1kMiLp1J9PHKRFJhmseuZmywszv6YYVttGIHy/i+FuEWlYdI2yMh7ajGD7se2c8EuA6K
         L9fgZfcfNHpVdQSoKWHy4vegxhHVi1VYp6AvlROW4XvGdqqJM4RJiqwwtvrt0WSWmFKX
         WVnxCxfCJCL8mgRH2Dj51jj9tLVkkWdVbpCG4USSWlDap6MZvW9gHWQkADtipRN/CrVN
         LD6w==
X-Forwarded-Encrypted: i=1; AL+hErERSI402ARxMgl5YLE09xHLajuveGckCSDxU2TzOFRT1tmfk3tUil1HYjgio9PdiluoHUewt3iPfqOa@vger.kernel.org
X-Gm-Message-State: APuU4Z+FL8Ki52Luj1QhjU35tYSr9IaTsAZF7hPOTaFAgJM2vE6a7roH
	v4Vlnryn3oIvEs+1fkTRvuAuMrBvrfm/IN9GOn0ffYIAllFS3j0+202xXKfIhNjZUe9mcOcsL3N
	h+ilq+FKQW3D/jlByA76Z6E4C2CB5a4wzdMqDgTY=
X-Gm-Gg: AYBFou0o5H1LaWzlcy7EUEZiAZQrrC+BjAEuOp6xLvo+/gNU7xlGtC589QXzsOk70KP
	cXo5/65cE9N1IiXf3+rkePi6yGMKNJZtq/zjXdSZy1J25+pyEfhhYi//MAlYORC5Jjt5QAKyJVM
	zVoF6Vz/rbiVyr9aZWB+ah/I29Rk9qksqk9jfDR7yayC17dcT96rYo3KZlNh/6IO80r7/wTBoU3
	44xvj1gzsE8ZTH9nVK0M/GtrSzrdjx8zS9ZDtsWX8cFEA5l8clpCGUqjnjVhLoReTIsibnoMovG
	VUGk1D7VbZ8Qn3PiWCEaJieIDVr5vNLGKNpYS7AqsOBMYswvYOOZIvBVyGcwup9tG09AJzGHqD1
	mmdJ1F7gXE8xrFxWNVEIJe0MYzTyeWDShf5NNtrlBsBg6dQpbyiUpX2Ut7xhJ81nQACizIA==
X-Received: by 2002:a05:622a:4c0d:b0:535:84ef:2e26 with SMTP id
 d75a77b69052e-556c02ffb41mr23168971cf.7.1794418545907; Wed, 11 Nov 2026
 09:35:45 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com> <20261106221201.2266301-2-jmoroni@google.com>
 <CAPd9Lg-242fV-2NhvXA-Ya2v7tZ0CHFLdwOBV7yK5aEHpkiULQ@mail.gmail.com> <CAHYDg1Q9MKJATZHcZ+-J7kRZUsW-bkP9FA7PGYDEzi==XO=A6A@mail.gmail.com>
In-Reply-To: <CAHYDg1Q9MKJATZHcZ+-J7kRZUsW-bkP9FA7PGYDEzi==XO=A6A@mail.gmail.com>
From: David Hu <xuehaohu@google.com>
Date: Wed, 11 Nov 2026 12:35:34 -0500
X-Gm-Features: AclHuK_oamB5MRuVNp7CgR-X1kV5cGbb4b_mU-_KZUhjdtbnmmQBYsO2F1Ud-GI
Message-ID: <CAPd9Lg_m_piYp=OCtRhSTWGwVaJ3=dLorptLso-w3BbAgtb+8w@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/4] RDMA/irdma: Fix QP handle assignment for
 SRQ completions
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 6:08=E2=80=AFPM Jacob Moroni <jmoroni@google.com> w=
rote:
>
> Hi,
>
> Thanks for taking a look. It is not really necessary to check avoid_mem_c=
flct
> in this case because SRQs are only supported on GEN3+, which always
> use 64B CQEs. The reason I added the check in the clean loop is because
> that loop walks every ring slot, so with 32B CQEs it can land on the seco=
nd
> half of an extended CQE, where bit 52 isn't the SRQ bit (it's undefined) =
and
> reading offset 40 would run into the next slot (or past the end of the ri=
ng).
> The poll path always skips the extension slot, so it doesn't have this pr=
oblem.
>

Thank you, Jacob, for the clarification. That is helpful. Tidying up
the handling between default 32B CQE, 32B extended CQE, 64B CQE, SRQ,
and 64B extended CQE is not an easy task.

Reviewed-by: David Hu <xuehaohu@google.com>
