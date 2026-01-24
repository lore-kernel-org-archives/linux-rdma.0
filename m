Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B20D3EBF1C;
	Sat, 24 Jan 2026 09:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769247312; cv=none; b=F3G3cZb98D/ZSrLQbmhluz02bNUGd12RZOvYW7Y+c2/gKxxuy4+8AwATvPjzSE1EtBDIg1rQhlplvL6DAk90tEq27daNjkl6l0upyTs6EoeJWsP7X/J8LGdlyXUSEEH49G1Dx6eocNT8VBpD+YQnAoKwV09U3K+O6WT2KtyeP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769247312; c=relaxed/simple;
	bh=mvrl+9yu+c5NMxDnTa+G28wB4wke8rkkdtPdNod0PUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdzRMdErmschBuQBKud3QjEWUfnZqquEmssX/CJDokSPDB0P9KFlAHI+cCiAyXF0o89hmU9P55lLArBoax9YChmRmmXDDOZasauLYEfnNPyMmA7taAm7owzlRdWBfFTmdJ94+JA69+yD0dUoX86uytuUiPiGn063D9oiilOu/lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TwNZbzKF; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TwNZbzKF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769247306; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=YM0UILcJR/4TkkLhadUMFOx0cYmqNgriWCYaevIhEXQ=;
	b=TwNZbzKFt0yGFN3B2M6vc9Z/ODqoj/LOsV0kDADN49MyUsehO39sPgy8iXZLQt+QgnjAPZ+fO37EKFwqAXd7tG6W+/YEfz+Rs33lC9cEvDc8A82R8HV7ollNNNODrLmzmg3upSkakA+GWP1JFXTyMhoDTpBZssa1pxq1klXoI0s=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WxiX9Q3_1769247305 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 17:35:05 +0800
Date: Sat, 24 Jan 2026 17:35:05 +0800
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
Message-ID: <20260124093505.GA98529@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXPEFdEdtSmd6AzF@milan>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > find_vm_area() provides a way to find the vm_struct associated with a
> > virtual address. Export this symbol to modules so that modularized
> > subsystems can perform lookups on vmalloc addresses.
> > 
> > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > ---
> >  mm/vmalloc.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ecbac900c35f..3eb9fe761c34 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> >  
> >  	return va->vm;
> >  }
> > +EXPORT_SYMBOL_GPL(find_vm_area);
> >  
> This is internal. We can not just export it.
> 
> --
> Uladzislau Rezki

Hi Uladzislau,

Thank you for the feedback. I agree that we should avoid exposing
internal implementation details like struct vm_struct to external
subsystems.

Following Christoph's suggestion, I'm planning to encapsulate the page
order lookup into a minimal helper instead:

unsigned int vmalloc_page_order(const void *addr){
	struct vm_struct *vm;
 	vm = find_vm_area(addr);
	return vm ? vm->page_order : 0;
}
EXPORT_SYMBOL_GPL(vmalloc_page_order);

Does this approach look reasonable to you? It would keep the vm_struct
layout private while satisfying the optimization needs of SMC.

Thanks,
D. Wythe
