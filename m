From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Thu, 23 Mar 2017 12:40:59 -0600
Message-ID: <20170323184059.GA6087@obsidianresearch.com>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20170205224401.GB26474@obsidianresearch.com>
 <DB5PR05MB12702D1DE9A7E7773FF823ACB93F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB12702D1DE9A7E7773FF823ACB93F0-8IvNv+8VlcCeKfjjHlISstqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 23, 2017 at 06:21:09PM +0000, Alex Margolin wrote:
> 
> 
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > Sent: Monday, February 06, 2017 12:44 AM
> > To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [RFC] Registering non-contiguous memory
> > 
> > On Sun, Feb 05, 2017 at 04:46:04PM +0000, Alex Margolin wrote:
> > 
> > > +struct verbs_mw {
> > > +	struct ibv_mw		mw;
> > > +	uint32_t		comp_mask;
> > > +	uint32_t		lkey;
> > > +	uint32_t		descriptor_num;
> > > +};
> > 
> > Just as a general comment for all future patches - now that the provider
> > interface is private I don't want to see 'comp_mask' stuff in driver.h
> 
> How else would we support future extensibility otherwise? It seems
> that all the other structs in driver.h have comp_mask: struct
> verbs_xrcd, struct verbs_srq and struct verbs_qp.

comp_mask was originaly to support ABI change, but the driver ABI is
now private so we do not need it in driver.h. If you need optional
things then a 'flags' or a NULL value is the way to go.

It is hard to understand what you are proposing here since verbs_mw
wasn't even used in the patch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
