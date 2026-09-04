Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2254D29B781
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 07:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788508184; cv=none; b=OjjOQExlJWhl96JVEiwXb7fKykxOHn16YMOS/QXAgY93Tj2CGgccg50ae3yePqTD/PLDIuIfp+R4yVvbeK+48Nr/gSfCn+B3wdbvcUpslm9I8mQQg8tuV7uroifIuTHMKzHMUe6YtntUZx4cOEl15J++hwh3boJGfCqebeTGUI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788508184; c=relaxed/simple;
	bh=YB8ar/qQYP+4I/nZAw48tAdIZWF5CsS+pPJCCTS+pqU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Nqt8m+/VndqHGWQRlCOfRak4h8R4sIyA0vj0dqNUt6+i5vk7JpdtiFGhWN55MnkFFv0DHwIBtWyL6ZFT9W94t2xxbAn9NEBfoMESLfYK2TyuBqOy7cjc7DUmJvksA9ufvcZj5yCIKtFSjtA8vPkjmDS6TWJE9p8vYdf1/AFWgdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=UIIU055p; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="UIIU055p"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1712a04ddaso115156266b.2
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 00:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1788508179; x=1789112979; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DyGbWz3XmSBAI3MaQKHTZ3YRCUHCb6c/vSa3rh92CwE=;
        b=UIIU055p9DOBR/bT4oPnJfltTLVvBlpgSL1KMQRb8Uc/BKiFy2TeBLIsq5W1NQ3d4g
         MBPvG3tAJCWHPYlDWVx+UUlkYbuzd7kDQGiQF5ScJS4r94Y4hinLLKXmrB8WKNWQnfk/
         6+KrJ3f+neAqTOAEfIT6tRx3WETC7stZUYN/My6/TcmLEr1HhK5LHto3ZSSCVL3oCTod
         XARnmfMhI27GjwtEU1IRtX7Ajluqip3EXdE+I2XzWeQKD+t7z4U8B4vnGqx0nCWS4jpP
         PZFAMvdIRs57F5mojDgViCLHAZ46F1gK6ZO7zHeoRgCXVvGGP/pu7kpiBXdyG3ET5+c7
         uqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788508179; x=1789112979;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DyGbWz3XmSBAI3MaQKHTZ3YRCUHCb6c/vSa3rh92CwE=;
        b=bFGSfc4nGhUNGLgwTkOeErMxNQw5s9gmoIxxBXYWyUY3L2GHizFABkFvMpoK0m9jfm
         WCAcK7RgPi8gMlsVY46QUl/T2/NctdNPj4TZetnxNgYKW7EIKjNdnFZ7gGSvv68QONkr
         ML7kxCSl6bchL2FbMTWjy+7OTkBnCOO7QG4YhLJCGTZ83BHzqVpkOYnEzWpklO3hDnHa
         wg5qQqhbQiZBQtiPRHchVmZUb80vCdVpdvRLpyuK3PVPIBdWE+/i83WMRXqQQGLUVQWj
         WoC4qXnXoJZco64eMBiZmzHz+9fakDAX5DFm1P7Np6IxSSIMo05tedHKR1Cwq2YUjLkN
         86tA==
X-Gm-Message-State: AFuF++lGQFA6KPRrC5GTzP//vWsmjROIxw0b0worrBj9gEqP/KMd+LUw
	QR1Xrq/jfw6ykXnZMsofWc02eEpK2pkFOVXGvUSWX7OTs6DFgDwKa68KozkP7WRsRU4=
X-Gm-Gg: AYBFou38hE+BBah3S6a/bOBOlsiLsXTpqlYjiDU2QF0EhrjA8mTZCR3wSVs3UQKc+L7
	PwEifHPNQTYvBjYk3DJcLfLZnCj+ghvqjYqzQA1cSla0nzfo4CZYRzgqLCSTH5lspAmrsZ4l98g
	qXHh3DSOYxH1xtqABq67C2naVRCNyVK23AU6EQWKwCjd6mad2na/vUx8knBeWpAELgSLB6GLvFG
	QW+26ytxStMvE4burYmj7pZGBbrRwTwhC5Eh/9ZdH/FecS8yNRAbcjcofa3WqOofVeXeAWZRAfk
	Q6H44CNYiDJAT0l82SFSQr66B4SEoNpRUG9wEKbSpuDHDmKowIk9QPC3edND9XRwp39ZAfcXNQY
	5CnyGPRA9DkXBPHPm75kKNw+hbeMtbx4itLSwl6plL93tjX4g5hKWjHyKMdWvB3UQp0tpwBMAUZ
	sXNeuE46IOYtoqnOrzqbByHKVMXMoo8eHVJ78SIa75J86y0tkov8UBFGaxpaXe2dZY+SAJy7M3X
	1F91fBiKcW9nhm0xwfb5rEBzARg9Ol1d0xpf1Wu7Q==
