Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794856748;
	b=u5E7uahmnr1UlZc+g724U5bHdxOsGTFBfucmTS/khfjlPYU7F1EtBZVoCx3earBSJGHh
	 y1ZuVfSYf+Az9QVc2/XqtiRKjIY41jC+nVJErJT3Z6bgNk0LUSosYAF5n7+/mzxhIMEgW
	 xFD4+wcuyVWJKmwcJxmMNaeKH86gL2x3xD+tbZxIGtWbIPE6M++WxJg0bkEx9HpN8g7Gb
	 5rGTrXKAM2dhIwJhygyR/XrT80sWjg8W6hJtBZYxbMN5++n+Uq9PCG3XMl94ZUwYPX52a
	 Rc8jHqJ9pRwhijVqjpwDeU6vajFc6gxihKTGT9IyY7wmP7AnCX8OQTMmrDfDfslAi0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856748;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=l9YMzkIH1SfSzcij+sSknBL94aVLRw/+XXPclt4N3RU=;
	b=EMFVZKQM6W5bdvWxzS5alQLmzYBhaaLxORE+zql7DIQsG2MLJQbqE1u0/MMJkr51+FS4
	 nX6raHAB0IazLtkCaBUojuUePUUbtLZyXnM235HeyO7PalK3ay4VNwrR6HS2nXnpKjTVu
	 Zdo43pWcR4bB1xnvF6p2R2wr7B9CKcyxeuRDx1G3BWoAAVaWwpDZ450Lfk3wWrmoLgAWG
	 7uRcTapndzytqEgzz0wolWMaD9u8XJ5FdJeLrkAflhd589vjNZWAcjVJoHk8k26I7lMTi
	 /fLvfvduEfGYXb4Z0VhRNamRhrq6bkbYPt9relx0sB7lBB2P+QFm1kAjxfI6gCDvm2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="U5Q0W0/B";
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61477606A31C
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 19:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61477606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=U5Q0W0/B
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9495d543b91so173476985a.0
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 11:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794856747; x=1795461547; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l9YMzkIH1SfSzcij+sSknBL94aVLRw/+XXPclt4N3RU=;
        b=U5Q0W0/BpB9sL3BVGBQtdY07qNqn2tcISUOrvcjFpEMnFFT5F6UoSNOnjcIvQobq3S
         /FTJYEMJbjf6ELnRTDPPZN7ABPvBpvRueZe5tk0b9V0LQFApOb6CUfX3HN4CEcPTR+ex
         kI64AkKq8XYWcXZj9tVm6dDeK5lRiSUwHO+2TJcwha8fV5gbuPTo5JfdmanrruFHoDFx
         H+/2c9HHotLbtXN69gX4PQGLwcfnxW5pjcU4s6NUlhDy2r1ZxriSNqv/5s8+iSkz3jaM
         SrHRxVVOyJfoYlwOX/gPPEQfmPi0uHsfMrn0bSbGBK2kLAbN7Fg7OjRWLjVabXvpwAum
         ocWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794856747; x=1795461547;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l9YMzkIH1SfSzcij+sSknBL94aVLRw/+XXPclt4N3RU=;
        b=orbTEnzGn7DVudm51YYd7N59cOmEjG/f/UvrBKEoQDPZmIjGtYkUxl7CKO78vn1L+0
         5jQw8vmRnuzF8Lte8iWSsq8Xq8bG2y8FFvr9AohtGMo/GxAsrnn3XIYcnk2GHUtM3i2k
         G36WXLTebjizqHIKlzqOVjDP+5JzclTA57fvjHxMW9ZUkxE7PxK1AOk/mtdT1g+xZ9PF
         qERdWMnwCmWiw0TSTkgq1mHx8YVmZF7S2Hq4o4apUv9Gg+fBl8W0dzMHLl8aB4kzArW4
         8S7NBmcrCTD2++k8u+757q9W0ZxarogRQiFz96Z/YcWsEwSAhs2kR4HTeLdJXW0oExKK
         FUVg==
