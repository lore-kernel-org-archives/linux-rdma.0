Received: from smtpout8.mo540.mail-out.ovh.net (smtpout8.mo540.mail-out.ovh.net [51.210.91.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EF319C54E;
	Fri, 24 Jul 2026 05:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.210.91.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870094; cv=none; b=SLlM08XRAhK/9ncsEyLwrJ0az8HKwXokgV+QctxsH+kaIndOWXVz/xpshGpkvRRP8oxoNdytefFsBuMDE7+TWyaYZY8XpSBDXOURdPv/v0zA8jg1PRL+WY9HyULgSvId0tulyQlWE4IWrpWf9EcXupuVp34vVk7/AdpeFb0mgRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870094; c=relaxed/simple;
	bh=EyWJn59wQcFbSzsRuRIoBjW5HvFBbWAb0NlB/0oNbJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LeIudnBTTfgg2IEuyHpFy7Rn4CxNpJoleTKMdGaLyAz+pRmp9oy9dMHKivkYbvEEzO2jttLBFqK68Hk6ScKChUoi3f3sagYilfEM5/aLTL3RHCAOpOdRWUrnf9K7t986XL9k6FU9ORnFEP8iXECQmcUyEq0VYcgGUXiuFXKhrN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaod.org; spf=pass smtp.mailfrom=kaod.org; dkim=pass (2048-bit key) header.d=kaod.org header.i=@kaod.org header.b=Jrl9vdmH; arc=none smtp.client-ip=51.210.91.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaod.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaod.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kaod.org header.i=@kaod.org header.b="Jrl9vdmH"
Received: from director2.derp.mail-out.ovh.net (director2.derp.mail-out.ovh.net [79.137.60.36])
	by mo540.mail-out.ovh.net (Postfix) with ESMTPS id 4h5wfY2K4qz3wbY;
	Fri, 24 Jul 2026 04:55:33 +0000 (UTC)
Received: from director2.derp.mail-out.ovh.net (director2.derp.mail-out.ovh.net. [127.0.0.1])
        by director2.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <gouhaojake@163.com>; Fri, 24 Jul 2026 04:55:33 +0000 (UTC)
Received: from mta2.priv.ovhmail-u2.ea.mail.ovh.net (unknown [10.110.101.119])
	by director2.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4h5wfY0fFRz1xp5;
	Fri, 24 Jul 2026 04:55:33 +0000 (UTC)
Received: from kaod.org (unknown [10.1.6.3])
	(Authenticated sender: clg@kaod.org)
	by mta2.priv.ovhmail-u2.ea.mail.ovh.net (Postfix) with ESMTPSA id E5285941A0E;
	Fri, 24 Jul 2026 04:55:29 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-101G00445b33efe-36d1-4677-9dbd-4ef779dd762a,
                    4BD6B7741D2B27CC5BC6F5428A99E4613CF72FD8) smtp.auth=clg@kaod.org
X-OVh-ClientIp:82.64.250.170
Message-ID: <87ff73dc-3d4b-400d-93f9-f9640c5196a6@kaod.org>
Date: Fri, 24 Jul 2026 06:55:29 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
To: Gou Hao <gouhao@uniontech.com>, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, chleroy@kernel.org, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
 bharat@chelsio.com, jgg@ziepe.ca, leon@kernel.org,
 akpm@linux-foundation.org, namcao@linutronix.de, ynorov@nvidia.com,
 sshegde@linux.ibm.com, nilay@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-2-gouhao@uniontech.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Autocrypt: addr=clg@kaod.org; keydata=
 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
In-Reply-To: <20260724022851.466017-2-gouhao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 17313244342570036456
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTFag79TUuknUcEyJ+fUBsqHM0xcaveY2xgVNjxV+qnKwhwsNTHa/2zdKcagVjzZotwGF8tiTuYDFnLfCREPZ40TItmps8VQlgCYXtQ5s/8YhU27P1l3fNA5vFk0wHWnMhXlAGEERA1YXEkq6NvX3J7mbulyb4PCNyOiCS02W8K6KQos/fdl/UFRJLB+bcrtLX5zpkrqLCS8UVIBGkLg2pXo1dt253286tHqmpjN4aJU4Momxnq4NCIh4qjGOU8oLxiXXbSRp93kS9K9HRz8GsPUGJVR2g6ypPWuPrcsxVVwSadqKe62E2LhGeYWeQK5G59ftKSi6eFNdIHZZqSwCU/JZgUTU2jQdp4fspPo3fPc+HP2egDV1EgUQzjxFw2a9A0wMtH5xWzPjQWRAF+Sg635i6W7cB4f3mMjRG7+yRxV1dsUXEG767heBlRrqZr6fLWKRZ+fvtQ5LVaoEnlx6Ht+BxYS5/Z/50NYJvsBrzTkngXeqe90vtZ1wS+mqVfi6dyIM27fChLynqPhuW4tfkFg1Zo6miZLGXX8BLGGc5mbauuAe2273a3bCM3BX1Db9UaW0FYe2HqxNXCA1Q8gEfl4x7UOC3VeJlgqD6btGHUq+zVcARFFkfqSmP+dxy3oGOa4myNk+cI0ojqOw3aWmNQLUXW6yG3Pgeys3eP+VZywcw
DKIM-Signature: a=rsa-sha256; bh=McrFHMF4OqCuGHN2JECR9Xz9tBdtSI1b0xMZalX69Vg=;
 c=relaxed/relaxed; d=kaod.org; h=From; s=ovhmo393970-selector1;
 t=1784868935; v=1;
 b=Jrl9vdmH9ieiS5O1IR6RPvsCe6nbV3My+drtWyHnNimGFqNrk9xS2t6F95Jp0+/mkGW4lTra
 cNzcfHHg7EGzqFY4EFcUh5r8PatIIQhwDgODODrVtUU5dvrhViZSZmFI5ZJUQk8JXOGeT3MVtZ4
 wdkhxLfIBDmVr35+w4fSRxa3tXVAwqP+BH+AyElt9BhcL7dfy4CnObRW2j+pmVdgdv/1ZEg7tcM
 TnFasx/O4qYkAlFPqI+/2Li99Y7zDe9YY6qguVGd7xbWnBaKFte7zDOEVOCEM1znrzZbpR25eBL
 aaba/1mL1nEGtRW+y/gGaprznU29+DYZC1c9dCahQ7SjQ==

On 7/24/26 04:28, Gou Hao wrote:
> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent NULL check is unreachable dead code. Remove it.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>   arch/powerpc/sysdev/xive/common.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dadd1f46ec939..f2904a5c2b7bf 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>   
>   	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>   				 GFP_KERNEL | __GFP_NOFAIL);
> -	if (!xive_ipis)
> -		goto out_free_domain;
> -
>   	for_each_node(node) {
>   		struct xive_ipi_desc *xid = &xive_ipis[node];
>   		struct xive_ipi_alloc_info info = { node };
> @@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
>   
>   out_free_xive_ipis:
>   	kfree(xive_ipis);
> -out_free_domain:
> +	xive_ipis = NULL;
>   	irq_domain_remove(ipi_domain);
>   out_free_fwnode:
>   	irq_domain_free_fwnode(fwnode);

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

