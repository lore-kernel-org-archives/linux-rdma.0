From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] infiniband: avoid uninitialized variable warning in
 create_udata
Date: Sat, 11 Nov 2017 11:21:05 +0200
Message-ID: <20171111092105.GU18825@mtr-leonro.local>
References: <20171110221053.3549147-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AfkfStYJxYILZKr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171110221053.3549147-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7AfkfStYJxYILZKr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 11:10:31PM +0100, Arnd Bergmann wrote:
> As Dan pointed out, the rework I did makes it harder for smatch and other
> static checkers to figure out what is going on with the uninitialized
> pointers.
>
> By open-coding the call in create_udata(), we make it more readable for
> both humans and tools.
>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Fixes: 12f727721eee ("IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_std_types.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--7AfkfStYJxYILZKr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloGwQEACgkQ5GN7iDZy
WKcIOw/+KPEqEybCJl2f4IBmQe1yLyFvl3gBUVS9LNhCjOrqGAUjxo8M/GBAqu2W
J7W9jaBcs+zDnN7FO5JgoyHzHsD4U4CTZfFK5jjCPmWre0I5rU7t7i1sOeSkJOH0
OdUHFWjXAPVyShJFqdCB7fUwVNiMNr3ePnAv+tKyxwlCBetMXyf1+aPayZKlGAlX
KvM+beb/P5JOKFOSIAy36RYkfrHesS/a2FXF87CIuqaQhs1VOuhP2SPi0ibFQ+2+
HO9SHkoyQlLwJct1klrQS6zvaGKeCiFmjK550c/QdawoGVfIMz53Gn5wvneYUpIy
jCMoompMd8HwXn0KmZhy0ZPckOJs9wTrXgv2kzBdOEW8ruP3iQPSE8sV38HEplbZ
davBQaPSMTTGEwF+3JPZR0/KKywmYEPoq5ss5PLZh2X/7NbVMGvFPDvAKnGRkKP7
bPQyxpHfG2aQtJMqI6HGFKYLVXtYRgSeyl6rjsQbnnxdWi4SjLbm1mZYBxCsttn6
Cj8a7wLN27EXUHeE9f7VOmYUn5SZdRxKQMs87NG4oLqZcaw7BqFW58ZFHo31cGti
H/Le4VZwRMhHNZ9MFlI4YuRvPfKXyHDybEaKAPlDRR5yJ821F8pDDrkyWMUWU6rp
6qXu8vdb5qi1fWn8h7cwxuT4KdJQnjHB82zyK3Qhll7Jhs+rXto=
=ZHXs
-----END PGP SIGNATURE-----

--7AfkfStYJxYILZKr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
