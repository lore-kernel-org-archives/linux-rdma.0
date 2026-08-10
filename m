Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C6E41168B
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387036; cv=none; b=hvGXfQZwbBE3jWCPcP8CHxH0lcsl2Jzp0QXItmbdp/JcnRpoZTsn6LV8LGKlh0reoIWXeVFFxujxOAQ4dr4dG87omkdPCUO8KHs57AhsHSyb03i6tO8X7Q32sUTEtoW1V+fKBCdjfMPaIdWYU3LMeoQaGsUgW7F13AVzJIbMQVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387036; c=relaxed/simple;
	bh=Dz6Qsot2SU7B95sUlmyWQ4TdBsOQoQx9SDikcWHPffQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mObeJj5dPPi51LGTT4xU4XHI4+U4Hi9umInKeYFppZh0o9HZ00lVFEUHQmmadmIxp6c2/xsbtPLUNSs/T6DkZhu72HVyxbzCwz6akSJgw2/XjufFdV0Ve/dQLT7GC2VF/i0N32rJwJl+ZV8SDl7k+tZ8VbL8qt5rO84UaycMju0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DYvQpRJE; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DYvQpRJE"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-52cd38ddcdfso391091cf.3
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 11:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786387034; x=1786991834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=31I5Z0z6XfCjO4jLyi6zpb2MIwU/XAG3ALUf5bLfw6c=;
        b=DYvQpRJEHBofBvzkMHiB0X1ZpazH5DeLpUyVxuhb1maR9+SD6bqq152mXVU6w89bpe
         5FwrkvUDYoxDeOFtlcWxCQS76n7ENTbyS0GS7JIzZ6JA1tsFcRro2cWYdacRidGukDuA
         kg7AfA+A9RM/WV1bJeO5TQ+D9qBf8lfCyw4sb9VxfIXOUa6J1U0QfqoLiw95Q+eU8XWR
         6qWE9lDHklp3F8J4nToOMRyTVN31tH2NKJgNxhd9K5AFEMP+CSk9J9XA3+4/Ou0v6mVN
         H3YEo5pAb1jiVYGgZe0vNNL3JnpMk1zc5P+y5+WQysAAdlOb8y8KltDz1l4tyyHQOaVX
         9jYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786387034; x=1786991834;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31I5Z0z6XfCjO4jLyi6zpb2MIwU/XAG3ALUf5bLfw6c=;
        b=Z+77Tc42zJmxlZ9hxw8S2wD+DvHVuprAPa9ffTyyHoYggGWKBLlGxXRTU3lB8Aqeyr
         X+3mR1I7ShduZ0XaAycI8yOM/asfktJzycgdDNtD+LhsEXMfW655TrHIhNJ4d+FBFIXT
         OnG7ooEQUxvg562OZODmI7/E+cL65AMkRyUvrD7Z96G1QsyX8Bwx+C6GyeY5cO8T2eGk
         GkLyduZzStRqwDWOLmYjAa1AY2afLd6G6RvkfBz2PHLsvlRr0fyghkVBC9p/DYoYGKBq
         k5Wz72Jt1oPaCfZpgLlLxcqxQOfOx01ISIE5MpJIPtD81Vl+ONo6jCObD3hz6df0TbTY
         eHVw==
X-Forwarded-Encrypted: i=1; AHgh+RobfV8IYZHNVIFel3w80ssJC0O6xa9Qopu8GCxHQWEHNp/qlFv7+CqLk06SKpdzzR/QZI+Lq7KHJApR@vger.kernel.org
X-Gm-Message-State: AOJu0YypUiH6SogsFLMm/sSdJgcvQ6qYjIyGPJ3VoQXaPOxwDkH56Nrq
	3ecXU5o12nOqWwxOcprVzY3sfPrRcqunfRCI4KwdV2Yi4VU+3juO5+18fUtBgAwFGvCQmIYlhEf
	UViNj
X-Gm-Gg: AR+sD128x/kkAsfcgZvNUN++IpPuuoSzsdl8CZSznpa57j/+SFfyBtiCPbMQ0OUm9EI
	emu/URdAtJ4NNPYd5c8x9PJVdqXompG53XyEPBHzH/GVd6NMCvcyxW1q6keboSxrp0nlHIKSZsP
	H7DTJqadm4RdPv/DOIS5SmuHtvS0QStWOpby+ahDpwwbbmRb0/wRA8DCQ8uCd96t2A/3NdAWnH7
	2ictIJ0RqQCs6uNzKxqdke7s5NJ/tTKq+k9uS+FQg5xdjLvnPpAhyRSC0TNuMA603SJ65tIVhSB
	I59ccwEwIhk2n8vuVjbaP+QNziYZxJeZ2IeAbCxE2UycjIwkRHESpUUQMfCbirbQA+yM71c3g3m
	FrKSr04jYqLAcADvNImtY0hP6W3NWZY3xkkzNMKaO9iF3jcffeRm9rRrPo/VhbEzpPYKHDi2L49
	6m45ZnlhnizNI4yRKZ6K0Bcs/FPFO9LJv11IdVPA==
X-Received: by 2002:ac8:58ce:0:b0:528:162e:29d3 with SMTP id d75a77b69052e-52ce614ba88mr456019791cf.32.1786387033924;
        Mon, 10 Aug 2026 11:37:13 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d16337589sm77461961cf.6.2026.08.10.11.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:37:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtUs4-00000002Adj-3AYL;
	Mon, 10 Aug 2026 15:37:12 -0300
Date: Mon, 10 Aug 2026 15:37:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] RDMA/cma: Fix WARNING in res_to_rt
Message-ID: <20260810183712.GC507588@ziepe.ca>
References: <20260810015357.23724-1-yanjun.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810015357.23724-1-yanjun.zhu@linux.dev>

On Mon, Aug 10, 2026 at 03:53:57AM +0200, Zhu Yanjun wrote:
> @@ -3531,7 +3531,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
>  		if (status)
>  			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
>  					     status);
> -		rdma_restrack_add(&id_priv->res);
> +		if (id_priv->id.device)
> +			rdma_restrack_add(&id_priv->res);
>  	} else if (status) {
>  		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
>  	}

The full text is:

	if (!status && !id_priv->cma_dev) {
		status = cma_acquire_dev_by_src_ip(id_priv);
		if (status)
			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
					     status);
		rdma_restrack_add(&id_priv->res);

What it is trying to do is fill in cma_dev/id.device (they are
linked).

'if (status)' means the resolution failed and the cm_id is not
populated, so it should just be if/else instead of trying to check
id.device

But this does seem to be the bug syzkaller is pointing at, but the
commit message seems really strange.

If status is !0 then we know id.device is NULL and we cannot add this
to restrack. Otherwise it must be !NULL and it must be safe to add it
or we have a locking problem.

Jason
