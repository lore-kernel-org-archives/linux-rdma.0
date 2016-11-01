From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/ipoib: print only once when doesn't support
 IB_QP_CREATE_USE_GFP_NOIO
Date: Tue, 1 Nov 2016 16:14:54 +0200
Message-ID: <20161101141454.GD3617@leon.nu>
References: <1478003653-16248-1-git-send-email-leon@kernel.org>
 <20161101134823.GA6681@yuval-lap.Home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WP/lS5xSWAOC+/uo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161101134823.GA6681-Hxa29pjIrERMGUUWBy6pNA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WP/lS5xSWAOC+/uo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 03:48:24PM +0200, Yuval Shaia wrote:
> On Tue, Nov 01, 2016 at 02:34:13PM +0200, Leon Romanovsky wrote:
> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Currently when the card doesn't support IB_QP_CREATE_USE_GFP_NOIO it warns
> > on every QP creation, It becomes worse when driver works in connected mode
> > we will see one print on each new connection, instead do it once.
> >
> > Fixes: 09b93088d7 ('Add a QP creation flag to use GFP_NOIO allocations')
> > Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > index 4ad297d..917393b 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > @@ -1053,8 +1053,8 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
> >
> >  	tx_qp = ib_create_qp(priv->pd, &attr);
> >  	if (PTR_ERR(tx_qp) == -EINVAL) {
> > -		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> > -			   priv->ca->name);
> > +		pr_warn_once("can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> > +			     priv->ca->name);
>
> But it will still re-print it for different device, right?

Good question,

pr_warn_once is defined as alias to printk_once [1]. That printk_once is
macro too [2] which will define local static read_once variable.

[1] http://lxr.free-electrons.com/source/include/linux/printk.h#L359
[2] http://lxr.free-electrons.com/source/include/linux/printk.h#L322

>
> >  		attr.create_flags &= ~IB_QP_CREATE_USE_GFP_NOIO;
> >  		tx_qp = ib_create_qp(priv->pd, &attr);
> >  	}
> > --
> > 2.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WP/lS5xSWAOC+/uo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGKNeAAoJEORje4g2clinDjMQAM3rOI8ylCjpW3OiP+sPpBzE
AR40GVoowp81+sJabK26+fRjWScxAv5N/mqFUulv7ZTNJD3v5/l2DjXGthvNSp07
djOv+QL0v2B8Bn9fu0kiCK0LpSmQSrnzjdsP5uVtm6eHacCCj/Rj6NlDGEJVSYKV
7M/ASopNMsJG7AEJCYugp7qKHLrxnbLg3FkB3Gd5Xo5CIG6tT7MYa4vTijJ2IQze
R8zeYZ2KpUNjuv0pqqXrpFq+CsdDWGHKrAOfYWwu59/0YextjeNLzmfVE+dMPstX
1AEBR3drOF1s0DORlOHGP9djVW8AqrRyd1y4uKps3HDsi3yJXS8GT35PrJ3Us54Y
HjmfiwVYoEE7kep1+SLoNqqkATOzLW1RlvgR+9tPYtEcbHfvIf1NQb6h+8GhouCJ
GPz8PHDsOaHA23UAOnjbP91ql+6W+/5+QF0i4CJ4dZrQu5ynbSfkTlOb/83qxQtj
3+mwpVhfJDpJrIsbgEiSzynONYzCo36OXOaB+Z4NHnhl1js5WWEzPQJj1uGkZJj0
PTI9LSFESBQhcW/yiZ6oq3YmIB+xcKwuKJVTjLxuBMHfYT25iA3YdMYqgV8OQPNP
6TQvckyNjVoVW22Plczj4kkZvMdGGbNl4g5M3yNddOysa+1ydHdxsWNZZaQjXLuV
a5JoHLfpKTJxEG++RBXA
=Kmcz
-----END PGP SIGNATURE-----

--WP/lS5xSWAOC+/uo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
