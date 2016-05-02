From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: constify i40iw_vf_cqp_ops structure
Date: Mon, 2 May 2016 08:19:32 +0300
Message-ID: <20160502051932.GB10276@leon.nu>
References: <1462105341-6299-1-git-send-email-Julia.Lawall@lip6.fr>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462105341-6299-1-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 01, 2016 at 02:22:21PM +0200, Julia Lawall wrote:
> The i40iw_vf_cqp_ops structure is never modified, so declare it as const.
>=20
> Done with the help of Coccinelle.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
>=20

Thanks Julia,

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXJuNkAAoJEORje4g2clin+QQP/2pac6QJxWmNO12AadwjhZGb
3oKzvhPi5yjbTVljcL4tS9+MbwGwWJV0eOPjUDREDc6DW3uPgGcLnVf1yRx+jCPP
g9vAzN773cLN0+umkd6Ptf7E2j43UeHQsVYRsqwd11ZEM+D37E/nBr5ISUzMNjoU
X8zF9bxye5F+lx4qtbW/fhSP5ic6yn3hsfW3pWPtqV0sWWaW278Hbx0sXCwdY1ns
oDMrdkLwcUkpOl+jLmy8501QT0NZUXYWff75zfh5OJHCWR+fzUbLC67cUDf5w8vI
To69JClmNci5f1PRgnhkpIV6RxB+/GeduJK5OvR+GUgEA8ndU15EnDzHMEuyGG0o
rAmXs6AkgBMH3km/7UgN7JMj/S94QHBrGjlSRQkPnUFxo5LJ9NjuxTvnlnh78sUR
Ng/ehrma7gUdAEzyatYj4y3SVxvVfbXui9ocNotzSFzRIvpYGWds4sA9vxMPZRI3
G4GfaGmyJdtA4/C8FWP15zMZUVazGdigrpojg+VP5qdLd2dDSoLdz0SsQDBdo9l0
WOg5ko25b7rWfWRwXSmDD+op3qY62MLUS9/42me+0o3x3iB/3hMIiakzcrtG3w7c
h58AxjY6hHvspNJoiq/njiBX7mrQDbmGx5XiaOsU+oh0nqYDqvrXNa6DIeC1lWsc
4HIsD7UWwZyxpu4Zb9bT
=WVyq
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
