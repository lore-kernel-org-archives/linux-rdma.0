From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Sun, 4 Jun 2017 21:21:13 -0500
Message-ID: <20170605022113.GA18172@ctung-MOBL3.amr.corp.intel.com>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <20170601041022.GM5406@mtr-leonro.local>
 <20170602162103.GA12468@ctung-MOBL3.amr.corp.intel.com>
 <20170604053123.GC6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170604053123.GC6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think that I understand the differences between our views on the subject. The main
> difference is if iWARP portmapper is part of large ecosystem (my view) or some
> standalone feature (your view).

Please do not speak for me.

Portmapper is a part of the ecosystem but the only user of it is on the iWARP side.
It is no different from iw_cm which is only used from iWARP side.

> I see iWARP as an integral part of IB core and I do expect that all consumers of
> NETLINK_RDMA will be complied to libnl library and work in similar manner to whole
> network stack. I do expect that newcomer won't learn in hard way that
> his non-blocking calls to netdev NETLINKs and NETLINK_RDMA work except
> for iWARP portmapper part.

You are trying to generalize portmapper into something which it is not to justify
your argument.  Please stop this line of argument.  It won't work on me.

> > > > > 4. Reverting is a common practice in Linux kernel. Patches are not
> > > > > carved in stones.
> > > >
> > > > Reverting a patch that's introduced during RC cycle is fine, introducing
> > > > regression is NOT and that is what you are doing by simply proposing to revert
> > > > this patch.  Reverting this patch will introduce a REGRESSION error with respect to
> > > > port mapping functionality for all iWARP vendors.
> > >
> > > Interesting and how did all these iWARP vendors survive before your
> > > patch?
> >
> > We are all still here. :-)  But if we let you simply revert a patch that fixes portmapper
> > for all iWARP vendors then we may be not.
> 
> It is not really fixing but hiding, and it is not related to vendors which want
> or don't want, it is related to the community and to the right infrastructure for
> everyone, so everyone will benefit from it.

Again, over generalization.

> > > > > 5. I proposed a solution -> go and fix your user space program.
> > > > This is a kernel patch you are trying to revert, you are breaking existing
> > > > kernel functionality.  Nothing to do with user space.
> >
> > Here is a better solution.  Post a patch to the kernel that will not introduce a regression
> > and fix whatever the probelm you think there is, then I will personally review the patch.
> 
> You got proposal, which is not related to kernel.

Still waiting on a usable patch from you, no more unsubstantiated arguments from you.

Chien

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
