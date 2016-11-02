From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/ipoib: print only once when doesn't support
 IB_QP_CREATE_USE_GFP_NOIO
Date: Wed, 2 Nov 2016 02:44:07 +0200
Message-ID: <20161102004407.GE3617@leon.nu>
References: <1478003653-16248-1-git-send-email-leon@kernel.org>
 <20161101134823.GA6681@yuval-lap.Home>
 <20161101141454.GD3617@leon.nu>
 <20161101143429.GA10771@yuval-lap.Home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="O2gaCPMlz9o7j9TI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161101143429.GA10771-Hxa29pjIrERMGUUWBy6pNA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--O2gaCPMlz9o7j9TI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 04:34:31PM +0200, Yuval Shaia wrote:
> On Tue, Nov 01, 2016 at 04:14:54PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 01, 2016 at 03:48:24PM +0200, Yuval Shaia wrote:
> > > On Tue, Nov 01, 2016 at 02:34:13PM +0200, Leon Romanovsky wrote:
> > > > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > Currently when the card doesn't support IB_QP_CREATE_USE_GFP_NOIO it warns
> > > > on every QP creation, It becomes worse when driver works in connected mode
> > > > we will see one print on each new connection, instead do it once.
> > > >
> > > > Fixes: 09b93088d7 ('Add a QP creation flag to use GFP_NOIO allocations')
> > > > Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > > index 4ad297d..917393b 100644
> > > > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > > > @@ -1053,8 +1053,8 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
> > > >
> > > >  	tx_qp = ib_create_qp(priv->pd, &attr);
> > > >  	if (PTR_ERR(tx_qp) == -EINVAL) {
> > > > -		ipoib_warn(priv, "can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> > > > -			   priv->ca->name);
> > > > +		pr_warn_once("can't use GFP_NOIO for QPs on device %s, using GFP_KERNEL\n",
> > > > +			     priv->ca->name);
> > >
> > > But it will still re-print it for different device, right?
> >
> > Good question,
> >
> > pr_warn_once is defined as alias to printk_once [1]. That printk_once is
> > macro too [2] which will define local static read_once variable.
> >
> > [1] http://lxr.free-electrons.com/source/include/linux/printk.h#L359
> > [2] http://lxr.free-electrons.com/source/include/linux/printk.h#L322
>
> If only one HCA model is installed on the system then it should be fine,
> but wonder if more then one, would we like to see the warning again? i think
> yes.

It is correct and valid question and not for the multiple devices only.
Additional thing which was missed in such a trivial patch is the lost of
context which is printed by ipoib_warn and doesn't print in the case of
pr_warn.

Thanks for pointing and investing time in the review.

Doug,
Please drop it. We will respin it.


>
> >
> > >
> > > >  		attr.create_flags &= ~IB_QP_CREATE_USE_GFP_NOIO;
> > > >  		tx_qp = ib_create_qp(priv->pd, &attr);
> > > >  	}
> > > > --
> > > > 2.7.4
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--O2gaCPMlz9o7j9TI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGTbXAAoJEORje4g2clinjpoP/it9m5CjkP7ihL0d7SOa3HRk
A+tj5oQ5zByoGNuHln6PAkIlMscoWebGxQBCuiNwnHY2lpR2l+H4xbuNPtwb3e5f
7oRxV16mak8pedKeuKRF7snfhH07RnHyjcDbYTSYyT/M2rIhb23pxG5T2Hu3T7wV
8Oq2cWbnQdHFmEdkYBIef5nKz+5QZSEK+9Cm3IKGrHaPc5IBd47q55gBb0IAJHAR
3YdSs6ed7VGryH8xzQWl1j1pXo39EBnt2aAaZXSZMSXsMNnYINr6J8OUwUCkXoVX
4gpsFbH7hjRCr0m+2rxCEuRGDfB8qEtVATMQ0n8oKw+iSINt8ZS7woEbpvRQkbGA
Q3uQbJSAsdsAYjPc1ywrMPOWN58ia003r9yL8STa+4HePR/thCRtEth10qH/8avK
yPESOd3zz5+rZiTSnxQ+qtq8e9MSSEXGk+Gw36WmgtGQqyGJw3KH21Y9UnwHTz40
Gd61VkMyYET9yraQMzk8oSPEoINfTaxR+69lUDcLl61D5zVppbIknrfdASHEUWfy
U5LVpdPSSEeX01k0bDFtlPiMyzcIieBB4qz0euH76VHU+Y+BHVlzUdiD9IudW3UC
v6oK1T0iNHBappf5f12vhvz6hSz7x7N6JCRxKY0MJrmKFtvP+y7rtFbqbTpqQCzR
ioVpePU1NsKXwBLuRMxW
=8XEx
-----END PGP SIGNATURE-----

--O2gaCPMlz9o7j9TI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
