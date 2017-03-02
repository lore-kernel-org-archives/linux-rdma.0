From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] iw_cxgb4: Use dsgl by default
Date: Thu, 2 Mar 2017 09:15:24 -0600
Message-ID: <03fb01d29367$d0cdd2b0$72697810$@opengridcomputing.com>
References: <1487833303-4779-1-git-send-email-ganeshgr@chelsio.com> <20170302144710.GF9525@mtr-leonro.local> <039001d29365$fbaf37f0$f30da7d0$@opengridcomputing.com> <20170302151122.GC14379@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170302151122.GC14379-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Ganesh Goudar' <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, 'Bharat Potnuri' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Mar 02, 2017 at 09:02:17AM -0600, Steve Wise wrote:
> > >
> > > On Thu, Feb 23, 2017 at 12:31:43PM +0530, Ganesh Goudar wrote:
> > > > Enable the use of dsgl by default and determine whether dsgl is
> > > > supported from lld info.
> > > >
> > > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > > Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > > Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/hw/cxgb4/mem.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/cxgb4/mem.c
> > > b/drivers/infiniband/hw/cxgb4/mem.c
> > > > index 410408f..8db7a11 100644
> > > > --- a/drivers/infiniband/hw/cxgb4/mem.c
> > > > +++ b/drivers/infiniband/hw/cxgb4/mem.c
> > > > @@ -38,9 +38,9 @@
> > > >
> > > >  #include "iw_cxgb4.h"
> > > >
> > > > -int use_dsgl = 0;
> > > > +int use_dsgl = 1;
> > > >  module_param(use_dsgl, int, 0644);
> > > > -MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
> > > > +MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=1)");
> > >
> > > Can we get rid of this module parameter completely?
> >
> > We can, but we would need to deprecate it for a release or two.  I believe
> > removing them cold-turkey isn't recommended because it represents a form of
> user
> > interface...
> 
> You can rename it to be deprecated_use_dsgl instead of use_dsgl and wait
> for a couple of years to see if someone complains.
> 

I think for cxgb4 module options, we just add "DEPRECATED" to the description
for a few releases, then remove it.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
