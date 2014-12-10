From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Verify that port types are the same only if
 DPDP supported
Date: Wed, 10 Dec 2014 13:16:19 +0200
Message-ID: <20141210111619.GA4647@yuval-lab>
References: <1417971956-16577-1-git-send-email-yuval.shaia@oracle.com>
 <CAJ3xEMgWQ9-iJa+TZpDYV8VS2ORyPsJWi_4vpUCnRxCrYtOLyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgWQ9-iJa+TZpDYV8VS2ORyPsJWi_4vpUCnRxCrYtOLyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 09, 2014 at 07:47:27PM +0200, Or Gerlitz wrote:
> On Sun, Dec 7, 2014 at 7:05 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > This patch is merely makes code more nice and readable.
> > Instead of checking for DPDP on every loop cycle the check moves out of the loop.
> 
> Few short comments:
> 
> 1. avoid saying "this patch does this and that" in the change-log
> 
> 2. change the patch subject line to reflect what the patch is doing
How about this:
"Check DPDP violation only when DPDP is not supported"
> 
> 3. s/is merely makes/is merely making/
> 
> 
> 
> >
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/main.c |    7 +++----
> >  1 files changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> > index 861035f..ec4e3fd 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> > @@ -567,15 +567,14 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
> >  {
> >         int i;
> >
> > -       for (i = 0; i < dev->caps.num_ports - 1; i++) {
> > -               if (port_type[i] != port_type[i + 1]) {
> > -                       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP)) {
> > +       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP))
> > +               for (i = 0; i < dev->caps.num_ports - 1; i++) {
> > +                       if (port_type[i] != port_type[i + 1]) {
> >                                 mlx4_err(dev, "Only same port types supported "
> >                                          "on this HCA, aborting.\n");
> >                                 return -EINVAL;
> >                         }
> >                 }
> > -       }
> >
> >         for (i = 0; i < dev->caps.num_ports; i++) {
> >                 if (!(port_type[i] & dev->caps.supported_type[i+1])) {
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
