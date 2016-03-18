From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 18 Mar 2016 19:37:48 +0200
Message-ID: <20160318173748.GL25216@leon.nu>
References: <56EAE9D6.2030908@redhat.com>
 <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 18, 2016 at 09:52:16AM -0700, Linus Torvalds wrote:
> On Thu, Mar 17, 2016 at 10:31 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > There is the one merge issue between the net tree and this tree that was
> > simple and obvious to fix up.  I've had a phone call with Mellanox about
> > how to avoid this in the future (the result of that conversation was
> > that when they have a pre-req patch that is going through Dave's tree,
> > but the dependent patches are going through my tree, then they should
> > submit the pre-req patch to me as well, we can carry identical patches
> > in both trees, and when you merge the duplicate patches will just drop
> > one and then there will be no merge issue).
> 
> That will end up causing just more problems if there are then other
> patches on top in either tree.
> 
> It would be much better to have the shared pre-requisite not as a
> _patch_, but as a separate branch. So that you actually share the
> commits, not just the diff.
> 
> Other subsystems have been able to do that.

Linus,

I'm not sure that my understanding is correct and will be glad
if you can point us to the examples of such branches, so we will
use it as soon as possible.

Thanks.

> 
> >  drivers/infiniband/hw/mlx5/srq.c                  |  41 +-
> ..
> >  91 files changed, 3647 insertions(+), 1995 deletions(-)
> >  create mode 100644 drivers/infiniband/hw/mlx5/gsi.c
> 
> My diffstat doesn't match yours, and it's that "srq.c" file in
> particular that I have no changes to, and see no changes in your pull
> request.
> 
> Other than that it looks normal, but it makes me wonder how that diff
> was generated.
> 
>                   Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
