From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma v1 0/1] IB/core: Fix input len in multiple user
 verbs
Date: Fri, 18 Aug 2017 11:01:01 -0400
Message-ID: <1503068461.2598.10.camel@redhat.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
         <BN3PR07MB25782522FB09A41FA47742A8F8D50@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB25782522FB09A41FA47742A8F8D50-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-06 at 12:24 +0000, Amrani, Ram wrote:
> > This patch follows [1] that fixed three verbs and extends that fix
> > to
> > the other verbs as well.
> > 
> > This fix is required for qedr to support existing and future
> > libraries.
> > 
> > I was able to test the fix only partially due to its scope hence
> > careful
> > review is required, and testing, of course.
> > 
> > v0->v1:
> >  * Updated vendor verbs to match the core changes.
> > 
> > 
> > [1] https://www.spinics.net/lists/linux-rdma/msg33405.html
> > 
> > Ram Amrani (1):
> >   IB/core: Fix input len in multiple user verbs
> > 
> >  drivers/infiniband/core/uverbs_cmd.c         | 70
> > ++++++++++++++++------------
> >  drivers/infiniband/hw/mlx5/cq.c              |  6 +--
> >  drivers/infiniband/hw/mlx5/main.c            | 11 ++---
> >  drivers/infiniband/hw/mthca/mthca_provider.c |  2 +-
> >  4 files changed, 46 insertions(+), 43 deletions(-)
> > 
> > --
> > 1.8.3.1
> 
> Hi Doug,
> Are you OK with applying the patch or do you expect ACKs for mlx5 and
> mthca?

I do want to make sure that Leon has looked over the mlx5 and mthca
sections, yes.  I could run regression tests, but I'd rather him say
that the changes are OK as opposed to relying on test results.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
