From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Fix unused variable warnings for pl_index, sg_l
Date: Thu, 26 May 2016 08:08:26 +0300
Message-ID: <20160526050826.GQ25500@leon.nu>
References: <1463591298-30102-1-git-send-email-jarod@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HAv5+T9jbwMPl6Kw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463591298-30102-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--HAv5+T9jbwMPl6Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 18, 2016 at 01:08:18PM -0400, Jarod Wilson wrote:
> These variables will be unused if certain #define's aren't set, so wrap
> them with the same #ifdef's as the places they're used.
>=20
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  src/perftest_resources.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/src/perftest_resources.c b/src/perftest_resources.c
> index 71a1541..4071989 100755
> --- a/src/perftest_resources.c
> +++ b/src/perftest_resources.c
> @@ -2778,8 +2778,12 @@ int run_iter_bw(struct pingpong_context *ctx,struc=
t perftest_parameters *user_pa
>  	int 			cpu_mhz =3D 0;
>  	int 			return_value =3D 0;
>  	int			wc_id;
> +	#ifdef HAVE_VERBS_EXP
> +	#ifdef HAVE_ACCL_VERBS

Maybe "#if defined(HAVE_VERBS_EXP) && defined(HAVE_ACCL_VERBS)" will be
better?

Anyway, it is the same.

>  	int pl_index;
>  	struct ibv_sge		*sg_l;
> +	#endif
> +	#endif
> =20
>  	ALLOCATE(wc ,struct ibv_wc ,CTX_POLL_BATCH);
> =20
> --=20
> 1.8.3.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HAv5+T9jbwMPl6Kw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRoTKAAoJEORje4g2clin+c0QAJu/dhR8Q+7VYFwg/WaLvtfA
BCtfqTwAm0zN9TNTG1zYUX2kW7FrlOfTUUSvUWvxVXklZlaJiHID1+tfTVlMP7l6
jvz+yOlo562opw61GJjjsxVEgfebtUh1Ws8BsunLoxNdKS8bSR9DjHWoSrGTe2XX
toLIoRvdQOVPsxnmQf5+D63ckPT8q63SU44jWA25iWSiAev1rmftj9LYEmC7HQOW
Dza88ebPdlGgT6nV3JxsltKcgBsIrOPOJDDThcYtzNWpdhA1b2dygOQ+yGiKNbKo
WDEZikraKLjWzHuLnn1jqcFwRS5pmsvlJ/ssWZZTpLarMeDAeC2PcaqQ6dxOe1v4
TVjbXfl1ZLhKa6D6IWAUVzgIb+MDFlYL7Nkj4MLRbAVKDSCvWc+9hW0jRUksCKta
AlxfAiwUj7FsXB5cHdYP8lwTgKXBJdnABcO8hZh/YAl9WTU2mDst1MBpFrNWxfEc
DcXwZtH8oG5U46UVMtZ4+XmwMVwcdyC+Qw9+zFeHa337FipoXMHz3SUYRvQYSUlK
SVYkDGssOYxGMdmzijVXEy2s+iToPvmxGDHynJhbUu46Zykk6cCUPyArxKcFQM9I
JYJOtTU86kAfa9zUPPjTzg+u20uaBkzqFg4FfVMmNRLyf2hxr67zRfUuGme+h6YE
c+fQlhY+G9277OX8Ey7G
=n0yu
-----END PGP SIGNATURE-----

--HAv5+T9jbwMPl6Kw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
