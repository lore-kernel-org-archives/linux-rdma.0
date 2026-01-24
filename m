Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32101D8E10;
	Sat, 24 Jan 2026 14:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769266687; cv=none; b=ElC6PsO3aPTmOaZD9jrpekYFt6ld6p/tG5hBub483CRf62uZDXPMqVbpbiqS8+RNRqlvMUwCnX62jr5UdvktRimzd6XiGDz31dglPnmqQOMzFpDkD6cjJD5e74V42QLfdQFSfV6mhqZm9tRuZ4Mx/O3OQdOp5mGnZyD2PUmNbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769266687; c=relaxed/simple;
	bh=dm8Ct+dHvdTsQ8RTyKSos3OmynlqH5EjrJzZcnN2LuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GR4pmqcOBXYBzYRQ2Y0br4UARTj9RoPhiKUlJzo4gI0gbdr0sLWX7MjGlWEvIiZQAZZ8WGxXakmxErlTjaOfwUyZGRzFukeZX4LFxWWwyiHXEVDTAvzYeWH1fGGcpSdPulXnjm/aObjXS+UZ9h2/L/IRVDwMOzhrd6GiSxIOx2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qLMQh7xd; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qLMQh7xd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769266676; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=CPWuCV8/90YbisajP7XufYM2YYkYUVDqVYcpinvbKXw=;
	b=qLMQh7xdIcdmuC4QVLXEsAR6u2W28NZEIu574FJuOTY6WkmSudQvNhw3iIGSyQ5pKjdjE3WFtPZqCszuv1Xd9cPMZc+2tKtlEJlR059mRXx1XzQt/z6vcy1nZoPbLa3jTAeuDKQCKAK09UxvwkYXHvboVDaYDpIKYuhqg+0T4Cs=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WxjCWVN_1769266674 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 22:57:55 +0800
Date: Sat, 24 Jan 2026 22:57:54 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Uladzislau Rezki <urezki@gmail.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <20260124145754.GA57116@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXSjm1DXm6yP62tD@pc636>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> Hello, D. Wythe!
> 
> > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > virtual address. Export this symbol to modules so that modularized
> > > > subsystems can perform lookups on vmalloc addresses.
> > > > 
> > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > ---
> > > >  mm/vmalloc.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > >  
> > > >  	return va->vm;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > >  
> > > This is internal. We can not just export it.
> > > 
> > > --
> > > Uladzislau Rezki
> > 
> > Hi Uladzislau,
> > 
> > Thank you for the feedback. I agree that we should avoid exposing
> > internal implementation details like struct vm_struct to external
> > subsystems.
> > 
> > Following Christoph's suggestion, I'm planning to encapsulate the page
> > order lookup into a minimal helper instead:
> > 
> > unsigned int vmalloc_page_order(const void *addr){
> > 	struct vm_struct *vm;
> >  	vm = find_vm_area(addr);
> > 	return vm ? vm->page_order : 0;
> > }
> > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > 
> > Does this approach look reasonable to you? It would keep the vm_struct
> > layout private while satisfying the optimization needs of SMC.
> > 
> Could you please clarify why you need info about page_order? I have not
> looked at your second patch.
> 
> Thanks!
> 
> --
> Uladzislau Rezki

Hi Uladzislau,

This stems from optimizing memory registration in SMC-R. To provide the
RDMA hardware with direct access to memory buffers, we must register
them with the NIC. During this process, the hardware generates one MTT
entry for each physically contiguous block. Since these hardware entries
are a finite and scarce resource, and SMC currently defaults to a 4KB
registration granularity, a single 2MB buffer consumes 512 entries. In
high-concurrency scenarios, this inefficiency quickly exhausts NIC
resources and becomes a major bottleneck for system scalability.

To address this, we intend to use vmalloc_huge(). When it successfully
allocates high-order pages, the vmalloc area is backed by a sequence of
physically contiguous chunks (e.g., 2MB each). If we know this
page_order, we can register these larger physical blocks instead of
individual 4KB pages, reducing MTT consumption from 512 entries down to
1 for every 2MB of memory (with page_order == 9).

However, the result of vmalloc_huge() is currently opaque to the caller.
We cannot determine whether it successfully allocated huge pages or fell
back to 4KB pages based solely on the returned pointer. Therefore, we
need a helper function to query the actual page order, enabling SMC-R to
adapt its registration logic to the underlying physical layout.

I hope this clarifies our design motivation!

Best regards,
D. Wythe




