Received: from mx16.kaspersky-labs.com (mx16.kaspersky-labs.com [5.79.125.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83687372EF6;
	Thu,  9 Jul 2026 04:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.79.125.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783573042; cv=none; b=giW9QNFkZu77Poe8QiYl0KHYHw2DnzYExqAJ6AADCOHjiOKM1J9QO4IxTtNdUl5WkCFjwo8jKjczcoe94SHYoushHWU/dZZ22JnvsMALx0sL3YcAXco2T9orYZIRczztz7+Srn5OfO2Fb12aO1fYEfxZE6OkhxFRBfqWxVXUodY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783573042; c=relaxed/simple;
	bh=HxaRDMzUZ/RHIuUSSpKMDl5km7BFTPcaVAFPcsi1i64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HylTXYA6OvWnZKvH1LRZ1QSAEf6TeOjDq8NLHwoSjwa4eRVdXigp9NKtFawqFWF0+DGqM86LRiiZvIfmjsqTz+rhCSwy+ajEvgXNCzG/FSHKubM3r8KY1YCi9wWwZ0/s8jek8YlmDdo30pwLtkoE8G00biphLM1VU5wWbb9nq3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kaspersky.com; spf=pass smtp.mailfrom=kaspersky.com; dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b=L+5Bhflr; arc=none smtp.client-ip=5.79.125.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kaspersky.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaspersky.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b="L+5Bhflr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
	s=mail202505; t=1783573030;
	bh=DgoIRpFL0iiNEErsG5uS2aVYFzKlyDs4j6hsYmGDLmA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
	b=L+5BhflrurTbXvEfXotduL1rIQjix2igM32E7caLBEMMs4b3+MZ7nQyeIZ5W1VOP0
	 2vRD47dvwwDOz11RzuHtPTuPIr/a93BnNjbpvQlW0sPI83kJI3C0t2biC8Kpz3Rhqv
	 Oa4tIvBKA/wYoZB/em2Uu5SlVC7/d9fABmfPT5tYJkqJIec/62FwAkBjfmuhJK/jBH
	 kwAzTba1h0EoH6DCvKdQQM/ppJEj2NdXnmOTfqdkLw4mIeOm3YZAwPOWh3B+As5wS5
	 lCZ3fR2BPtYMQ98oMz1jrYb4oHjGph79gpfMuqAaYT4dGDdYpJLvB4xiAWwqDrLc30
	 zM8GeGIgpjAOA==
Received: from relay16.kaspersky-labs.com (localhost [127.0.0.1])
	by relay16.kaspersky-labs.com (Postfix) with ESMTP id 1BC29C08890;
	Thu,  9 Jul 2026 07:57:10 +0300 (MSK)
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
	by mailhub16.kaspersky-labs.com (Postfix) with ESMTPS id 263C9C087CA;
	Thu,  9 Jul 2026 07:57:09 +0300 (MSK)
Received: from HQMAILSRV2.avp.ru (10.64.57.52) by HQMAILSRV5.avp.ru
 (10.64.57.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 9 Jul
 2026 07:56:57 +0300
Received: from HQMAILSRV2.avp.ru ([fe80::c3ea:4064:6675:4f29]) by
 HQMAILSRV2.avp.ru ([fe80::c3ea:4064:6675:4f29%10]) with mapi id
 15.02.2562.041; Thu, 9 Jul 2026 07:56:57 +0300
From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
To: David Laight <david.laight.linux@gmail.com>
CC: "xuhaoyue1@hisilicon.com" <xuhaoyue1@hisilicon.com>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>, Oleg Kazakov
	<Oleg.Kazakov@kaspersky.com>, Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Wenpeng Liang
	<liangwenpeng@huawei.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Xi Wang <wangxi11@huawei.com>, Weihang Li
	<liweihang@huawei.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] RDMA/hns: Fix arithmetic overflow in
 hns_roce_v2_set_hem()
Thread-Topic: [PATCH v2] RDMA/hns: Fix arithmetic overflow in
 hns_roce_v2_set_hem()
Thread-Index: AQHdDrs0kcJu1SYy8k2F9x5x497ut7ZjrCuAgAD0u6A=
Date: Thu, 9 Jul 2026 04:56:56 +0000
Message-ID: <24c0a3cf43074b37bb1c9c321a73f470@kaspersky.com>
References: <20260707140938.3106919-1-Alexander.Chesnokov@kaspersky.com>
	<20260708092146.3325855-1-Alexander.Chesnokov@kaspersky.com>
 <20260708181941.1ad1e112@pumpkin>
In-Reply-To: <20260708181941.1ad1e112@pumpkin>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-kse-serverinfo: HQMAILSRV5.avp.ru, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 7/9/2026 3:28:00 AM
x-kse-bulkmessagesfiltering-scan-result: InTheLimit
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KSMG-AntiPhishing: NotDetected, bases: 2026/07/09 04:16:00
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/07/09 04:20:00 #28429125
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/07/09 04:16:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 52

> When does the value overflow.
> Yes, the expression can overflow and the result is assigned to a
> 64bit variable, but I'd have testing this code would have showed
> the problem. So what is the customer visible impact?

You're right, there is no reachable overflow. In hns_roce_calc_hem_mhop()
the 32-bit table_idx is split into base-chunk_ba_num digits i, j, k, and
here they are recombined: i * chunk_ba_num + j equals table_idx /
chunk_ba_num, and the full expression equals table_idx, which is u32.
i is additionally bounded by ba_l0_num. So the arithmetic cannot exceed
U32_MAX on any real input - there is no customer-visible impact, and the
SVACE report is a false positive.

I'll drop the Fixes: and Cc: stable tags and resend as a standalone
hardening/readability change. If you'd prefer to just drop it, that's
fine too.

-----Original Message-----
From: David Laight <david.laight.linux@gmail.com>=20
Sent: Wednesday, July 8, 2026 8:20 PM
To: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
Cc: xuhaoyue1@hisilicon.com; lvc-project@linuxtesting.org; Oleg Kazakov <Ol=
eg.Kazakov@kaspersky.com>; Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>; s=
table@vger.kernel.org; Wenpeng Liang <liangwenpeng@huawei.com>; Jason Gunth=
orpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>; Xi Wang <wangxi11@h=
uawei.com>; Weihang Li <liweihang@huawei.com>; linux-rdma@vger.kernel.org; =
linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/hns: Fix arithmetic overflow in hns_roce_v2_se=
t_hem()

Caution: This is an external email.



On Wed, 8 Jul 2026 12:21:46 +0300
<Alexander.Chesnokov@kaspersky.com> wrote:

> From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
>
> If hop_num is 2 or 1, then the expressions like i * chunk_ba_num + j=20
> are computed in 32-bit arithmetic before being assigned to a u64 index=20
> field, which can lead to overflow.

When does the value overflow.
Yes, the expression can overflow and the result is assigned to a 64bit vari=
able, but I'd have testing this code would have showed the problem.

So what is the customer visible impact?

        David

>
> Declare i, j and k as u64 so that the address index arithmetic is=20
> performed in 64-bit.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: a81fba28136d ("RDMA/hns: Configure BT BA and BT attribute for=20
> the contexts in hip08")
> Cc: stable@vger.kernel.org
> Suggested-by: David Laight <david.laight.linux@gmail.com>
> Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
>
> ---
> Changes in v2:
> - Instead of casting the operands to u64, declare i, j and k as u64
>   so the index arithmetic is performed in 64-bit (David Laight).
>
> v1:=20
> https://lore.kernel.org/linux-rdma/20260707140938.3106919-1-Alexander.
> Chesnokov@kaspersky.com/
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c=20
> b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 1c180a6b1c07..3469a9a68d3b 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -4238,7 +4238,7 @@ static int hns_roce_v2_set_hem(struct hns_roce_dev =
*hr_dev,
>       struct hns_roce_hem_mhop mhop;
>       struct hns_roce_hem *hem;
>       unsigned long mhop_obj =3D obj;
> -     int i, j, k;
> +     u64 i, j, k;
>       int ret =3D 0;
>       u64 hem_idx =3D 0;
>       u64 l1_idx =3D 0;

