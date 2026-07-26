Received: from smtpout7.mo536.mail-out.ovh.net (smtpout7.mo536.mail-out.ovh.net [51.210.91.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BEE20E023
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.210.91.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785098607; cv=none; b=WjZ/p9AVrXJFnabfnswv2T1sY+100ORF4SxzgJR45GoiAniW3oI4ui90zq+suyvidtRZJ6WyRSksp0GihWFWK/6kqTjuh3LhD8WMylSZL37ih5Wx2yKuxhT+9aNrcx/Jo0wyr6atVlK75TEfziFtAZw0OjST45FUmLQrm1BDsNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785098607; c=relaxed/simple;
	bh=PIw86sMw87bLkQDnXpm6ZwvgYZOT5Ly8Y+fjs9pl5xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hemVe7tD07fLbbA0Ia7FkiI93PQhOOPCFA2vpCtgg1wQiX4bRlu+TKPwS3HN4FE+xe9lovbdNpDW9a10jZ9v5JwdbQtulN9b/Tc/F6vQqpp9e5TnmGUnZ8r5AS2MDUTA6F6iENMKTlA4/qkBD4KLR16hoiyh8OC3D+5lLj4ij48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaod.org; spf=pass smtp.mailfrom=kaod.org; dkim=pass (2048-bit key) header.d=kaod.org header.i=@kaod.org header.b=X8S4U0su; arc=none smtp.client-ip=51.210.91.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaod.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaod.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kaod.org header.i=@kaod.org header.b="X8S4U0su"
Received: from director3.derp.mail-out.ovh.net (director3.derp.mail-out.ovh.net [152.228.215.222])
	by mo536.mail-out.ovh.net (Postfix) with ESMTPS id 4h7Skj5WHwz882D;
	Sun, 26 Jul 2026 17:04:29 +0000 (UTC)
Received: from director3.derp.mail-out.ovh.net (director3.derp.mail-out.ovh.net. [127.0.0.1])
        by director3.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <gouhaojake@163.com>; Sun, 26 Jul 2026 17:04:29 +0000 (UTC)
Received: from mta6.priv.ovhmail-u2.ea.mail.ovh.net (unknown [10.110.113.67])
	by director3.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4h7Skj3KCsz5vVC;
	Sun, 26 Jul 2026 17:04:29 +0000 (UTC)
Received: from kaod.org (unknown [10.1.6.5])
	(Authenticated sender: clg@kaod.org)
	by mta6.priv.ovhmail-u2.ea.mail.ovh.net (Postfix) with ESMTPSA id 1B6971B43E36;
	Sun, 26 Jul 2026 17:04:26 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-113S00762e22185-7b9b-497c-96d9-2cc2a26698c9,
                    31B54A7FFB7E7F23FF6B7C3EC947DBF3CB6BDBDE) smtp.auth=clg@kaod.org
X-OVh-ClientIp:82.64.250.170
Message-ID: <3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org>
Date: Sun, 26 Jul 2026 19:04:25 +0200
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
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 4475733607526477032
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTGNUD/+lU0f0AV58YzXXMeoOgI7stSGyQnUCLQTWUGjvNOg7AleMWmlvL1AgQx1M8wgC4bgr4szg237ncgeIJDZ+21t72QULiNJxfn2ypx7ESKEsDkwNFT/KaG9Ou7F0gvqmqmBLNrdtJYzZ5qYhgWsWla08Bseg7Xpkrjl2p87WGeplH4EpGCS7dYfqmI6A4lpi95O5qDCkRRoUs+EC5jWqJtM5uXWan1v5qA9NCCgpHlrxvVPRY7Hn3DhdZQkZBaKYFg8zO5LIeckwhiTW3SMxEetii9yfr/FEhXMld9qH/YNBJX3hjNDYQS3sLkToe0EYHV/9JXljOdtYCbLlneQsR753AUr41RvRhFyKctvwNr5F/8/J+qsTGI811PHLMmU6RT/F3iIBgfpZqOi/nE1UYWqXM+csgHmgyhyNwBAMZkx985ViqOvuDuzcKc7BrzavCKYN5G7vCktO/8OtEvXjog9mo0c80sGwGWtb77aSHBWMO/6cnc0EQcHiZ09CB8m7Qr+m356rRbZ5fZ3mgsc+FoQ+OJa01Y/JAKiMNwEj1BCazbU2BlmWcn2PSy3orIRTkrRc5MrKlxCQm1N0LAm+lIESi8/BJg470MxPPNAKCuBdEU5nLIOt6TX+rW+Vq+qtAgW/9XKopwVq3TswU2qAmS4mQtnZ00WKCxyZ7e7ow
DKIM-Signature: a=rsa-sha256; bh=krixYWDv1svSaZWzY29VuHk3LCe+gkNbeFXejSkZhpM=;
 c=relaxed/relaxed; d=kaod.org; h=From; s=ovhmo393970-selector1;
 t=1785085472; v=1;
 b=X8S4U0suPQzDD/KTpp4BPSUm520wFOWzHCIbmVCsIfU9YnZrdvOnYdVxVlsjZYrWga7m0RiF
 UXz4Wi8pMb61wLgCH6NIsLfxzBeISoZ9Eef4QFayBeUXrLRIxR53tyZgbfujWbBWqCfQQVATZ4s
 yxatMiRgJNvxPshv40aYCD2TTWCGZnGHRXiWnwosQbaFIO91NQ8X0xYRrD4e5pfUfTtapXZz3JV
 8zZdj2lkez1xd0y1xOKj5iOWLk6jcfsbN4qcu7bdzysdRqHkqG5qTcpAg8EznPMWzgggIEW8UGo
 /OFvB/Y3d05Pku4dsMx23lBWaUzFUq+HhW/f95+OaHcHQ==

As suggested by Andrew, let's change the approach and remove entirely
__GFP_NOFAIL instead and make all xive_ipis access paths NULL-safe.
   
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

So let's remove __GFP_NOFAIL here.

> -	if (!xive_ipis)
> -		goto out_free_domain;
> -

Let's keep it now that allocation can really fail.

>   	for_each_node(node) {>   		struct xive_ipi_desc *xid = &xive_ipis[node];
>   		struct xive_ipi_alloc_info info = { node };
> @@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
>   
>   out_free_xive_ipis:
>   	kfree(xive_ipis);
> -out_free_domain:

and keep the out_free_domain label

> +	xive_ipis = NULL;

and yes we should add 'xive_ipis = NULL;'

>   	irq_domain_remove(ipi_domain);
>   out_free_fwnode:
>   	irq_domain_free_fwnode(fwnode);


The prepare_cpu() path is broken. To fix, we need to check xive_ipis
is not NULL in xive_setup_cpu_ipi() and xive_cleanup_cpu_ipi(). It
should be a straight forward local change. Nothing complex.

You can test with QEMU. The pSeries and the PowerNV machines are well
supported under emulation. Ping me if you need help.

Thanks,

C.




