Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD44302767
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 06:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133013; cv=none; b=qqrM0GeLj2xIVbwawznS7iD/nYhYvWMhFRld5qlcLSPquyZjhFUBL/BksXFhkVUs52VX4L2MrB5eNnHLk2QxVqaFtRRgjAgM0I9k4OUbgRjt99PfWu3B6+S/3U1acDN5udSoJXPfTj3OV9hUXZQHcrvnh9OOW/z99B5Vtjihfmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133013; c=relaxed/simple;
	bh=qmQC6kIxbS00iWrncjl59RSApdzD8ekwSFlEE8CbY/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L89GTXYz97NU9YLmruHeWZdb5Y3HQtphb5XxQumV2lhqMJSuKjmYdoWYZKPVGKBL5bhRKXwQXZKzS1Eq7WErHYSb58+YVCzsrNnD3TYKRbvCPKr/SBaxaAZUEjmxKnYUR70fikE8LaZK5EGxgsxI79XvD0A7xmWN6wajuTrxVB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IO/SGV0M; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IO/SGV0M"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-845c92bc464so1708259b3a.2
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 23:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785133011; x=1785737811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xkvd3GaxfP8zwg2THjBwEOUnMuoDnas1hdLWEj3iqG8=;
        b=IO/SGV0MosA7ELRtt+dfTXjbvO71BVawdcZntgn/K2VS0pJWQ1tIiOelD/iWgHrNrg
         GYgJyEo179H41igb0Q5IdkQEaiGIgYOVhpY6FRDxTQY7Xv6+0BS53AToQMkZ0kLMUIZr
         x/2avPlMHAoZsRW+8qkYjMKUp+zoMOaqHFQU2Q1201gZwEdScLf86vNlYqy4iGUdTMOy
         q50Ly0j0lUnNHledGDFu8//dqqI8PV4GRBnhgIA1kv/ksZX+8EX286qdNRe3qawNQMSS
         7rQmaOgRgwTJOJwZzKtQdorb8XGHIn5KhBVkBks8mKMSxcE7p4tBHoJyGAqyqr37EBMe
         Zkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785133011; x=1785737811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xkvd3GaxfP8zwg2THjBwEOUnMuoDnas1hdLWEj3iqG8=;
        b=mYBiwCnZR5j4qly632CiXlVu45k6inD9GdOLIiRZMNNzZhtCy4+NU8kja/DyNFAFPC
         KKRH2l2UgaDLtFCvinQfillv7XphnQP4RXR+YydZIgpbiCG50XrInTXk0x5CU+zr+uoe
         /9JAZCCeDQaeD8lBdpu5TXxbnB/1JokgSDFaX1eI3oLckiAGbLdoCbA/yJmmoa9vSA98
         2N5Sm+/OB2lsIvj5jmn9cIRhCFuK+YjB4M6cjMfPBl7NTSqT1PGjgekE7UtLuxSsw0AF
         p3XHwD55gJysLnPKxCPHogBU4UR5sDunWGIrPvAvw9U12MyIV+MbZ11yGE9gNhPX0nR3
         XDcA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/BGSzvxUJvgxtovCP0b2996PoEC2M/wPTqaCOp7jlBIHQ3pHU0FwEd9GEd3aK8ILd7dfIV3CmwR5P@vger.kernel.org
X-Gm-Message-State: AOJu0YyRkurF0oWyYO6Id3tZQZRXux0JQ3WwVjjAcfAbkn6CUNFHFTIp
	bs+VHY2YquIrpcIcqz4McPb5lQCyQMMfJc5GJ3bP7D/waESzQ5kf7XEP
X-Gm-Gg: AR+sD13D1I9ugHGAYrNpddCpKchXpOZrGZ+YcvBX3NF/YvCiWxc1VW2b/6hjmmTF6u3
	56O5fjnXJlrI8bX6HiLVXE+CaOdaG0Zso2ShvLInO9rXQnuIk7FiOxHbfPehONq/zCbmFTDcO6q
	hGzgtFO4fylV6L3xJNdpaGWevHu1BlahiRW/jgTG3r9Teu8HEB7XmSzFbWtxorYW6PaIZ9uivoq
	zavlmcjtTLwwJA5SbFOn/uTQFrPTOf4oBbgSxMhvdF3ItrJYuIiDtMy8+/ot+WGIOSexix4KpgG
	FQodF9zZ/brbm4y5HDC6SLtQvgp28SHL59iyl6rTOwHj0eJiBgjokmgQjtqR6ju3bX5IYo/L7NI
	fmgzYrbOi156ndFbgdXqafna6S1fzxi4Lw+b2hvUd6Q+fLJ2UuI6++bzhbBbLNiT1IKiPgPEBFv
	xTBqeWYGFW9EDOUvZ5VKeiMc20OZ50fcuumAHOtvcD6XqIXg==
X-Received: by 2002:a05:6a00:4ac8:b0:84e:1db7:2f86 with SMTP id d2e1a72fcca58-84e59572bddmr5479084b3a.49.1785133011409;
        Sun, 26 Jul 2026 23:16:51 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5343a9c6sm2607131b3a.51.2026.07.26.23.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 23:16:51 -0700 (PDT)
Date: Mon, 27 Jul 2026 11:46:42 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
	jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, namcao@linutronix.de, 
	ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
Message-ID: <amb3uArRk2MlHRuc@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-2-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724022851.466017-2-gouhao@uniontech.com>

On Fri, Jul 24, 2026 at 10:28:46AM +0800, Gou Hao wrote:
> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent NULL check is unreachable dead code. Remove it.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>  arch/powerpc/sysdev/xive/common.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dadd1f46ec939..f2904a5c2b7bf 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>  
>  	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>  				 GFP_KERNEL | __GFP_NOFAIL);
> -	if (!xive_ipis)
> -		goto out_free_domain;
> -
>  	for_each_node(node) {
>  		struct xive_ipi_desc *xid = &xive_ipis[node];
>  		struct xive_ipi_alloc_info info = { node };
> @@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
>  
>  out_free_xive_ipis:
>  	kfree(xive_ipis);
> -out_free_domain:
> +	xive_ipis = NULL;
>  	irq_domain_remove(ipi_domain);
>  out_free_fwnode:
>  	irq_domain_free_fwnode(fwnode);
> -- 
> 2.20.1
> 
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
