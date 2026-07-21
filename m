Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0DE32571D
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784651797; cv=pass; b=LLocH1FDnqg1K7RttjXUV11aREEhdYL03MwR3p7g80M34iS3E1h+dEQ5mahUK8syV4oC+UGlQiUkSkGtbcISqeFEWCV6yV316aky3gyzXeu1UEU0kipW3gMoWFQ7u7OLDOWs+XRYgsn0V9T084kADxZhrd1KZZaKjm0KtTjPneo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784651797; c=relaxed/simple;
	bh=CNPPoWv60vr6t7jcqE+3A/Q+NYsoUCXVG+74URQb7f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qs3z2N1TLqaqcU4/amPqChnMpq8s92JNtBOLsp6ydsf6qXDivwgmsmfyzlBn7TmrUhPnjlzQ1Qa8UROfDFmp4tXBTi8Uw36QHYEAV3hv32egql07Cz3b9x6LHExiI9Cve0s2fZIT3BqUYy60KnQ48U2khn37A36aWk/zLEQIOpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MeCBDNao; arc=pass smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeCBDNao"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ccbff2e6a7so67611995ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 09:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784651795; cv=none;
        d=google.com; s=arc-20260327;
        b=IDcUKRJvpPmCeaqmSQpqiOHWguN3mgOpp+DbuZ2PEG/K8RnCX5H2ysDOwYLpwYlNnT
         eEA3WQVbq0dmprD1b9kJQ7HIu+8PPSieK6bH9aIt9B5puQxJhg8/ouPH7Oznt0DY7u4H
         ohWPLr74fBUuwmjneOiGJck5zKC16g5k09Dy4gWs22McyGglmcxPTk+5MBC2H0jtSGuH
         wIQ4XxPR1qE+CAFNSgXZXId4j4NC+sumTT60STYMcqrmGEq9pfmXEJyDuG5hCb13lDy4
         gvJWBl+Hyqko3RGkUf2g3Lxl+Y691RUjjFRt4olPOK6WUn01340A0gn1ZWr54gPzZwkW
         1H5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vVqgX84jQjtV56FO/L90fCXJ4uFy/82Ndepm6gSaM0k=;
        fh=tr9DxOoiJwNUUgAnfG/JCUavxFSbWxtY1WwroXZs29g=;
        b=Zh6mEEoVZKRklbJPtO03lEi1h8fPxIL9AviViLrcyqUtUu3ZPuuvKQYTDTeB9BocDt
         yyexCozwovXvvETH9hNFl9yTJ1I2uy2M/RZCPKtHeoA06z45UloG1DkdebBWQ/p6O8k9
         l3JxNHv2207fm1564rmaTy6D/wEdCcPLksbkqIo+QBTkLLkzuwLnmUrDnap2Gz9l6E2G
         Ow9N41iQ0GfbsFCqKy937dqfDblwvJ+4lizQMkDDZlSEUbnhOXp9SfonvduiDikJLrvk
         Rc84wo8p/jRH39YgBNCmDtIAsi4W0I6qUJEF2IuqRkOxYvYYP6MrAQBT2ZtU9P5xaK+h
         tt6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784651795; x=1785256595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vVqgX84jQjtV56FO/L90fCXJ4uFy/82Ndepm6gSaM0k=;
        b=MeCBDNaoXaMR7/E6WTm29zajfwJvUzkQeShRomoG4sLt2lJBOlk11L8+JjaszypRPZ
         sUveZShJmNGDOmpWe6x5wsVd4TPqc6tqC/jLcJOrlE8IjpYCQlpb7U/3cHz5o09JybYi
         tXKP2lHk2QUkG0l2vd8wcurdOv4bA7klhEDRFl1vWLcifOqwVNCwJdfMCDi4mv2/MX9i
         XBUH9Ffd5XS6ocmqt8Xbpf8ziHBkaJ9Pz624lzbEQ+xwtnWFymANB3pxbxfiR/IfmAkU
         MfYuRGIrON6DXyIhBoQ/iU+ZYkOPyXRbQyWYTZ5HbTNOpYb5F/+ZxT48y57axU2IMIPP
         56Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784651795; x=1785256595;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vVqgX84jQjtV56FO/L90fCXJ4uFy/82Ndepm6gSaM0k=;
        b=AmhUMG1cbLsrek/qBPZmWvdOqd7vPWZ3atOT9vpEjClQ5kPicfl2++3Ek/flaVkthJ
         7x/u956pZxTSrfROf/Dhm38Ou/rz7gxrxLAIW45UHmRxBsQww1+GxFkCZRUraKZItCnT
         6Zr0JAuiQx+HrbRgv/5jVX9zQjQkTmorK2Nhd1RcF3J6K0xSK7+BWYfQwIIp68gIGZHH
         5SyWWmyP4kcVXxTepF6CW61jkH4YgUgqNaXs2A2CaGvIGdPmmJ2F9T8Iai4PGlI8BXE6
         NcJ17VLLU6f/kePbYemq9U1+hkMUNLIHxWMJIraT/Kr6bQWwWQWB5NBjvrBFqJ1Fe/U5
         0yJQ==
X-Forwarded-Encrypted: i=1; AHgh+RosveeoNK4IKeET17YQqIyGAWyUpQiFjYCm2nZjNjvtXxYFtock1vqM0Ku+U1Pch6/Chz7LDyEYDGY9@vger.kernel.org
X-Gm-Message-State: AOJu0YzIk0gjImCp2ctdrcQrcJj1CqL50JUrNgPGb/dc3SpnA1u35mXO
	lKuMGdsS6TJaEbyiNPcpGouosDM8siKXyxLbd3Kbx7dj6hU+jzkzOHjm8uG/1I9dVoNllLZTGfh
	Q56rm9xkDRybdEVHiewLAZz7oCwl7X1oTXtFAnXzc
