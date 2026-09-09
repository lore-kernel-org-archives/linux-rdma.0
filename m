Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0B43AA1BF
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941618; cv=none; b=rR8gPr9c4mGD+eRRiMjD3NvCBMl5t8fSyH5soUk9JEkUZLD+YV7wyT++Ldgph77286HBjiuOCe4Um++otHmHNotZZCUus/vqvWnKmkBHUSPWd/7wxp7WKqArOcF9kTAPtwn8a1H8EWy5krCd0G6nlC+1hPE0iXv9jToRxt6VMDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941618; c=relaxed/simple;
	bh=4SlUJRZ6lCSLtCoC2eC7TwJ396NKEP6ndS27ONkS898=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MErE/pcMyhLtncDk825AJSye4ZUVAkbUy5l5dCjQ+009+UA2OV24MjpmCLEiGaxk6OS4NNIs1IXXeuR7J8HFtAc+ehIZm9ZOWAD56OgBaNu1a9XqWeo/Iskrnk1MfTV3NkfmFeo0mddCsZbw6j/FLv1WPnIzUcmnS8EgZ8t4iJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zq4wA4uC; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zq4wA4uC"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39675172593so4557739a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788941615; x=1789546415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=By31MJJOFbdY4DAev1nT7iD7DtFZXUQ34u/cf8nMk/A=;
        b=Zq4wA4uCrghFCyJKgQNkH2SKLrxviMR3hMt4Q/i/pPRt9AL2SgmBptOWE6NLRlRTph
         tW7SGIbeNx/1HejTBDZDdDt1wpzCML9b6NmgQ1+GRz1HlfFrebcdWoF+6bKaJCI4YosS
         Cnkwt7whgT/GKYf1x2gD6oWzzOGFbxwMaYI4wx/pJkUtwHtJk//8NR3ib4UQletbpC+2
         Ya6MKBcsl1mauoVxhfyUTNQh01s8sYs1iPc5Q0NlDFhpjskEzqMPqvoczEBDrHmC9q1N
         NJwXO3mXBglE9gr1tJQ/Ls1GTUgDd194zHoGBAkUF2u4Aydaqq73zHkHxoYgEWrDYZaL
         o9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788941615; x=1789546415;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=By31MJJOFbdY4DAev1nT7iD7DtFZXUQ34u/cf8nMk/A=;
        b=q0/erxlQs/Pha280YJ2f6aq/xWsNa3f/GvxPat49UnOwzvznOyMF3vsO4NNY6BVg/Q
         y5erQaDVHIBGfetTQjLQAQcyc2O57WOmqhLIJRc8CdBVjNVuTJO7mRmRZD3nLWrCOQj5
         WglOck1/HVjztatf19am0X9nllLtN1QWDag9HwOmVwEyfGxwhYsQcdy50SIQujAeMEF2
         PNK9pVnw5GBoxO5uKPuMCDWAptwysC36uYlWAVqi6l9r5fbOy5gX9yguu9i1odNjPlgc
         Xw8ZFmSfDwvEhxgCELkaSYLv2UTLWYkAsLKEHW1QqA/gt/rlaE/MoVqYlIkrU/PDZ0nN
         0Ulw==
X-Forwarded-Encrypted: i=1; AKwUvBzMv2OZcRUT+uhn5bqnn/LeB+F8D60tefeZCHNz5sdqSELGbXlnq6MBuJb6ladmv2MOeDHrKZTclJLe@vger.kernel.org
X-Gm-Message-State: AFuF++nlR8ovKQ3yXErc7kChXSO9l5ItykgJ+Kmjk7ZHdAhnsaMCMd6q
	f2IRuxItvsu1lymknVAuHZLE9KhRpoxIbUC1lUKEfg54H3MYerIKekvg
X-Gm-Gg: AYBFou1VxDhtuEtmg0DR9uAyP0ghuRk+4BKTB6bSpC7x6+l20Qszffm+V54cXb2Rj2y
	nSOKYQmZ5jdVjWiEB6yLk6c7xS/EZxNA1Q2FAjG7I5JoX/lvOsTgu7tHxm0bpof+Qi3EVF/2Qzv
	fY9WxFB51RGTwYgVESloF+V1CR4Kyka+81/vLeOkEjb/Brnz8TPe1aZcypzsg2mNy2tDZgWsq/d
	YDsHpiJ2GtteNWS/gJZKQkZqtpJJFSdsjNOgwYoBTbtRpiXWe1giD5hxgqWpjsbmkvT9J5UqAOY
	nddZWnyew/A3pWZhljqTyeTBYislLFNO21vYAhfCeTWUbRAIFVHcJXQ+PQvOL09Dss2Oxs9gNSM
	IY4ySLxNS6Fsona3N/bv59ipqrFaPYzQOiXwnUrLM9x0Q1HFC/3CVpiDXmjs3zKkwR4K+46usLl
	ScN4HKo8+S1XLthW2TkQvX2ewtSUXIX8uJf8dBrWpkGO5EkC2xJCLJIxr/b3hiEkcWWO48aAcaT
	IPabLebrahOJPjoJtSTD7Q3nu0CejZa/gDqu6hVXcLR2qA0L76ZEwxNKQK5dheF+QAGXaSKVbQ=
X-Received: by 2002:a17:90b:3fd0:b0:398:d6e6:4671 with SMTP id 98e67ed59e1d1-39b262981a2mr48566902a91.25.1788941615120;
        Wed, 09 Sep 2026 01:13:35 -0700 (PDT)
Received: from ?IPV6:2600:1702:7bd1:29f:8000::1? ([2600:1702:7bd1:29f:8000::1])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1434c745a09sm10347066c88.7.2026.09.09.01.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:13:34 -0700 (PDT)
Message-ID: <297da587-b4bb-4ae2-bdc7-29749144f5ea@gmail.com>
Date: Wed, 9 Sep 2026 01:13:33 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
Content-Language: en-US
To: Stefan Metzmacher <metze@samba.org>, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 Ammar Ratnani <aratnani@nvidia.com>, Kechen Lu <kechenl@nvidia.com>,
 Mithun Maragiri <mmaragiri@nvidia.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
 <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>
From: Ammar Ratnani <ammrat13@gmail.com>
In-Reply-To: <c46d2974-04fa-4f49-a9ec-43ac8c1dd4db@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thank you for the very quick response, Stefan!

> Given you have some automation to reproduce it I'm
> wondering if you could also test the iwarp case, see
> https://lore.kernel.org/linux-rdma/20260805000159.321645-2-yunseong.kim@est.tech/

I tried running my setup for iWARP. I used the old "bad" kernel, and the
only thing I changed was that I used an siw device instead of an rxe. I
do not get a hang in that case. To be more precise, I see the following
at the end of dmesg:

    [   40.006460] siw0: Port: 1 Link DOWN
    [   40.012912] siw0: Port: 1 Link ACTIVE

But I don't see any message of the form "INFO: task ... blocked for more
than ... seconds." Additionally, I'm able to list and read a file off
the CIFS mount, even after bringing the interface down and up.

For this test, I used commit 2beb1b31a12b ("Merge tag 'bpf-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf"). This is a later
tree than what I used in my last email, but I confirmed that I get the
same behavior I described in that email.

Thank you,
- Ammar Ratnani
