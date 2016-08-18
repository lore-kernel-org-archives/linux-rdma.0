From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] cxgb4/i40iw interoperability fixes
Date: Thu, 18 Aug 2016 09:30:35 +0300
Message-ID: <20160818063035.GB7047@leon.nu>
References: <cover.1471453661.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1471453661.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2016 at 10:07:41AM -0700, Steve Wise wrote:
> Doug, these would be good for 4.8-rc.  They fix some interoperability
> problems between Intel and Chelsio iWARP devices.

Hi Steve,
Is there any chance you could remove "Problem description:" words from comm=
it messages?

Thanks

>=20
> Thanks,
>=20
> Steve.
>=20
> ----
>=20
> Steve Wise (2):
>   iw_cxgb4: limit IRD/ORD advertised to ULP by device max.
>   iw_cxgb4: use the MPA initiator's IRD if < our ORD
>=20
>  drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> --=20
> 2.7.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtVYLAAoJEORje4g2clinxM8P/03e+ZsfAIqR5lKePq8xqHzO
fakULyEpB42fKRc/BB9LS0F6eFhzt4FKE3IBmuV/BYjI9uKpQssHTcEcGjBAixO4
AR4ibKSfGEYOuH/Se5kthaAVqVNH2x5LW7y8OdYO5bw09lIsQrgkV1+f+WsOExru
TddoJGP9wxBt2Nz+va9VV2lRP3JCSiJGsk2/EGhaRydQCoMHaaDBCF8nS+FIfZWH
fQWnoMSPe5ySqCn7SRWj/svKjAopwdPLoo1eKMr/xzBa0s2UhuLg0wgrGAiAXfek
sdDy8LoM1ZAD+6D6maNoAxBVQUY4V+D0zckFTCQH+PNaouQW8lLlz+MNTXtXH6ej
iCKbpgtSy0Wd4wM48mmDT3+Wcvo868R/bEUoqXAdllhhwCIVKeMMS4WXJY/gfz1h
TaUhK6ikiv0buaoHWefB+OYcM0vFgyTC1CMlpTRgpZ7rrhs7mFkf0FSF/7Ocy65X
KKkCoNjGO3F9ZgPG/jeF5L2xROhAUPP8sz7xNxIpq/ZdcALx+wecgNfeHRqc+L8t
Dju+8fQfw/dTVETsRuR2pP+sBR4vA9X+KJVj/F/HJAzz7GzIWRYNGO/Stw2Q4pq7
AMhpEw/YIcPT0Q7arFQqSBd99RXGmxJ2jS14ZqVBtc1b3vCkjCD6QSVfvghxp7G7
mU2uUAXFhfl/IBIiFFgI
=Rgf1
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
