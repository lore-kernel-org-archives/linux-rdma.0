From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-core/rdma-ndd] Use integer as getopt_long returns integer
Date: Wed, 26 Apr 2017 09:21:39 +0300
Message-ID: <20170426062139.GW14088@mtr-leonro.local>
References: <1493099392-1883-1-git-send-email-honli@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yQifGgTvVVJcdOYJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493099392-1883-1-git-send-email-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yQifGgTvVVJcdOYJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 25, 2017 at 01:49:52PM +0800, Honggang LI wrote:
> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> ARM chars are unsigned by default. getopt_long return 255 instead -1.
> That will cause an endless loop for aarch64 platform.
>
> Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  rdma-ndd/rdma-ndd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c

Thanks, applied.

--yQifGgTvVVJcdOYJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkAPHMACgkQ5GN7iDZy
WKfkoRAAmY1bUdZBzk8szuxvv3pbEU40VQru2bpoqpF+p97UOyb2aQSx07zCgdps
5ZfWmfamV1e/H5QEfutkbIICFPJrMmpKFQlc4M7DjU3KN45Tc0aOO6th3Q8jETEx
Ebmfu1uhUNMQVEZQYhMLSeqZzdFGZAWCtNYaQHaXYo0/5U8ILWnSE9xDvWlwZaK5
zcZqix6SambPHvQoct4MKkcwMEp07KPcJ4E8wOm16Gw9eSC81qkynn/yhblNWUic
eS41v8uqnltdSf5+UGANak2H6sqZr69yhjlCSSTtZOoyBHFEqKedLYuojp7szXQz
eSsrawcDu/jYR15KV1/C89zFZB9FZSt86wbOSQ5La37VeO4WSt5uRnCoxciQfNsx
gP9cQXszEDcrgI9ZdObPkYEv4WEFzYTe9O6X3ZhcnyEtKm/GbPip++Bt4saIGv9s
uZ3qJy6JLENilcK0yLqpK7siUyN/RIAHg2/2QOt3yJ2HB2DQSKD27XT269XlZOim
URKKiV9ClYHFuoB8jotT24RkDeAfN0lwrBPF1zbrqKl9q9LiFv+pWKf2EhgN2UyR
nA9bfFYp8nzVv1crvPZc5/chgZvIM/pBPdvrs5swS9cRj5b9svbZYM4ZB8/dehyM
Qf05t1ateZrW092Bz7vIefVoGbMd4smyP1ZmC9A9d3T17N6qRP0=
=JICN
-----END PGP SIGNATURE-----

--yQifGgTvVVJcdOYJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
