Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793140695;
	b=jaVOSVN2NF7K84amdSisekmiyCZnd83rWHQUeRkfpydkuXg8IFPcK7xHtwkmcn5YYToo
	 6+4PRjTPClJWSGMbXSbJmUhTZteJo9MK4mXzXgy9hc6kcMkkV251uVQsuFmnGsxwY5YMd
	 syVEqAwSJS0EzUbqEM6EZi64s59qC1oOaJqzDayswghVb4b/o2ZTwUztTTALnf5BKKp1S
	 YiZY/iegjOA2G10YLxltS4tiaZJzH9A5kvNVxptAX6+I/+1mbsVPxviQqGYa6ZHs/h1ST
	 l+fHvVKcJy20i908G+4ASwPcT82FansaREDu1E7E1ATNhhp3B4BAu6xidbDtAs+Ne6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793140695;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LdT6iD6U5pz67EOvdAAgYZ+lbXiGFcABMt5AzI2eT3U=;
	b=h8l4tVOJKdVoCRw4L1Ix7qhXluwkiMP74v3GQba4jW4i/Y/TNBKVh+VAG5n7eE8EBaZ2
	 TnphIjxgkaVZcbkkdqOIb6FYRbnLSLQisxoihMqFosSd+nHOyYw2DAmkZXodmGcIcOIgK
	 RXenSgUnoEBTYdOngFvJXJhlvpS0xpj/ds6uwYezQ8ABtLBiahKwP9dMJZ/n5AkOaecty
	 eQMD6bWigPeixfjn4hclsQGwGa2HxcbLsrSrwPhbgvYXzp8UmUrSh/CLwGcTrz0eA9cLf
	 ZnTbKrZvKI5vEwWfV/NnqjfUy/X+q0tHHxXNidXlhUn7R4uiFyQj+54OiFKT+yUoQPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=cc2XeR1x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAD606A31D
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 22:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35CAD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=cc2XeR1x
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3514b90bb89so685795eec.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 15:38:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793140689; cv=none;
        d=google.com; s=arc-20260327;
        b=mwnMrNVkwfy0UUiuaiarhWbSnFvZ3bGJpGASXH+SRz+9x+XHhThQuo4F5MQcLcZ4Ly
         pc0J7ynxvzIkdYeGHS5ILh+mn+FudekXw2UhhJvM0LLfFN7Zb5hKfEOXy3mo1Qd1LiEY
         xdVUChiC0x/8RVUOmoiEEdz1Bw/jApLiL740Q8vcPaUqAU8n7IOKdxjGzBbgmts/pq6Y
         TDymX83Ae4yoAEFhxOCA/ePyvB7KC/MsjsFCfpvWkdgCP4wpk23KzDBz9GTz1mvxpK2z
         3u+XFJCs/rOGDJEnA3qeZL8K8K/OHddPnCr3cllYumpxyFx+gCQjix1ipP3B56PCHsyK
         eujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LdT6iD6U5pz67EOvdAAgYZ+lbXiGFcABMt5AzI2eT3U=;
        fh=DCOyy43fXRXKzS/SsniGoeRTvPSyjxFeLPx71m8Lm4c=;
        b=Hjqqvcf4122YnjY07dNYCwrSz/tPycCPbOQd15ITtqxmSSktx7X4e7BIZoZLX4GV1x
         IglR2A3t3aUSHCF0F/Zf5A5KSf47gFsHjGFLMV+UL3NznaEh0w7On+Pjpwc0Hpo65xIL
         PRFiFOqjeVOUAKkJiij1xNQKrwqr4JYbd/LRvme8xsyTYdF8JNistD9xABNHnyvbS59S
         lmzmAFDhpasgmoIGLvRhKRmID/G/dAlzTw4ZrPbfBe+HH39GD9b/kJqmzfB2UREIvsrA
         /mmlScS2o2C8LZAeGTawNWq60rm4f7LeVRbrGHSl9XlAAHG+kQvzh0ZAsi9lnVqqIDOi
         pDpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793140689; x=1793745489; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LdT6iD6U5pz67EOvdAAgYZ+lbXiGFcABMt5AzI2eT3U=;
        b=cc2XeR1xTEd4dudq6vGYwF6koFfj9kndPyZ7HEEHEmOEKnS0IHHqFLGOs+dqWrPh7b
         /nIXtP/BKKOUnwEc5sIp/AmDOhFHTGq7qEpd8htSz8cp+pBhaV2cG5j41ezVaSWt5KzX
         6AADMCmo3AqHy9fFaAQiOZ1tNfl4Tnp0JivdsJing8r0VuY5mRry8j9nP1aiZudnP+CI
         xVn/3zn6UbZ/8U3B77WnAuZG0rnqtqGKvvVDwqgyNSRAqmkaCt/6ioRPzz1EysSAIqvB
         txWBl47+OeIUn+juYe+CxnUyO3GxA70Vp9p+J627ODkY7YeB+Rr4vw8b0h4J7jDCZLlX
         4PPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793140689; x=1793745489;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LdT6iD6U5pz67EOvdAAgYZ+lbXiGFcABMt5AzI2eT3U=;
        b=JOX0JHL0fw6y9oi2qGTKh1w00YNRtGubFqTQBhca88HyeQPNBa3Pwbrhh55lBhKk4t
         X+6Y8nY98GiKUTMiY4o1//tVd1D7sHY4k/HlmNfFXHZoKnHibJAVWFngh6sWrK7eW0FS
         nxG2WyrdV1bcZh+AYW0xfEHoEaXM6oyeEEqa3cbQsMTVt+63mKrbczdQogW5jfSXocaX
         22YqlcIoKaT/rkXMnxlVPPxlN87Sp25pdDSfvHqqxdrmuUKRZmkdz38Y6Bd9WDUIsKv5
         +8EYj4Nd2cAsNcZjp62uAj4lUpXqc4zymks7sjFYKDDhBKprk+fVUW+Qb1j/vXdn3kLL
         Wd6A==
