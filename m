Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793085068;
	b=jccPT2Xji8CPjOHryDaQ37boEyXXmJ9ndtH7AZTWiXS6DbVpAxcgp9JeNpcye/gvNuLi
	 HKdi5p1I+NAx/oSZ8sivJOLZQ/bq2rJ+mN9RnEQGoULj3lBywnMgtQCoSIvvksFnA+1ut
	 dHGlKS1VfpTbbHrtctJdTFyDMLHag/R1dT4JnVXtZJbaTDVTPvG5sEzZeoIN/3oXqs1Af
	 CoyK69jNK+sxdyXZXV0PoxqReo8jndPUSXiKmdl4jDwiE+U8Ski6X0OebLId8kB+Jj7qH
	 1rVJqj1pxx1KSsO3uPiynFvn08xZv1yHMCNBlyDZY1F3WjQudv1VjKnwkSWCDNjk3mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793085068;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=58obxpwxYYZoALNGWQdjqVtQJcibSkxDUE1cQjyCWT8=;
	b=d0bs9wmQAj3cLO3cFm5POXcCdyYY6ZsA168BijDQ9atohfyIoq4i0ZtrBrEAp/oJ+9AE
	 WBarMpqT3mnMm2k+7RFLlYc8s579MOb4l2Ix5aOsl5KjgTpA87wHIujgnoIV2KHYzBp3r
	 LS++AeAS0Zfr2KdlJ/zKqG6xRrkxzUE4Z/kFOnVm8tqw9YUKK8BnPWp2FBlUKmB696ids
	 6+KFlnvWvJTNQ1+cx91fOeLKMl7+1Sqpx0hyoaG7tts4tcEbBVPzyjdJDiCKXAUj82Jyz
	 A2kJcV8qm44RJWAM4wBIr2VPsYExhKVyIx1t40Qd17gfybU1xheB2a4sl82DuaoOqLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=web.de;
	spf=pass smtp.mailfrom=web.de;
	dkim=pass header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=TNbMrGSz;
	arc=none smtp.remote-ip=212.227.15.14
Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED88E606A321;
	Tue, 27 Oct 2026 07:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED88E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=TNbMrGSz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1793085035; x=1793689835; i=markus.elfring@web.de;
	bh=58obxpwxYYZoALNGWQdjqVtQJcibSkxDUE1cQjyCWT8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=TNbMrGSzlLQxkbgPQzJgGt0wSdFr0V2ROpzQg8lpNZHo/enN7awNWQ4VPSO8Qby2
	 PcInCtJilisDOeVgcqV/IdngS8ElKVGKXeB16XyV1C5xoOYFDGYPKL+1lJ+cRxdxd
	 vfpRP6pUcNkgRCrDDmV3x8Fe9U7049QiCE63sng8IKDurSADH5GpSDpNydzm4qy0Z
	 VF8JItJFMeTC0QGEyANa7St38rnCDDxTIzU+D0CnmTOCxsW1enyZYz43auiwatmP/
	 1wjdvFnhltAfm43/4ahgrDp8W48CAEXYU/nZysUjfqzJRLgVE4eiEQnwwCf7/24sB
	 zENur9Hr18KJTWmFZw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MwjK2-1wc1tB05iU-010u9J; Tue, 27
 Oct 2026 08:10:35 +0100
Message-ID: <46653715-7efb-40ed-b846-584ed1948eba@web.de>
Date: Tue, 27 Oct 2026 08:10:12 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma v7 3/7] RDMA/zrdma: Add internal headers and hardware
 register definitions
To: Yanze Zhang <zhang.yanze@zte.com.cn>, linux-rdma@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, Julian Braha <julianbraha@gmail.com>,
 Junxian Huang <huangjunxian6@hisilicon.com>,
 Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: lkp@intel.com, LKML <linux-kernel@vger.kernel.org>,
 Chengfei Han <han.chengfei@zte.com.cn>, Junyang Han
 <han.junyang@zte.com.cn>, Ming Ran <ran.ming@zte.com.cn>,
 Quan Wei <wei.quan@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-4-zhang.yanze@zte.com.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261027021119.2325798-4-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tm3NLm+vo+SFL0tn7noWLY9aS6cPoGi8JCikG+O/h/vy2R7vYKE
 GA4hQKYpurs6CNHwJLUM9XhtV6q+SFNYZkUcQ5/dkM4sKYqwSbR6/LXPZT/t/lFQclyYlAm
 7Wo7cuYwt63fp/ZcDi2ZcXPrUZot1yt/6wuY+kqZQx9Qq+xG3lXv1ZGCFGCSL1r63JqQ0tV
 DtTdXT3nEZWgGxHJARcLw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2bphluMl4gY=;FdJaO5P78Lz0oNtwg4KmXkA/NXP
 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

=E2=80=A6
> zxdh_free_rsrc() uses guard(spinlock_irqsave), so the lock is released o=
n
> every exit path. zxdh_alloc_rsrc() keeps the explicit locking, as it has
> several early return paths, and takes a pool name so that the exhaustion
> log identifies the affected pool.

How do you think about to move such hints behind the marker line?


=E2=80=A6
> ---
>  drivers/infiniband/hw/zrdma/zrdma_hw.h   |  21 +++
>  drivers/infiniband/hw/zrdma/zrdma_main.h | 216 +++++++++++++++++++++++
=E2=80=A6
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
> @@ -0,0 +1,216 @@
=E2=80=A6
> +static inline int zxdh_alloc_rsrc(struct zxdh_pci_f *rf,
> +				  unsigned long *rsrc_array, u32 max_rsrc,
> +				  u32 *req_rsrc_num, u32 *next,
> +				  const char *rsrc_name)
> +{
> +	unsigned long flags;
> +	u32 rsrc_num;
> +
> +	spin_lock_irqsave(&rf->rsrc_lock, flags);
> +	rsrc_num =3D find_next_zero_bit(rsrc_array, max_rsrc, *next);
=E2=80=A6
> +	*req_rsrc_num =3D rsrc_num;
> +	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
> +
> +	return 0;
> +}
=E2=80=A6

I imagine that a lock guard would be helpful also for this function implem=
entation.

Regards,
Markus
