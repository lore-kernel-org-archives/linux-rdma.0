From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Make the code easier to verify
Date: Mon, 13 Jun 2016 12:54:52 +0300
Message-ID: <20160613095452.GD5408@leon.nu>
References: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 10, 2016 at 11:08:25AM -0700, Bart Van Assche wrote:
> Static source code analysis tools like smatch cannot handle functions
> that lock or not lock a mutex depending on the value of the arguments.
> Hence inline the function cma_disable_callback(). Additionally, this
> patch realizes a small performance optimization by reducing the number of
> mutex_lock() and mutex_unlock() calls in the modified functions. With
> this patch applied smatch no longer complains about source file cma.c.
> Without this patch smatch reports the following for this source file:
>=20
> drivers/infiniband/core/cma.c:1959: cma_req_handler() warn: inconsistent =
returns 'mutex:&listen_id->handler_mutex'.
>   Locked on:   line 1880
>                line 1959
>   Unlocked on: line 1941
> drivers/infiniband/core/cma.c:2112: iw_conn_req_handler() warn: inconsist=
ent returns 'mutex:&listen_id->handler_mutex'.
>   Locked on:   line 2048
>   Unlocked on: line 2112
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 54 +++++++++++++++++++++----------------=
------
>  1 file changed, 26 insertions(+), 28 deletions(-)

Thanks Bart,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXXoLsAAoJEORje4g2clinkHcQAKFwx9leVnXG+etCzZBNeXum
CPjVySTKASBz87TPaRI1sNXPiq0cCHlJM2rmbRChsTjnLKwabeUqkaMIsIn8dUxj
ykf0r4/X4FiTBnHLvhxC50pKKHcTeBlBg4/gps1o2WHfSbEjjhm7i+kVoUS7Cbz8
fTGtE1/ltk7Vq6qcwkp0rfQyqgyB9VhwtP+4oeLnrTNCOFCwfw/swemfbTvI/G6w
CX5ok89Il8NgBCbsM9G7MuWRb4U7/dQNqZCoy9VjXyOTaX3WQWXqvu9bWJLVGiP/
5u5JnCE5UNJi21cPPyiuM7JhCar515Q+KAaxeIYOUNFlsTx4bsblVCl024A3+1NW
vIdc8LjfrR3pVGxxPBGVyrBOGNZAUGl5oUJyS8HkLUCEFthJ0qU9UhbzstC24MX4
jJYW3/en2HDoeJP931gYdDZEWscGcPskBkN/xpgurUQmvwN1+2/EfY+Df5xaaFjx
EdSQGvTSUMTMlpmS5us97ZEEHLlku8rdFGav198+uPjFp1aeTbdYp+TmE13txcG7
FrGuQeK4mH9C5vS/G3L6xBSuvrKmiwlKKnviK68jvUjKByOTHGR+O0KF7ctSLLTU
0onBBcANhvqr9bTG+m4GihEl8sXUqPV0bDnpyxAxWQ7fmKbI6Ipdx+3gmq3Vdp0W
qSuaAXCr0jbos36BYYRe
=LlqJ
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
