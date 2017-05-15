From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Mon, 15 May 2017 17:57:57 +0300
Message-ID: <20170515145757.GI3616@mtr-leonro.local>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="huLXOlJ1ghGp/P5+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515145203.10708.16921.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--huLXOlJ1ghGp/P5+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 10:52:44AM -0400, Chuck Lever wrote:
> The fourth parameter of the module_param_named macro is a set of
> file permissions. Passing 0 there means that module parameter is
> not created and that adding "options ib_core force_mr=1" to a
> modprobe.conf file has no effect.
>
> The default setting of rdma_rw_force_mr continues to be 0, or false.
>
> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Chuck,

Do we really need this parameter?

> ---
>  drivers/infiniband/core/rw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index dbfd854..1cc8f07 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -23,7 +23,7 @@ enum {
>  };
>
>  static bool rdma_rw_force_mr;
> -module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
> +module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
>  MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
>
>  /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--huLXOlJ1ghGp/P5+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZwfUACgkQ5GN7iDZy
WKdb+w/9F7KLrJgITyw5He+mp6oP9sHzYDdO+Oae6p53ZxS+8CcsV9UCbDXRe07a
sHFSK4lgc6/B9i0rj3ZzNmbo6RLTikEN5GAVlTaJ1nwsVzAH/Kp/Gq8BFVqpZJRy
nWTt0L9VoPUniakm6quPS2gPKMjFKEH9+3Ox28Aa1VMqd3/f+c+Zu5H1f1tQyki+
WL+l/DFCt2YkkrMd7m/Siv7gPajgEBvmAzHWfT3C+UzFQ6IBPWuJCWNNJVrHm12z
G/wg2i3KAl1Q+I5qK1fKEnHNFi0BQoJQE5it+Ib6dI+43OrS3GIcFsB2QMEpmNVD
M9+MxJbiMrQuXZdbDccdxr+rY8mm/y+3cnaObORJkWJ+xtXANv0AUVDEke0kNu5B
vRpI+18pV0yabBlIyrq36LG5gZf3Z/Mjjmu7oX3/PMglccRTcqgwb16YEh4x+HLS
88PjV0WAumGrISx1s+nI+30F5a4kfE6PoBrFIkYN4XAOMT8KmG3hLJLhKnNFIxWH
Rz2zQMb+FuwvWUM+wTSdJM5HAE4qhSmQz3xbOWFgSj+ox3RBNsojAvAivITjvtCt
5Mnhx3v2EtVRcuTOZhrptWdaZ8LGJv/jXhTpe7Nvka2f6Gv3PY/6JZ2JKkJyYA64
f/7ANYvlXaoC5DxOATu72LwEz6DVeBWWZLpw/HxAZTFY2HEr3wI=
=QPu3
-----END PGP SIGNATURE-----

--huLXOlJ1ghGp/P5+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
