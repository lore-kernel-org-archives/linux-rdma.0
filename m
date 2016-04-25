From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Mon, 25 Apr 2016 18:53:20 +0300
Message-ID: <20160425155320.GH7974@leon.nu>
References: <571A936F.7040409@sandisk.com>
 <571A94AF.7000609@sandisk.com>
 <20160424083538.GF7974@leon.nu>
 <571D6975.2020905@sandisk.com>
 <20160425055433.GG7974@leon.nu>
 <571DE793.6090705@grimberg.me>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPDwMsyfds7q4mrK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571DE793.6090705-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZPDwMsyfds7q4mrK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 25, 2016 at 12:46:59PM +0300, Sagi Grimberg wrote:
>=20
> >>>>+		max_max_sectors =3D (srp_dev->max_pages_per_mr - 1) <<
> >>>>+				  (ilog2(srp_dev->mr_page_size) - 9);
> >>>
> >>> From my understanding, srp_dev->max_pages_per_mr can be equal to 1, in
> >>>case device will advertise it.
> >>>
> >>>Is this understanding correct?
> >>>Will the code work in such case?
> >>
> >>Hello Leon,
> >>
> >>I'm not sure a HCA driver exists for which max_pages_per_mr =3D=3D 1.
> >>Additionally, I'm not sure such a driver would be useful because such a
> >>driver would limit the maximum data transfer size for the iSER protocol=
 to 4
> >>KB. That is too low to reach good performance.
> >
> >Bart and Laurence,
> >You are raising valuable arguments about sanity of setting srp_dev->max_=
pages_per_mr
> >to be equal 1. I totally agree with you that it is insane, however my
> >original question was "does the code support such value?"
>=20
> I don't see why we should worry about imaginary devices.

It is called corner case and the code supports it.

--ZPDwMsyfds7q4mrK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXHj1wAAoJEORje4g2clinmDQP/jriBF5ZVHnl8LH8mqxsC43Y
J2tQhbJx/gle2cvhCljXD2VVjxkg3C4Qy+/1AXFrXOhIj9Z33sdSS7o7x34w40Jh
JNeqeIiIrAnL3192QNgBojZinwxLrvK0xopwRjfIsxF+E21ZIokSjBGs+bvt7Z7y
g/yjSx8M4s1l6w0jMmFhOjaR5oYYRYE6THhJ2dckl+RgGB774nd+OJriTLqQNpKr
fL12Iijt157V8vRuHhnEGC8QVWGOEAN5lN7ZD9x4V4+XRSHlN53vQy4dXchuBXYd
nee2NAfdIe8a4VbBvO15hpixwqhTrMRLmetfrgOMqMU90Tk6l06oGtIWMj59mb0D
Ucy3bJymw7CKuH4rmkvMnv7Y5DkmnF2YlwWvcNRnuFPhk3tMY9GJwEk8XHDoWx3p
dptXgeYFU9A5emRr8vGmmNhPJU3cRlJReVqYvLIZA07Wro6EPR+bOD0QvyDo9gaK
1sjrp4xIKe5JbuVPQGgLzDLr1r3A/SnOA24kk0gD3MsaZMWQdecGE5iFjEKSP8Ug
u8g5gCCnrMZtBlAN/dbmUtz7a4Den7wroeB/txrPujGhOWB9KsNwBq4k79u0LBOq
BBSrfLRin9fUxkvRFw0ifogbIHhy3VaSbZ4LsL7XpgzX8FW6aDBhmWIKqmgbllRQ
9lajHtjQI1uJo+LBywsG
=NVz3
-----END PGP SIGNATURE-----

--ZPDwMsyfds7q4mrK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
