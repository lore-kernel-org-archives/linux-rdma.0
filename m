From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 17/19] IB/mad: Implement support for Intel Omni-Path Architecture base version MADs in ib_create_send_mad
Date: Wed, 8 Apr 2015 17:36:13 -0400
Message-ID: <20150408213612.GG433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-18-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD722@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD722-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 03, 2015 at 05:40:22PM -0600, Hefty, Sean wrote:
> > @@ -937,20 +937,31 @@ struct ib_mad_send_buf * ib_create_send_mad(struct
> > ib_mad_agent *mad_agent,
> >  	struct ib_mad_send_wr_private *mad_send_wr;
> >  	int pad, message_size, ret, size;
> >  	void *buf;
> > +	size_t mad_size;
> > +	int opa;
> > 
> >  	mad_agent_priv = container_of(mad_agent, struct
> > ib_mad_agent_private,
> >  				      agent);
> > -	pad = get_pad_size(hdr_len, data_len);
> > +
> > +	opa = mad_agent_priv->agent.device-
> > >cached_dev_attrs.device_cap_flags2 &
> > +	      IB_DEVICE_OPA_MAD_SUPPORT;
> > +
> > +	if (opa && base_version == OPA_MGMT_BASE_VERSION)
> > +		mad_size = sizeof(struct jumbo_mad);
> > +	else
> > +		mad_size = sizeof(struct ib_mad);
> 
> Didn't an earlier patch make is possible to read the mad_size directly from the device?
> 

Not exactly, that patch specified the "max_mad_size" the device supported.

OPA devices support IB MADs.  If the IB Base Version is specified on an OPA
device the IB MAD size is to be used.  This maintains compatibility with any
software issuing IB MADs.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
