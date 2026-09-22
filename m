Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3599053B351
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 11:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076441; cv=none; b=GXouZoI2FStJwCYQWbTvsY18PvPC0fUWoy/u22F8kq5txkjbKBV/3eEbHWGNEnk9+lxol0TISIr0WByfd/tMbzogEpocodjE891z7vyYs75pTdD/etRR2ZSFuDQR3E6crI4mK06k+GZTdWarnAQFBWEfzVlJZfmsY0Xpo85joDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076441; c=relaxed/simple;
	bh=GRUk2hOinoM4csEhToIpEy1cH5k+m7TLf+qTNUMUEBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIM/1XmC5aLt6mM0XzZgSt1i+fi16uX+fwOKLWsd3UlYkxf6C41ow9Cc45hyHCSL8LkVGwaQTyleyhFgPqLsZPeCzBi0D4+eYJjzei6P+Il0ZvtDIr1djw5kUI4Kk1CgJnUiNBvs2OU1vlhufknR8JslfbbsoiPORVvIs9xvdQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrnuMeiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrnuMeiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696E01F00898;
	Tue, 22 Sep 2026 11:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076436;
	bh=l6vImaDEwX1NtvRMCpe+Ggn14h3FQmLkLoh5/ZKj8Tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrnuMeiQFAOC8ftWSRsC5N/RyfrqTsiBWpinwS+1P3PyLXi4Ipu5vzQ0uekTlauxV
	 8im67iP6ld1u4ZM4NHSDlpPV7/v9TPpxwOlsOhXvIp0mK0VobuTpd0I+fFsPVP5tdU
	 vtWH5YSby8/x10J+yA+3ccwJY3QLXe9aBw1cARgEA1ug3tZbSkt559pGG2saNpszav
	 oCpM0Ls3Xaldj1uiy9QeYB4dCkOXcrP7+xPM+7NcVGtvBJ8OLu503A/OfC+/EU9gr2
	 oqfaMFE0xHspkenCQl2j6QWVKNoR91qonC+WeMeomUrAnzX8Z2edFX29dis4ydteZM
	 JEVKUF2dgMLxg==
Date: Tue, 22 Sep 2026 14:27:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Yonatan Nachum <ynachum@amazon.com>, jgg@nvidia.com,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev, danamala@amazon.com
Subject: Re: [PATCH for-next v2 0/2] RDMA/efa: Add support for MR relaxed
 ordering
Message-ID: <20260922112710.GD563127@unreal>
References: <20260824073057.1046630-1-ynachum@amazon.com>
 <20260914065601.GA21454@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <20260915110909.GI13683@unreal>
 <20260922083925.GA10377@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922083925.GA10377@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Tue, Sep 22, 2026 at 10:29:18AM +0000, Michael Margolin wrote:
> On Tue, Sep 15, 2026 at 02:09:09PM +0300, Leon Romanovsky wrote:w3esq23
> 
> > On Mon, Sep 14, 2026 at 06:56:01AM +0000, Yonatan Nachum wrote:
> > > On Mon, Aug 24, 2026 at 07:30:55AM +0000, Yonatan Nachum wrote:
> > > > Changelog:
> > > > v2:
> > > >  * Remove the relaxed ordering device capability.
> > > > v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/
> > > > 
> > > > -------------------------------------------------------------------------
> > > > Add support for MR relaxed ordering access flag, allowing userspace to
> > > > create PCIe relaxed ordering MRs.
> > > > 
> > > > Dana Malachi (2):
> > > >   RDMA/efa: Use device ABI MR permissions instead of verbs flags
> > > >   RDMA/efa: Pass relaxed ordering flag to device
> > > > 
> > > >  drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
> > > >  drivers/infiniband/hw/efa/efa_com_cmd.c         | 9 ++++++++-
> > > >  drivers/infiniband/hw/efa/efa_com_cmd.h         | 8 ++++++--
> > > >  drivers/infiniband/hw/efa/efa_verbs.c           | 5 ++++-
> > > >  4 files changed, 21 insertions(+), 6 deletions(-)
> > > > 
> > > > -- 
> > > > 2.50.1
> > > >
> > > 
> > > Hi, kind reminder for this series.
> > > I reviewed the Sashiko comments and no changes are needed.
> > 
> > It is always good to know, even three weeks after the review was
> > performed by Sashiko.
> > 
> > Please refrain from sending new features during the merge window, as we
> > mostly ignore submissions during that period.
> > 
> > Thanks
> 
> Leon, do you want us to resend it?

Yes, please.

Thanks

> 
