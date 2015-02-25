From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 06/19] IB/core: Add max_mad_size to ib_device_attr
Date: Wed, 25 Feb 2015 18:32:27 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC3ED5B@CRSMSX101.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
 <1423092585-26692-7-git-send-email-ira.weiny@intel.com>
 <1424787385.4847.16.camel@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC3ECE5@CRSMSX101.amr.corp.intel.com>
 <20150225182308.GA14580@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150225182308.GA14580-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >
> > Fixed for v5 with this message.
> >
> > +               dev_err(&device->dev,
> > +                       "Max supported MAD size (%u) < min required by ib_mad
> (%u), ignoring device (%s)\n",
> > +                       device->cached_dev_attrs.max_mad_size,
> > +                       IB_MGMT_MAD_SIZE, device->name);
> 
> It also seems redundant since the only call to ib_mad_port_open is:
> 
>                 if (ib_mad_port_open(device, i)) {
>                         printk(KERN_ERR PFX "Couldn't open %s port %d\n",
>                                device->name, i);
> 
> So, why does this particular error deserve a special double error print? I
> assume it is basically impossible to hit?

This does indicate a coding error.  Generally I prefer details of why the device could not open the port.  But if the community feels this is redundant or "not possible" I can drop the hunk.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
