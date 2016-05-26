From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Thu, 26 May 2016 11:30:07 -0600
Message-ID: <20160526173007.GD27115@obsidianresearch.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1464100526-31730-9-git-send-email-leonro@mellanox.com>
 <20160524220720.GF7950@obsidianresearch.com>
 <CAAKD3BDVFs4rivq1qEih-Z5uOMSVp=OuwDaVroK=UjAhcj6wsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDVFs4rivq1qEih-Z5uOMSVp=OuwDaVroK=UjAhcj6wsg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 04:24:06PM +0300, Matan Barak wrote:

> >> +enum ibnl_create_device {
> >> +     IBNL_CREATE_DEVICE_CORE = IBNL_VENDOR_ATTRS_MAX,
> >> +     IBNL_CREATE_DEVICE_MAX
> >> +};
> >
> > Whats all this about? Looks very strange.
> 
> The first attribute ids of every command are reserved for the vendor part.

I'd still like to see if we can be happy with globally unique
attribute ID's. I would like to see each driver have it's own range of
global IDs that it can use. Much like an ioctl number each attribute
id should be associated with exactly one structure layout.

The obvious downside is how to index them as large ID's cannot be
array'd anymore, but I wonder if that approach is overkill anyhow, if
there is only going to be one or two arguments then a linear search
is OK, or we can require them to be sorted by ID or something.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
