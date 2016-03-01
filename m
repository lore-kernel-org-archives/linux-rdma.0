From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/9] IB/core: add a helper to check for READ WITH INVALIDATE support
Date: Tue, 1 Mar 2016 09:45:40 -0600
Message-ID: <005f01d173d1$68309af0$3891d0d0$@opengridcomputing.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-4-git-send-email-hch@lst.de> <56D55ABA.6070007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D55ABA.6070007-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Tuesday, March 01, 2016 3:03 AM
> To: Christoph Hellwig; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/9] IB/core: add a helper to check for READ WITH INVALIDATE support
> 
> 
> > +/*
> > + * Check if the device supports READ W/ INVALIDATE.
> > + */
> > +static inline bool rdma_has_read_invalidate(struct ib_device *dev, u32 port_num)
> 
> Is rdma_device_sup_read_inv() a better name?

or rdma_dev_supports_read_inv()

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
