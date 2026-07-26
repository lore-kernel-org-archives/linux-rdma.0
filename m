Received: from smtpout2.mo538.mail-out.ovh.net (smtpout2.mo538.mail-out.ovh.net [51.210.91.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA151A0B15
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.210.91.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785086198; cv=none; b=AHh42tCFHyyuisKMJg/N1wsOhWcnB5TaYDfBTgiEsWzX/4RzI2tOzNT87Sd60iRQvlUiarkKzrhnqMJXNmAF21cBjsk75/P0MoPs6FY2vDDfVfC+04lul7ombSYrjJRusf94UJCQh37KqMHjXdcqzOkFkQSCDw4gcf+g5/9nR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785086198; c=relaxed/simple;
	bh=seuh6YZdSRuqL+aXTRmPSnX5g/1fzoRKLSwkpLvLetw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rEqJYou9j1nLnnAwQpnjSdT2PTxoZt1KN3qXaXBe2/aWdzj++nBrxTxqtF0YWc6DzGfIUuFsKcwYyVM/kPagEDrS+frdTHNztdrS0g89zW6shjo0ix9bi5LKtcOPfh6pfSorSIKLj8bpNQGDUHwXQdchGJZJNTykzhbF8Z/06qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaod.org; spf=pass smtp.mailfrom=kaod.org; dkim=pass (2048-bit key) header.d=kaod.org header.i=@kaod.org header.b=pO2ygG3O; arc=none smtp.client-ip=51.210.91.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaod.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaod.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kaod.org header.i=@kaod.org header.b="pO2ygG3O"
Received: from director1.derp.mail-out.ovh.net (director1.derp.mail-out.ovh.net [51.210.158.128])
	by mo538.mail-out.ovh.net (Postfix) with ESMTPS id 4h7SZP1B6jz6GZp;
	Sun, 26 Jul 2026 16:57:17 +0000 (UTC)
Received: from director1.derp.mail-out.ovh.net (director1.derp.mail-out.ovh.net. [127.0.0.1])
        by director1.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <gouhaojake@163.com>; Sun, 26 Jul 2026 16:57:16 +0000 (UTC)
Received: from mta10.priv.ovhmail-u2.ea.mail.ovh.net (unknown [10.110.188.121])
	by director1.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4h7SZN4q0Bz60Mc;
	Sun, 26 Jul 2026 16:57:16 +0000 (UTC)
Received: from kaod.org (unknown [10.1.6.3])
	(Authenticated sender: clg@kaod.org)
	by mta10.priv.ovhmail-u2.ea.mail.ovh.net (Postfix) with ESMTPSA id 8E1C11923E00;
	Sun, 26 Jul 2026 16:57:13 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-100R003d6fbf843-6826-49c1-85f4-e5f44afdaee1,
                    31B54A7FFB7E7F23FF6B7C3EC947DBF3CB6BDBDE) smtp.auth=clg@kaod.org
X-OVh-ClientIp:82.64.250.170
Message-ID: <518d7bc3-06a5-4afc-8d40-5cf6f538c402@kaod.org>
Date: Sun, 26 Jul 2026 18:57:13 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] powerpc/xive: fix use-after-free of xive_ipis
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
 <20260724022851.466017-4-gouhao@uniontech.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Autocrypt: addr=clg@kaod.org; keydata=
 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
