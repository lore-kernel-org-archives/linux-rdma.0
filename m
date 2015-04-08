From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 15/19] IB/mad: Create jumbo_mad data structures
Date: Wed, 8 Apr 2015 11:33:59 -0400
Message-ID: <20150408153358.GC433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-16-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD6C8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD6C8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 03, 2015 at 05:08:53PM -0600, Hefty, Sean wrote:
> > Define jumbo_mad and jumbo_rmpp_mad.
> 
> I would just use 'opa_mad' in place of 'jumbo_mad'.  Jumbo sounds like a marketing term or elephant name.

Done in v5.

>  
> > Jumbo MAD structures are 2K versions of ib_mad and ib_rmpp_mad structures.
> > Currently only OPA base version MADs are of this type.
> > 
> > Create an RMPP Base header to share between ib_rmpp_mad and jumbo_rmpp_mad
> > 
> > Update existing code to use the new structures.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > ---

[snip]

> > diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> > index 00a5e51..80e7cf4 100644
> > --- a/include/rdma/ib_mad.h
> > +++ b/include/rdma/ib_mad.h
> > @@ -136,6 +136,11 @@ enum {
> >  	IB_MGMT_DEVICE_HDR = 64,
> >  	IB_MGMT_DEVICE_DATA = 192,
> >  	IB_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
> > +	JUMBO_MGMT_MAD_HDR = IB_MGMT_MAD_HDR,
> > +	JUMBO_MGMT_MAD_DATA = 2024,
> > +	JUMBO_MGMT_RMPP_HDR = IB_MGMT_RMPP_HDR,
> > +	JUMBO_MGMT_RMPP_DATA = 2012,
> > +	JUMBO_MGMT_MAD_SIZE = JUMBO_MGMT_MAD_HDR + JUMBO_MGMT_MAD_DATA,
> 
> Keep the "IB_" prefix, or add a new "OPA_" prefix.

I'll change JUMBO to OPA to match the "jumbo" to "opa" change.

Integrating this and your follow up comment v5 of this hunk now reads:

@@ -136,6 +136,9 @@ enum {
        IB_MGMT_DEVICE_HDR = 64,
        IB_MGMT_DEVICE_DATA = 192,
        IB_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
+       OPA_MGMT_MAD_DATA = 2024,
+       OPA_MGMT_RMPP_DATA = 2012,
+       OPA_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + OPA_MGMT_MAD_DATA,
 };

> 
> >  };
> > 
> >  struct ib_mad_hdr {
> > @@ -182,12 +187,26 @@ struct ib_mad {
> >  	u8			data[IB_MGMT_MAD_DATA];
> >  };
> > 
> > -struct ib_rmpp_mad {
> > +struct jumbo_mad {
> > +	struct ib_mad_hdr	mad_hdr;
> > +	u8			data[JUMBO_MGMT_MAD_DATA];
> > +};
> > +
> > +struct ib_rmpp_base {
> >  	struct ib_mad_hdr	mad_hdr;
> >  	struct ib_rmpp_hdr	rmpp_hdr;
> > +} __packed;
> > +
> > +struct ib_rmpp_mad {
> > +	struct ib_rmpp_base	base;
> >  	u8			data[IB_MGMT_RMPP_DATA];
> >  };
> > 
> > +struct jumbo_rmpp_mad {
> > +	struct ib_rmpp_base	base;
> > +	u8			data[JUMBO_MGMT_RMPP_DATA];
> > +};
> 
> Please separate this patch into 2 changes.  One that adds and updates ib_rmpp_base, with the second one defining ib_opa_mad & ib_opa_rmpp_mad (or whatever prefix is chosen).

Done in v5.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