X-Forwarded-Encrypted: i=1; AKwUvBwwRF+k/9EDF7g8Yvmvo55xufO8JprkML8Cb2wcm8KHtPZ0XEpnCUNU/0b3NqZE1BBksc1RYzATqBrK@vger.kernel.org
X-Gm-Message-State: AFq9FYLUMyihV0U+S1CtM1husE4b1CVEZrws84r4g9cUcOPRD1teuBx/
	ax1cCHYHEpHhz4AG6PAz1vaYvKWNUJYixYa/eOcYY/frgO3/O3lwcNqhu3kf2XNHI6fVm3T9Oon
	3vJDXbmhZEujGuWWOoz58PS11UpVNgMfwRG0cHa+UOYA=
X-Gm-Gg: AYBFou3npc5LxGdUzPZG6CFLEuj+ncfWF8nwbKjD2Q6EoATG19JBz+L5m+OhZAaErAj
	X4gLnDrtbDrN0MqB/dvBkxOKIAUVwgwDi8/NQsQsGPMpRoOtI0Q4s9q5Nx9wIdJpT/oH/4s1m1E
	iUJ3rB7L8efWsvOmb+JoQaZGNbyDVmlvIjFm+E6cNLU9J/PbqSfqAEjnwAw4zNH89UABDE7dLQR
	HUOP0LZnVSKq43T2UA/JwYRfbLF94LEoN+5RNkMolNZZHbDlGKg5ukFTzFYYETnVJHuclqe4ifW
	y5bpBd5Xs7/uBEaQ/zM7feByzvHtqXnNO5w1N9QsTMbvHUDCg3VP66Tti+b9eLFBFXAseTWh1k9
	Pz8In9EZJX8n+A8kTpn2zk5iCGXOYq1xd92N8whTUNcN0AvTO99UBGn2nARmQCY7ot/ideGoSNe
	1MwHkDU3lI1dRw7jWlO3lZfCs=
X-Received: by 2002:a05:693c:23c4:b0:36a:15c3:2aaa with SMTP id
 5a478bee46e88-36a200d82ccmr1623831eec.29.1793140689069; Tue, 27 Oct 2026
 15:38:09 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016202909.1289496-1-dhu@x6u.co> <20261016202909.1289496-4-dhu@x6u.co>
 <sashiko-outbox-174922@kernel.org> <CABdL-LTgFTwJPTD0vyScNsvCSAW_04TgOyO1swVBgHxDcmJsfg@mail.gmail.com>
 <CAHYDg1QGH=GwAB-acW_oj3DJdSZBPidv9Xxn+n9=RT9Ss2PC1Q@mail.gmail.com>
In-Reply-To: <CAHYDg1QGH=GwAB-acW_oj3DJdSZBPidv9Xxn+n9=RT9Ss2PC1Q@mail.gmail.com>
From: David Hu <dhu@x6u.co>
Date: Tue, 27 Oct 2026 18:37:56 -0400
X-Gm-Features: AclHuK-6lGzWX7nlhDFd22pf3urIRUeJsC9YK5ZEGM6BvwWD4uYQWxMpRmotH1Q
Message-ID: <CABdL-LQUdPaHu1tKW7fyXraBEUQBK-Xuv59e6u9_U7+AO7NivQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next v3 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
To: Jacob Moroni <jmoroni@google.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 8:02=E2=80=AFAM Jacob Moroni <jmoroni@google.com> w=
rote:
>
> Hi David,
>
> Looks good in general, but since this IRDMA driver is used with iWARP
> NICs today,
> can you double check this Sashiko finding? Maybe this newer path can be r=
ejected
> for iWARP NIC types at first? Or if there's a way to make this new path w=
ork for
> iWARP, even better. I am not sure if there's some generic way to map the =
generic
> umem for CPU access that works even for dmabufs?

Hi Jacob,

Thank you for the feedback. I double-checked the Sashiko finding -
yes, we can make the rejection explicit. I'll send out a v4 shortly.

re: Making the path work for dma-buf + iWARP.  This seems doable; it
just requires moderate work to plumb iWARP specific quirks to be
dma-buf aware. However, I wasn't able to find a compelling real-world
use case for this. If there is a strong preference to pursue this as
part of this series, please let me know.

re: Map the generic umem.  Yes - I think such a capability would make
things easier here - maybe something like  `ib_umem_vmap` (not present
today) ->  branch off based on `is_dmabuf` and `dma_buf_vmap`.

>
> Also, could you provide a bit of detail on how this new design ensures fo=
rward
> and backward compatibility across new rdma-core, old kernel, iWARP vs RoC=
Ev2
> modes, etc.?

re:  Compatibility. The only two cases of interest are:
(old kernel,   new rdma-core):  ioctl parsing tree wouldn't be
registered; ib core dispatch would fall back to `write()`, and it
would work as before since ib_udata is populated by ib core.
(new kernel,   old rdma-core):  new kernel irdma perform
`uverbs_attr_is_valid` checks and branch off to old handler logic.

re: iWARP vs. RoCEv2
This series preserves prior behavior while adding support mainly for
DMA-BUF heap-based queues, for RoCEv2 use cases.
VA-based iWARP continue to behave as before.
This series introduces the possibility of dma-buf in iWARP mode. It is
not tested however.  Rejecting DMA-BUF + iWARP would be a reasonable
choice unless there is a clear use case.

>
> Thanks,
> Jake
