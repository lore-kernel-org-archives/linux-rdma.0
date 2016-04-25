From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Mon, 25 Apr 2016 08:54:33 +0300
Message-ID: <20160425055433.GG7974@leon.nu>
References: <571A936F.7040409@sandisk.com>
 <571A94AF.7000609@sandisk.com>
 <20160424083538.GF7974@leon.nu>
 <571D6975.2020905@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571D6975.2020905-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 24, 2016 at 05:48:53PM -0700, Bart Van Assche wrote:
> On 04/24/16 01:35, Leon Romanovsky wrote:
> >On Fri, Apr 22, 2016 at 02:16:31PM -0700, Bart Van Assche wrote:
> >>+		max_max_sectors =3D (srp_dev->max_pages_per_mr - 1) <<
> >>+				  (ilog2(srp_dev->mr_page_size) - 9);
> >
> > From my understanding, srp_dev->max_pages_per_mr can be equal to 1, in
> >case device will advertise it.
> >
> >Is this understanding correct?
> >Will the code work in such case?
>=20
> Hello Leon,
>=20
> I'm not sure a HCA driver exists for which max_pages_per_mr =3D=3D 1.
> Additionally, I'm not sure such a driver would be useful because such a
> driver would limit the maximum data transfer size for the iSER protocol t=
o 4
> KB. That is too low to reach good performance.

Bart and Laurence,
You are raising valuable arguments about sanity of setting srp_dev->max_pag=
es_per_mr
to be equal 1. I totally agree with you that it is insane, however my
original question was "does the code support such value?"

>=20
> Bart.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXHbEZAAoJEORje4g2clinVPMP/1xNLte1yusWm3tgdc44CtSp
9eehGeOXP7rRUpCv4MrXY4UTZOClm76qlrsDmmonSMTzH8aPJHJwOFEcmkKcuRhb
9+KZiYPEY16kQgk6Phh243qc6F33iB1pCIILvbfPVqZtetW1B4iyO3UUmkc7GwAg
N2DmmZR+VUtVd94VFjJWNgholY+oj9CUfBRMsvRqlKB1JjTA8o4rvT/PrMiwaLje
Hh4+ELvlNihsl9iveBKkYsNged9H9YttcXr/5qmVRcJenxTbkmIv7BwpxXLnw2Ip
xZTLmxWcvzCG18Plf3WFU/A8IFaeOZl73ywyPg0JL26MRq6TPRvzjwvEweaNRThk
fCYcx+oVVw6btc7LOZh4GPmYH4vZCLbODO1JFALQM6Z9DAbAQOlja8ao+fVVYGYs
pBEQFydbmrIRxyYkka5Y6svZhu4x0+AOpVa933gjcZpWMc3nao4ZtxVz9cLvh8DP
eWAYRl2sU1dRQQM2K+NszSdZ6MHZOI+IzXPtxT/OIDXDWdFXKzfa8EL6MlP2r1+3
i9e28Sfq7FyeHcl/vMhkKAWLmtEsURSnPeCTelukaDCPDxsXEL8JKL5IDvSuXGzZ
ZMuPfOApjGEcvxsBdi1WJ11tBTktoc60ynTeHe0KI0MzRdn2Ha5Z6YFDUThC61jC
18sPi1ZbiN1FfxcSaqSA
=8FVa
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
