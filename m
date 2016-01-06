From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Unable to establish rdma connection, breaks rdma basic
 functionality
Date: Wed, 6 Jan 2016 16:50:45 +0530
Message-ID: <20160106112043.GA2086@hari-Latitude-E5550>
References: <26E3F92EC670BD429DB5CB319D773C13C4452BD0@nice.asicdesigners.com>
 <CAAKD3BD3oj7kBgHrpkoVFVXtFAUHgkkSHP3vBSWRZCc+VCC++g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BD3oj7kBgHrpkoVFVXtFAUHgkkSHP3vBSWRZCc+VCC++g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Nirranjan Kirubaharan <nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 06, 2016 at 12:33:09 +0200, Matan Barak wrote:
> On Wed, Jan 6, 2016 at 6:43 AM, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> >
> > Hi Doug,
> >
> > I am trying to rping server, but it fails when bound to any address other then IF_ANY.
> > # rping -s -a 102.1.1.129 -C1 -p 9999 -vd
> > created cm_id 0x23d7800
> > rdma_bind_addr: No such file or directory
> > destroy cm_id 0x23d7800
> >
> > If bound to IF_ANY address, server starts but client fails to establish connection.
> > # rping -s -C1 -p 9999 -vvvd
> > created cm_id 0xc34800
> > rdma_bind_addr successful
> > rdma_listen
> >
> > And the commit which introduced this regression is
> >
> > commit abae1b71dd37bab506b14a6cf6ba7148f4d57232
> > Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date:   Thu Oct 15 18:38:49 2015 +0300
> >
> >     IB/cma: cma_validate_port should verify the port and netdevice
> >
> >     Previously, cma_validate_port searched for GIDs in IB cache and then
> >     tried to verify the found port. This could fail when there are
> >     identical GIDs on both ports. In addition, netdevice should be taken
> >     into account when searching the GID table.
> >     Fixing cma_validate_port to search only the relevant port's cache
> >     and netdevice.
> >
> >     Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> >
> >
> > The bug is easily reproducible with latest rc and breaks basic rdma functionality.
> > Since 4.4 is already in -rc8, can we have a quick fix.
> >
> > Thanks,
> > Hari--
> 
> Hi,
> 
> I don't have a iwarp server, so could you please test this simple fix:
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 2cbf9c9..351e835 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -439,7 +439,7 @@ static inline int cma_validate_port(struct
> ib_device *device, u8 port,
>         if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
>                 return ret;
> 
> -       if (dev_type == ARPHRD_ETHER)
> +       if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port))
>                 ndev = dev_get_by_index(&init_net, bound_if_index);
> 
>         ret = ib_find_cached_gid_by_port(device, gid, port, ndev, NULL);
> 
> Regards,
> Matan

Hi Matan,

Thanks. It worked for me.

Regards,
Hari

> 
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
