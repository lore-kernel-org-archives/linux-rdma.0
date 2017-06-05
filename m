From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/bnxt_re: Check return value from get_link_ksettings
Date: Mon, 5 Jun 2017 15:54:15 +0300
Message-ID: <20170605125415.GN6868@mtr-leonro.local>
References: <20170605091429.16232-1-yuval.shaia@oracle.com>
 <20170605125227.GM6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jbyekxk18hnEXT0m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605125227.GM6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Jbyekxk18hnEXT0m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 03:52:27PM +0300, Leon Romanovsky wrote:
> On Mon, Jun 05, 2017 at 12:14:29PM +0300, Yuval Shaia wrote:
> > The function get_link_ksettings might return bad status indicating a
> > failure to retrieve interface atttibutes.
> > Check return value to cover this case.
> >
> > While there, change the zero-initialization to "compiler-helper" instead
> > of an expensive call to memcpy.
> >
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > index 7ba9e69..10c7189 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -183,17 +183,19 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
> >
> >  static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
> >  {
> > -	struct ethtool_link_ksettings lksettings;
> > -	u32 espeed;
> > +	u32 espeed = SPEED_UNKNOWN;
> >
> >  	if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> > -		memset(&lksettings, 0, sizeof(lksettings));
> > +		struct ethtool_link_ksettings lksettings = {0};
> > +		int rc;
> > +
> >  		rtnl_lock();
> > -		netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> > +		rc = netdev->ethtool_ops->get_link_ksettings(netdev,
> > +							     &lksettings);
> >  		rtnl_unlock();
> > -		espeed = lksettings.base.speed;
> > -	} else {
> > -		espeed = SPEED_UNKNOWN;
> > +
> > +		if (!rc)
>
> Are you sure that it is "if (!rc)" and not "if (rc)"?
> in commit message you wrote that "The function get_link_ksettings might
> return bad status indicating".

Sorry, you are right.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Jbyekxk18hnEXT0m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1VHcACgkQ5GN7iDZy
WKcqsg//Z53YhmJ+wGx8e56973yKtkXnb3fEQTXqm4dqo3dDm2Robp/G0sjiUCZo
8jQdL6qNBNOm1+l1bYq7LX32gwSJhqFxQMY+dTpQxUHryvu62Wtqz0pNLT3UJpWX
RHVxfEIaZbwyDytL8EhZDIuuSjCyAPDkeUMfrJiLpor9G69g4ICNydD7BRDemQ6O
QjO5+m8hmaUmGJERLmGewH15isKG0UtIHUKDWiN0QHBXrLhQnePUqH3hM0P1pa8A
KxezGXHFnWzrBtHD+FL1CnltZeKW0XGDGd0F4sKz7Epm5lesx7haymGX7f3YMem/
gIhLg3Q3pbQRbZmCfwenRlDvk+4eMnCDtUWTaNzBRfFyMKyo6CSvOsFhxrJO1wdL
I7x9tqtRSNY0RqX3us8U2Yc7iNubJC04aDqZF1+Sdph03qunNRkLeh9na7It/LE/
WmoFjEFT/1ykBflV2JTDPe+zRsE+wfWN5MEpTqXmpFANasNAJPsbufX0nUu9VfKk
WdgUYDMUfkbbZLFZD876gjfL9jSQAhYgfwAqVeulw4OOrALYsSum6cRGvScPz3SD
OvUtZXx6vvLeq5o5RQ2x8OVSJNsLpPlIdzbJme2boNYQIRTKK+eKVkcvXLwAIRhm
1lyhwkI98Qmzm9YfmK1P9GJzdTEtPXTOljXOfRh1Fv/Zb+0RUYw=
=C5YV
-----END PGP SIGNATURE-----

--Jbyekxk18hnEXT0m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
