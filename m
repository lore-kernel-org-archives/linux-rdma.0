From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Expose driver version
Date: Tue, 26 Jan 2016 19:50:41 +0200
Message-ID: <20160126175041.GC8059@leon.nu>
References: <1453812983-23987-1-git-send-email-yuval.shaia@oracle.com>
 <20160126145418.GB8059@leon.nu>
 <20160126165705.GA2691@yuval-ThinkPad-X220>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160126165705.GA2691@yuval-ThinkPad-X220>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 26, 2016 at 06:57:06PM +0200, Yuval Shaia wrote:
> On Tue, Jan 26, 2016 at 04:54:18PM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 26, 2016 at 04:56:23AM -0800, Yuval Shaia wrote:
> > > Expose driver version so admin can query it.
> > > Initial version set to 3.18.1 as 3.18 is the latest OFED version.
> > > 
> > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/cm.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> > > index 1d92e09..cb5dfeb 100644
> > > --- a/drivers/infiniband/core/cm.c
> > > +++ b/drivers/infiniband/core/cm.c
> > > @@ -53,9 +53,12 @@
> > >  #include <rdma/ib_cm.h>
> > >  #include "cm_msgs.h"
> > >  
> > > +#define DRV_VERSION "3.18.1"
> > > +
> > 
> > I recommend to drop this line instead of exposing.
> > The proper way is to use kernel version and not
> > specific module version which is unrelated to
> > anything in the real world.
> Are you suggesting not to use MODULE_VERSION at all?
> Asking because i see many drivers (>600) that use it.

Yes, it was discussed before [1]. These drivers were coded in copy/paste
technique.

[1] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg30201.html

> > 
> > >  MODULE_AUTHOR("Sean Hefty");
> > >  MODULE_DESCRIPTION("InfiniBand CM");
> > >  MODULE_LICENSE("Dual BSD/GPL");
> > > +MODULE_VERSION(DRV_VERSION);
> > >  
> > >  static void cm_add_one(struct ib_device *device);
> > >  static void cm_remove_one(struct ib_device *device, void *client_data);
> > > -- 
> > > 1.7.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