X-Gm-Gg: AR+sD13pPrNh5KplAolHwzJDxj9/V5rLMAAArJ+kL9mF+Xy/ONlNdgdvBLCrVxuJkO5
	M1yzOOVbQTfmXN7gHxu6PRGkx0YLa4ZItMsYX4NggKOT20NF44EHfY0xmjGYHnygepnGaw+CzaT
	CD5YpT1TqGMz7CPl4kfnglDULKu4xAEej5rFuy7VOWXkkl6bCmWRij1qRLdSgOpSAyOECAF31o/
	TqPRHlclyGqcIVQB3FX0ZYMuC4bBoGtado4Y9USriA+OCN1dUcSP501fLV2dzpWNENGAsFQ4zN4
	yYYKF3zKPIhJUIiaFk4=
X-Received: by 2002:a17:903:3bcf:b0:2ca:ed41:d33d with SMTP id
 d9443c01a7336-2cf34a80342mr224602735ad.45.1784651794678; Tue, 21 Jul 2026
 09:36:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719175857.4071636-1-ap420073@gmail.com> <20260719175857.4071636-9-ap420073@gmail.com>
 <41e73be8-242a-4e7b-b085-439375303590@pixelcluster.dev> <8dfbef48-db20-4642-8f50-e37f46af6627@lunn.ch>
In-Reply-To: <8dfbef48-db20-4642-8f50-e37f46af6627@lunn.ch>
From: Hoyeon Lee <hoyeon.rhee@gmail.com>
Date: Wed, 22 Jul 2026 01:36:22 +0900
X-Gm-Features: AUfX_myNLtLISc21KdgKa-JpkJ-v8hHK4oD3B4RXKoOMKPs4a14geDJhHunEcxY
Message-ID: <CAJ=ss6_iUvP3Be735V6_dD0JTF96=NZWe5_G_p0nubdRvCZ==Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 08/13] drm/amdkfd: add GPU instruction
 emitter and disassembler
To: Andrew Lunn <andrew@lunn.ch>
Cc: Natalie Vock <nat@pixelcluster.dev>, Taehee Yoo <ap420073@gmail.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Alexei Starovoitov <ast@kernel.org>, 
	amd-gfx@lists.freedesktop.org, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Andrii Nakryiko <andrii@kernel.org>, Bill Wendling <morbo@google.com>, bpf@vger.kernel.org, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, David Airlie <airlied@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Donald Hunter <donald.hunter@gmail.com>, 
	dri-devel@lists.freedesktop.org, Eduard Zingerman <eddyz87@gmail.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Eric Dumazet <edumazet@google.com>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Leon Romanovsky <leon@kernel.org>, 
	linaro-mm-sig@lists.linaro.org, linux-hardening@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, llvm@lists.linux.dev, 
	Mark Bloch <mbloch@nvidia.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Michael Chan <michael.chan@broadcom.com>, Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <shuah@kernel.org>, Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@kernel.org>, 
	Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Yonghong Song <yonghong.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 5:53=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jul 20, 2026 at 10:05:33PM +0200, Natalie Vock wrote:
> > On 7/19/26 19:58, Taehee Yoo wrote:
> > > Add the AMD GCN (gfx9/gfx10) instruction encoder used to build the GP=
U
> > > shaders that knod dispatches, plus a matching disassembler used for
> > > debugging the generated code.
> >
> > Is it really necessary to have a full-on compiler and disassembler in t=
he
> > kernel driver? This patch is massive and I'm wondering how much benefit=
 it
> > really provides. Is there really no way to move GPU compilation out of =
the
> > kernel, one way or another? Could you get acceptable perf with a static
> > shader that interprets BPF programs at runtime? Such a shader can be
> > compiled beforehand and just embedded into the kernel - there's prior a=
rt
> > there with the CWSR trap handler in amdkfd.
> >
> > In case you really, really need to compile the BPF to native ISA, could=
 you
> > still have userspace take care of that in one way or another?
>
> There was a long and painful discussion about P4, and offloading it to
> hardware. The proponents of that wanted to do the compilation stage in
> user space to produce a binary blob, but it was hard to prove that the
> P4 passed to the kernel for software processing, and the binary blob
> passed to the hardware actually where the same. It opened up the path
> for closed source P4 where the kernel never got to see the actual P4
> code. So it was not really offload, but kernel bypass.
>
> So having a compiler in the kernel is probably the correct way to go,
> if you want to be friendly to open source.
>
> The other option is to get the GPU to do the compilation itself, so
> you pass BPF byte codes to the GPU and it generates its own native
> code. I've no idea if that is possible, but clang can target OpenMP,
> so maybe it is possible to move this compiler into the GPU?
>

Hi Natalie and Andrew,
Thank you both for the review and suggestions.

We tried running a BPF interpreter on the GPU using OpenCL in an early
prototype. The interpreter overhead dominated because each BPF
instruction required many native GPU instructions, so the performance
was not practical. Since this was only an early feasibility prototype,
we do not have benchmark data suitable for a meaningful comparison.

Based on that result, we chose to compile BPF directly into native GPU
instructions. Moving compilation to userspace would also raise the
problem Andrew described: the kernel could no longer easily establish
that the verified BPF program and the submitted GPU binary are
equivalent. We have not tried compiling on the GPU itself, but that may
be worth investigating separately.

The disassembler is only used for debugging the generated GPU
instructions and is not required for execution. We can leave it out of
the initial series and submit it separately if needed.

Regards,
Hoyeon Lee

>       Andrew
