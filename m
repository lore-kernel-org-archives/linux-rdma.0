From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma-ndd shipped by infiniband-diags and rdma-core
Date: Mon, 15 May 2017 04:42:14 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67CAA0F6@CRSMSX101.amr.corp.intel.com>
References: <1494335693.3752.1.camel@profitbricks.com>
 <20170509175406.GJ10073@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509175406.GJ10073-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, May 09, 2017 at 03:14:53PM +0200, Benjamin Drung wrote:
> > Hi,
> >
> > /usr/sbin/rdma-ndd is shipped by infiniband-diags (version 1.6.7-1 
> > in
> > Debian) and the rdma-core package. This makes both package not 
> > installable in parallel. rdma-ndd should be shipped by only one 
> > source package. If rdma-core is the new upstream for it, please 
> > remove it from infiniband-diags and publish a new release. Otherwise 
> > I cannot add the correctly version Breaks & Replaces to the Debian package.
> 
> Ira,
> 
> Didn't you release when you merged rdma-ndd with rdma-core?

Indeed this has been in the plans.

Leon, as I have said in the past I want to move the infiniband-diags to the Linux-rdma github but only after the libibmad merge.

For review I have put my proposed new infiniband-diags (planned v2.0) here:

https://github.com/weiny2/infiniband-diags/tree/master-new

I'd like to have Hal check it out before I push this officially and release it.

In the meantime Leon can you set me up a repo on Linux-rdma and once we have settled on the libibmad merge I will push there with a new v2.0 release.

Ira

> 
> Thanks
> 
> >
> > --
> > Benjamin Drung
> > System Developer
> > Debian & Ubuntu Developer
> >
> > ProfitBricks GmbH
> > Greifswalder Str. 207
> > D - 10405 Berlin
> >
> > Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> > Web: https://www.profitbricks.com
> >
> > Sitz der Gesellschaft: Berlin.
> > Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> > Geschäftsführer: Achim Weiss.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
