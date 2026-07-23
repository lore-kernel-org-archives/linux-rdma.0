Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB9742FCD5
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 09:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799477; cv=none; b=a4P74OgFkz44hWBXf9H9vxx26g+pNp9ZyF4Mr6bgD/9OCAobEde7gAiQnsWCDX7xU6xWLh6gBbe8hGr0Fx1TGo5Xa0UXkgqbzX7l4Y2dLbsXm9QBgG/rFUmCc1ReXB8EyKmXhGs5ma3ydERX8c7NDi9JG098B6ByZvgQoY8LTzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799477; c=relaxed/simple;
	bh=2fdT66frmU5HRHMGffMmb4EgPhSorO9daKfDbEEr1r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4LbMcvCXQCZwbmpzIdHAiaaPgDDMT2ZGxGnM1APAKO92zRjDhaBY40j6Dofm57wm90WJXh6L/vEjLV2+ZjMERUutvYltjWx8zqnH1ZHUzJQxKiSnTg3E/gfazIBi5k+3YzOoAd77Y66bNJYuLIf/z160mgf9lOpZpKOgA2LCIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/Y5I8OA; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/Y5I8OA"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8487214ad2bso587606b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 02:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784799473; x=1785404273; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oPUgpb0frsnp1JVUTki2lmBuU8fGYW5E1pXwN+DTdbc=;
        b=Y/Y5I8OAwXbJWOHxWvVFZM7yWGWNZPdpik0kP9uldqkz1kQSmS2ds9Hq44Fb/v+ngl
         mmhwU6d3QBgeSidrD4N0HR/tont8Fyu/JHZ4hcXDbuka1YMzkYTnwLj04I3cSvLhNioa
         y2QYlFcfGsR58OHFASltkyhBgCK3nAdWKH7BNPMUwCzJ3uIbBRdghnzLYmDYfD/4bkUW
         /9kS8uTpYQ9fZIDguizijrjT1kfU2v8FEBkfOWUeRnCH5ywFDLN0cTT8FmTbOgyRaWGt
         umIr3Fc6jxqvDfDDGVuiA6kK79xoaYL67HqE7Jf63cOlQw+fLT3lUqmAVqx1IjoSRTC2
         M+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784799473; x=1785404273;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oPUgpb0frsnp1JVUTki2lmBuU8fGYW5E1pXwN+DTdbc=;
        b=tYvdezjqcAintB9vjH1BeesMzVjv4ZwKDBTChjDd47TC9jFu3l7UdBfvTI5GXfUw5N
         9bQ9GM76S9XOle2jOPshyCjzNKtlpBRfaXjsMkbkK+GsOMboG2UtBSlg5P1jXR8wtc3n
         5rBidMKzMLQX17HhK6CBqOZCJOosbkVozf8QnU4bE2Hr4PCO6yiFPtAWrKRC5VCI/cjg
         NK1sl9gjotWLpHX/KlsKjJ5AepwBh1FrklOIMzE55e7KqVl06AkL0/KSeEkHbx8UABBH
         f/GHAvBAVndE8Yc+4Kq99hs6pFg9wAoG/Huf7Xo6pSahyeKIPKfTSjPN6OjmuvoNuoE+
         ITiA==
X-Forwarded-Encrypted: i=1; AHgh+RpU1Tjj4E9nFodd1cdaCxfgIQ1oC0Vi6uqiAXocXQQasEXe56MU+AFZRncIxVhSyvNvIN175m4V4M85@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7iylYhSu7o3mn1oJ9AfWQhxMa6708IXVblchoTpeWr8Fw8X9O
	LKSrrA/ct36EtFzu1tIM5DzZuU5ymoBX4LrXtq9IOOxSV8D4CWI6s2xt
X-Gm-Gg: AR+sD124FDuekGxV+CH51ojJP2JR9T2s8gmZQj3dIUVfWCl+rFDFLPkraJjuZUQN09I
	a3hJ0RTFys8rKbLk/eWY7mW20yiAY4ZbtLvnAalfMpT0IBXALRC7qUWsKd7Tl0SUgsBd5SQNRrB
	tRtpBXnpvtS5sGz7Kg3zp/t55FJAumAx+9MNLJczhUnTw0T935aBfmvt2HSA8X1Wz6D/ksTufSC
	MLx74QZN8ItvSfkfYqJRYA8S421mPCeOrgIKcW9lUUYmmuEc3PU4SoJ40QDrxrvb4EA54+BWacC
	Dq1J2zxwmtz9lZHKYXplGzy4S4NxAV0uToMPzpb8gEmmakpT4ZAa8yUalZ65o6jHvfdEB84Q0cy
	sGuqgiabz8a4VK3px7NdLPcZMabdeboL9dc/zjha5uhxihsnZbGUZ5HZAXGcIG245hME5LzF02X
	RKXkhOPVjuKB21GL81QC/ZOTlYqbX/DYRqPC3Cj6LNgy+0xkER
X-Received: by 2002:a05:6a00:409a:b0:847:8650:69cd with SMTP id d2e1a72fcca58-84e2bd889a5mr3035099b3a.33.1784799472690;
        Thu, 23 Jul 2026 02:37:52 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([106.51.160.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e175d4133sm2738565b3a.50.2026.07.23.02.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:37:51 -0700 (PDT)
Date: Thu, 23 Jul 2026 15:07:42 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
	jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, ynorov@nvidia.com, 
	namcao@linutronix.de, sshegde@linux.ibm.com, nilay@linux.ibm.com, kees@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH 1/4] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
Message-ID: <amHgkkMT4nrWLSka@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
 <20260723081813.176792-2-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723081813.176792-2-gouhao@uniontech.com>

On Thu, Jul 23, 2026 at 04:18:10PM +0800, Gou Hao wrote:
> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent NULL check is unreachable dead code. Remove it.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>  arch/powerpc/sysdev/xive/common.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dadd1f46ec93..79d7854259cb 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>  
>  	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>  				 GFP_KERNEL | __GFP_NOFAIL);
> -	if (!xive_ipis)
> -		goto out_free_domain;
This will be an unused label after this.

Regards,
Mukesh
> -
>  	for_each_node(node) {
>  		struct xive_ipi_desc *xid = &xive_ipis[node];
>  		struct xive_ipi_alloc_info info = { node };
> -- 
> 2.20.1
> 