X-Forwarded-Encrypted: i=1; AL+hErHBmUYagLqB6hYAnz3QOmasbom+Y6g4O6A/hmWQzQlFKVJrGWVPFnFSwyyExwzBaxW9mcnllKr4HVUn@vger.kernel.org
X-Gm-Message-State: APuU4Z/NGTAEVLlGFZ2M3yqfODlbWqPRwvmR4ZlE98HqGrsCJKmi7ucx
	8WxOegxlCtv6f9WzG+ByX2NFakKjFJLI1l9vC0chtgxkjptNdNKWBmQn+jJsdENSOKM=
X-Gm-Gg: AYBFou2gzf2XWclsKJWDiKeWkM+a2E6XotR1sLv9KscwLe7IyEwtjSgry+pQtjt+GZa
	8TzGd0lOxFJ7N2Zf8HYC3G4KEYjDk2SapPhsU10q981lmZfTfVuxnXBCnrUT/seATsJRqzvrtJV
	sGnpjqa+mghzXkIBuWw1GetJGdeU+cKi1vNZ1+A2CPvCKfkqdUrQKtmYbCRIIp0siMJRAY0Tcav
	0qu30LxPnk+cLPIjoyE6XXxocXV6kX4VciS0NlubRkC/Zjmfaxls7gon2jAQIMFGK/784RT1r8P
	YUMtvV4HAeJeB9U1LDXF/Vo/wTkJ3eUDr9FtTqSen5/Z7pVdPBWzOsXhNZUqbN/lmAkD87xzPHY
	wcbUVECUm2Za8QU7csYFwCveTwm+bcRVOJ4NPnMDIcNONeYMwqKz0i3tBNrF8ysaBH+MvmwgxWp
	bj86OGf2atXelg1iBMKlXolPQ8Hf0E7xFFNdYEgJctso2Qomqk9ysYQJsxdDrPaxIACpscVdtdH
	KP3N7UBJs2xGDaR3dLCz7WJysA/Vs4Pi7hCA43b62Odx7NhVVh7yy+hVDSIW5fidDhZkSd1Sby/
	30PX/Q==
X-Received: by 2002:a05:620a:2a04:b0:949:7bb1:ac5b with SMTP id af79cd13be357-9497bb1ae6bmr711689485a.47.1794856747470;
        Mon, 16 Nov 2026 11:19:07 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c870ad4sm904654885a.26.2026.11.16.11.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:19:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xT2EL-0000000AHzV-2bwI;
	Mon, 16 Nov 2026 15:19:05 -0400
Date: Mon, 16 Nov 2026 15:19:05 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 20/24] RDMA/mlx5: Clamp log_max_cq_sz shift
 in CQ size checks
Message-ID: <20261116191905.GE2299285@ziepe.ca>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-21-yishaih@nvidia.com>
 <20261116093548.GE11319@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116093548.GE11319@unreal>

On Mon, Nov 16, 2026 at 11:35:48AM +0200, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:43:16PM +0200, Yishai Hadas wrote:
> > The CQ create and resize paths check the requested size against
> > 1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
> > report 31 or more, which makes the shift undefined. A large limit also
> > lets the rounded up CQ size exceed INT_MAX, and it is then truncated
> > when passed on as an int.
> > 
> > Such a size also overflows the CQ buffer size, entries * cqe_size,
> > which create_cq_user() and alloc_cq_frag_buf() compute as an int. A
> > user CQ buffer smaller than the CQ the NIC is given then passes the
> > umem size check, and a kernel CQ gets a zero-sized buffer that
> > init_cq_frag_buf() writes to.
> > 
> > Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
> > reject sizes above INT_MAX. Compute the buffer size with
> > check_mul_overflow(), as resize_user() already does.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > ---
> >  drivers/infiniband/hw/mlx5/cq.c | 52 ++++++++++++++++++++++++---------
> >  1 file changed, 39 insertions(+), 13 deletions(-)
> 
> <...>
> 
> > +/*
> > + * Next power of 2 above entries. It can be 2^32, which doesn't fit the
> > + * unsigned long of roundup_pow_of_two() on 32-bit archs.
> 
> This is not correct. unsigned long in the kernel continue to be 64bits
> even for 32bits archs.

We forget so quickly, long is 32 bit on 32 bit arches

The kernel quirk is that u64 is uniformly 'unsigned long long'

Jason