X-Received: by 2002:a17:907:94c7:b0:c1c:3b06:ed03 with SMTP id a640c23a62f3a-c260cb54617mr208786566b.23.1788508179329;
        Fri, 04 Sep 2026 00:49:39 -0700 (PDT)
Received: from smtpclient.apple (83.10.35.35.ipv4.supernova.orange.pl. [83.10.35.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d53c37csm67302066b.32.2026.09.04.00.49.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 00:49:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] RDMA/rxe: Reject prefetch of a non-ODP MR
From: Norbert Szetei <norbert@doyensec.com>
In-Reply-To: <20260901075611.GG24140@unreal>
Date: Fri, 4 Sep 2026 09:49:26 +0200
Cc: linux-rdma@vger.kernel.org,
 Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <874DA83D-C81E-4858-B9E7-D2A3BFE0137D@doyensec.com>
References: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
 <20260901075611.GG24140@unreal>
To: Leon Romanovsky <leon@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81.1.4)

On Sep 1, 2026, at 09:56, Leon Romanovsky <leon@kernel.org> wrote:
>=20
> On Thu, Aug 27, 2026 at 12:51:20PM +0200, Norbert Szetei wrote:
>> rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the =
MR
>> by lkey and hand it to rxe_odp_do_pagefault_and_lock() without =
checking
>> that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, =
and
>> for a non-ODP MR mr->umem is a plain struct ib_umem from =
ib_umem_get(),
>> so the container_of() in to_ib_umem_odp() lands past the end of the
>> object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp =
fields
>> out of bounds.
>>=20
>> lookup_mr() validates the lkey, PD, access and state but not the MR
>> type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.
>>=20
>>  BUG: KASAN: slab-out-of-bounds in =
ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>>  Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
>>   ib_umem_odp_map_dma_and_lock+0x884/0x8a0
>>   rxe_ib_advise_mr+0x543/0xad0
>>   ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
>>   ib_uverbs_cmd_verbs+0x2b3c/0x3b20
>>   ib_uverbs_ioctl+0x1e3/0x310
>>  Allocated by task 921:
>>   __ib_umem_get_va+0x13e/0xae0
>>   rxe_mr_init_user+0x2ae/0xb00
>>   rxe_reg_user_mr+0x337/0x510
>>  The buggy address belongs to the object at ffff88810a3ebc80
>>   which belongs to the cache kmalloc-96 of size 96
>>=20
>> Reject a non-ODP MR after lookup_mr() in both the synchronous and
>> asynchronous prefetch arms.
>>=20
>> Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for =
ODP MRs")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
>> ---
>> drivers/infiniband/sw/rxe/rxe_odp.c | 11 +++++++++++
>> 1 file changed, 11 insertions(+)
>>=20
>> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c =
b/drivers/infiniband/sw/rxe/rxe_odp.c
>> index e870efa7a0a3..5c9dde3501a0 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
>> @@ -472,6 +472,11 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd =
*ibpd,
>> return -EINVAL;
>> }
>>=20
>> + if (unlikely(!is_odp_mr(mr))) {
>> + rxe_put(mr);
>> + return -EOPNOTSUPP;
>> + }
>=20
> The idea is correct, but the implementation needs some improvement.
>=20
> RXE stores the access flags in the MR, including IB_ACCESS_ON_DEMAND,
> which indicates that the MR was created as an ODP MR. lookup_mr()
> should check this flag and perform the lookup accordingly.

Do you mean lookup_mr() should take IB_ACCESS_ON_DEMAND into account, so =
that
the existing (access & mr->access) !=3D access test rejects the non-ODP =
MR?

rxe_rereg_user_mr() with IB_MR_REREG_ACCESS assigns mr->access directly, =
and
IB_ACCESS_ON_DEMAND is part of RXE_ACCESS_SUPPORTED_MR. So userspace can =
set
that flag on a plain MR after registration, without the umem changing. =
Am I
missing something there?=20

Thanks.

>=20
> Thanks.


