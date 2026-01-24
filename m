Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B5B262A6;
	Sat, 24 Jan 2026 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769246743; cv=none; b=LZ/A/H4eaEdf5e20T4eqE5xzFba4wqy+OcuF4yhWcp4nPevcSD2ikTYKoJ0pt6WQufsH2ButDTnXtL4fF+HeXsE7b4bML4QldfW4O/lwfQzIUEThd5nU/nQFbDWTM98k2mduIgk6VCGYN3Pqi3GWiMAMkKBFOmhBLuRxH6unGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769246743; c=relaxed/simple;
	bh=0FF0hwSHU1Q1WpbRlERg3YOcdvIdbHeBGhfjfEZ0r2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5GceXBx55dfIMaK8YaDVE45qhYfy5Xei0W8G6OpyNjQVhHyqMnsU8SqFwgvEE2Yk6EF76CZAljK4hrlkFhJf06p3SkjY5jP0QkBUGY5SbJqXjC8ZT1VMcELMLr0HGqSqb4dcBos7qM2cbQIA97stBJLGwESn/0s1rrWZCaPqKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=C6DPt9Nd; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="C6DPt9Nd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769246730; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=kCoUJ1M29g2nJIrmBIjAZ34udgG8JTU6pQFm2HI3HyA=;
	b=C6DPt9NdDIiu+Vzx1OjChL/IkoH+PW4bBgtK1m/va1XVYFMEKEQdaPZMBUVxcRYtIBtstpDW4NhIOe0EBJETyNLqu91hVBfN1Bp9SsYkWLoApOfWEsMfIVg4l7LVVUgsDZJNkLHWZ2J5FkVN7wojq1cX+UKgOR9DrxbblyILxaQ=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WxiaRId_1769246728 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 17:25:28 +0800
Date: Sat, 24 Jan 2026 17:25:28 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Christoph Hellwig <hch@infradead.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 3/3] net/smc: optimize MTTE consumption for
 SMC-R buffers
Message-ID: <20260124092528.GB85316@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-4-alibuda@linux.alibaba.com>
 <aXOLR9GxwuNz3Ddc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXOLR9GxwuNz3Ddc@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Jan 23, 2026 at 06:52:55AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 23, 2026 at 04:23:49PM +0800, D. Wythe wrote:
> > +static inline int smc_buf_get_vm_page_order(struct smc_buf_desc *buf_slot)
> > +{
> > +#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
> > +	struct vm_struct *vm;
> > +
> > +	vm = find_vm_area(buf_slot->cpu_addr);
> > +	return vm ? vm->page_order : 0;
> > +#else
> > +	return 0;
> > +#endif
> 
> You might want to encapsulate this logic in a vmalloc_order or similar
> helper in vmalloc.c.

Hi Christoph,

That's a great suggestion. Encapsulating this logic into a helper like
vmalloc_page_order() (or similar) within vmalloc.c is indeed much
cleaner than exporting find_vm_area().

I'll implement this helper in V2 and use it in the SMC code. Thanks for
pointing this out!

Thanks,
D. Wythe