In-Reply-To: <20260724022851.466017-4-gouhao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 4353854940871437544
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTElj8EdMObDu/kTnUp4apBD75PFPnpQg7NK68v/jHHR89xrg/xRx6yL7/M5JszXyamJKVqXasWixZpg+jG5pUnq2FJQf3RcH/p7BKF9ShGlxlpKb3medBYbwthOHi6WsKyEAUII4SyASMtTZ67ElEmVWlENG6n9/a9Xy2ya7vcBVw8XB9wVn4imkDjuTq6JWRHyLfhwScsQhrHfaxNwybRQY2TYKagJKm/0LjebKQNrDxRvOJTt3x1m+Q96I2WYaK+roFi2QVhsaL+TOm0mxD0rN7fdAcld8gqKDR8O0FAZfQq93UO3beSddZOvIXhUq/Du8CZbFzlxVR1/YoZGE97eAe1nD/pvpp/H9wjYlmpd6En5TEwzRgHnwgA0hn4jZxKIwAZl1a2WuQm9q6Ajq6t/2pISIXe8NrYhNveZxkW5AmvJ9PA7UsRYqILeFJa4l/t+ziBmkl2C3mhB9K9WBgl028n0/N/mogcwCkGh9Dohg09N9e/NkWowVYe8bXOADLN+Ehv2sOxfFwCb9C5r/If3VHWeZdfCtqtV4oXnzqL52JTOrcYLCZQRwcBSYfVag5LP9W6Kq9KTyBusOQMf+Lzj07P9l8h4R9C/uaJKnLf9IWEigh7DrBb8Y+NbF9hrvtCeJQ7PzrWJPe5j7JV4mg8NOfRjA1xcvX2Fs8q1ysm3cA
DKIM-Signature: a=rsa-sha256; bh=leejA4oXNKzlCWvwsksqJsxtR+ZVpBQOirzyOlDDiHc=;
 c=relaxed/relaxed; d=kaod.org; h=From; s=ovhmo393970-selector1;
 t=1785085039; v=1;
 b=pO2ygG3Oy8MBfiWrP1EukCLQ33a59NiKcul5zOMyXuQbsm5GLsEiJCxoLEb4hFA4eaDGCFxC
 r3qr3Zn1XUrKX5VY9IdN8AhewaV1axthkVBO7D2sxIJVIJJ7yxpVCpueehGbUL5B/6o1WhzKlo4
 GtM+3XgyHYfY3bJJTGhXRGhcJMlzbRYpq7EU9WgReJpKgmAN+H6judUya9S0BNHN9V48ghl+p8q
 k+j0li5RJqNkXRzBfqqm4rg/MJP1WeNA3JkjJaGzaXwRuVS3+IBiUNfvVc3qgN976jtcMaaGlLy
 y2pKYNDOuzw5FfcvM2dxM13TPgvLPaJXLBka1twHqaYwA==

On 7/24/26 04:28, Gou Hao wrote:
> When irq_domain_alloc_irqs() fails in xive_init_ipis(), the error
> path frees the global xive_ipis array via kfree().  However,
> xive_smp_probe() ignores the error return and proceeds to call
> xive_setup_cpu_ipi(), which dereferences the already-freed xive_ipis
> pointer, resulting in a use-after-free.
> 
> Propagate the error from xive_init_ipis() through xive_smp_probe()
> and check it in both pnv_smp_probe() and pSeries_smp_probe() so that
> IPI setup is aborted cleanly on failure.
> 
> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>   arch/powerpc/platforms/powernv/smp.c | 8 +++++---
>   arch/powerpc/platforms/pseries/smp.c | 8 +++++---
>   arch/powerpc/sysdev/xive/common.c    | 6 +++++-
>   3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
> index 8f41ef364fc6f..b1201dbafcaf6 100644
> --- a/arch/powerpc/platforms/powernv/smp.c
> +++ b/arch/powerpc/platforms/powernv/smp.c
> @@ -332,10 +332,12 @@ static void pnv_cause_ipi(int cpu)
>   
>   static void __init pnv_smp_probe(void)
>   {
> -	if (xive_enabled())
> -		xive_smp_probe();
> -	else
> +	if (xive_enabled()) {
> +		if (xive_smp_probe() < 0)
> +			return;
> +	} else {
>   		xics_smp_probe();
> +	}
>   
>   	if (cpu_has_feature(CPU_FTR_DBELL)) {
>   		ic_cause_ipi = smp_ops->cause_ipi;
> diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
> index db99725e752bd..14cd0634eeca8 100644
> --- a/arch/powerpc/platforms/pseries/smp.c
> +++ b/arch/powerpc/platforms/pseries/smp.c
> @@ -194,10 +194,12 @@ static int pseries_cause_nmi_ipi(int cpu)
>   
>   static __init void pSeries_smp_probe(void)
>   {
> -	if (xive_enabled())
> -		xive_smp_probe();
> -	else
> +	if (xive_enabled()) {
> +		if (xive_smp_probe() < 0)
> +			return;
> +	} else {
>   		xics_smp_probe();
> +	}
>   
>   	/* No doorbell facility, must use the interrupt controller for IPIs */
>   	if (!cpu_has_feature(CPU_FTR_DBELL))
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index f9a1229cede73..bb6ce07c1699e 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1256,10 +1256,14 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>   
>   int __init xive_smp_probe(void)
>   {
> +	int ret;
> +
>   	smp_ops->cause_ipi = xive_cause_ipi;
>   
>   	/* Register the IPI */
> -	xive_init_ipis();
> +	ret = xive_init_ipis();
> +	if (ret < 0)
> +		return ret;

the cause_ipi handler assignment should be moved when we know
IPIs have been allocated. Here :

    smp_ops->cause_ipi = xive_cause_ipi;


>   
>   	/* Allocate and setup IPI for the boot CPU */
>   	xive_setup_cpu_ipi(smp_processor_id());


Thanks,

C.


