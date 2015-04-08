From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 16/19] IB/mad: Add Intel Omni-Path Architecture defines
Date: Wed, 8 Apr 2015 17:41:38 -0400
Message-ID: <20150408214137.GH433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-17-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD708@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD708-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 03, 2015 at 05:33:55PM -0600, Hefty, Sean wrote:
> >  /* Registration table sizes */
> >  #define MAX_MGMT_CLASS		80
> > -#define MAX_MGMT_VERSION	8
> > +#define MAX_MGMT_VERSION	0x83
> 
> It's unfortunate that this results in a big jump in used versions.  Mad_priv.h defines this:

It is unfortunate.

> 
> struct ib_mad_port_private {
> 	...
> 	struct ib_mad_mgmt_version_table version[MAX_MGMT_VERSION];
> 
> struct ib_mad_mgmt_version_table {
> 	struct ib_mad_mgmt_class_table *class;
> 	struct ib_mad_mgmt_vendor_class_table *vendor;
> };
> 
> This ends up allocating about 2K of data per port of NULL pointers.  Not a huge deal, but still.

I agree this is not ideal but this is not a large amount of space.  Nor is this
something which is dynamically being allocated.

> 
> I don't have a great fix here.  Maybe the version[] array can be the necessary size, with some sort of simple mapping function from version to the index?

I did not have a great fix either.  Hence the current implementation.

Frankly I don't know of many systems that have more than a few ports and at 2K
each this does not seem like a big deal.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
