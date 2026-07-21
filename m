Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6878B3EDE79
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654113; cv=none; b=pnIuQfw8nHWlFTYEX+QN6zwY03SyJhSkrRbprGoxXrYNi/lTwT2Z4Vw6hBYpglI4FCIlUpxp10PnYhdtsi0GZLjlRSl1UjcLnEVx6rtYz22RvmaVVlG4QkIpwm+3mVW70FvttAX47rLNltmKdMzRfI7HzbjfbGCmnbMeSO34Psw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654113; c=relaxed/simple;
	bh=/BDXtvuQU5BF/4X9H7PNgW92XyyAno+4wzN8BEf1NoY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLW1m3XUDtNo6QTQs30YuMQnCH8EqXtxdWj51L+6XzdDWLrGAUr3wY+BaBKVRnixK5071MKVOnC6ObLEJAjYNnhzDQl3waeGyubTmYGgtIwEnNaIPyk1yu3Aq2vuGmMDh/HY0/jtXCHUwGNo3PU+vlUX8FuTE1TgfrrLxGTPMCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=N5lDT4Hk; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="N5lDT4Hk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784654112; x=1816190112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v8htfgVWe5tdJVUaeZOAKJaREbn1C2tA+ecl/2uB+n4=;
  b=N5lDT4HklAbnfumr5W286hd0f7iF+gm4xUgf50p9OMub7O+EfNAFnvsl
   8nxtXHoqbwM0FZiXH9zkbGJiOXYXPQV8hsEYJmHW7VVUebIc8nbb3AbBK
   /DnOLLzoyI83lj9gV40sQbUZ8HdrvZ8BzQzOluqSEzlrqoNDx4MlUwYSh
   lIBjV1WJpRnviUKZWw9uZbNS2gV819wYMCaIrrjEwyVwVF8Adl14F5A0C
   mkGbx4tAIKKaGo1uvviTPv+mmHoLpehdB3WOiYDPRgNo9lMIZI0UDiIOD
   NNUz1yfYj4fRJzry+jfzIyLWIhIY990/fzXXcYAPwlofgCpTj7IO4Fh/l
   Q==;
X-CSE-ConnectionGUID: MlpeHB9pSWSqlANHxjpCGg==
X-CSE-MsgGUID: 8pJNv27bQ+WXNdQnnAyFQw==
X-IronPort-AV: E=Sophos;i="6.25,177,1779148800"; 
   d="scan'208";a="24112180"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 17:15:09 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:14505]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.230:2525] with esmtp (Farcaster)
 id fa5c7731-15fd-48e4-a3a7-3b29207fa1e4; Tue, 21 Jul 2026 17:15:08 +0000 (UTC)
X-Farcaster-Flow-ID: fa5c7731-15fd-48e4-a3a7-3b29207fa1e4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 21 Jul 2026 17:15:08 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Tue, 21 Jul 2026
 17:15:04 +0000
Date: Tue, 21 Jul 2026 17:14:53 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>, <sleybo@amazon.com>,
	<matua@amazon.com>, <gal.pressman@linux.dev>, Yonatan Nachum
	<ynachum@amazon.com>
Subject: Re: [PATCH for-next v10 4/6] RDMA/core: Add Completion Counters to
 resource tracking
Message-ID: <20260721171453.GA19670@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20260720132221.2551-1-mrgolin@amazon.com>
 <20260720132221.2551-5-mrgolin@amazon.com>
 <20260721141659.GM110966@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260721141659.GM110966@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, Jul 21, 2026 at 05:16:59PM +0300, Leon Romanovsky wrote:
> On Mon, Jul 20, 2026 at 01:22:19PM +0000, Michael Margolin wrote:
> > Track completion counter objects in the resource tracking database so
> > they are visible through the rdma netlink interface. The rdma tool
> > displays the comp_cntr count in the resource summary.
> > 
> > Add RDMA_RESTRACK_COMP_CNTR type, embed rdma_restrack_entry in
> > ib_comp_cntr, and add the res_to_dev mapping. Register the resource
> > on create and remove it on destroy.
> > 
> > Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> > Signed-off-by: Michael Margolin <mrgolin@amazon.com>
> > ---
> >  drivers/infiniband/core/nldev.c                      | 8 ++++++++
> >  drivers/infiniband/core/restrack.c                   | 2 ++
> >  drivers/infiniband/core/uverbs_std_types_comp_cntr.c | 6 ++++++
> >  include/rdma/ib_verbs.h                              | 1 +
> >  include/rdma/restrack.h                              | 4 ++++
> >  5 files changed, 21 insertions(+)
> 
> <...>
> 
> > @@ -48,7 +50,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_CREATE)(struct uverbs_attr_bun
> >  	if (ret)
> >  		goto err_free;
> >  
> > +	rdma_restrack_new(&cc->res, RDMA_RESTRACK_COMP_CNTR);
> 
> This is an unexpected location. I would expect restrack
> initialization to occur before ops.create_comp_cntr.
> 
> Thanks

No problem, I'll move it.

Michael

> 
> > +	rdma_restrack_set_name(&cc->res, NULL);
> > +
> >  	uobj->object = cc;
> > +	rdma_restrack_add(&cc->res);
> >  	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE);
> >  	return 0;
