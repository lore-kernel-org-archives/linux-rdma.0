From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next v1 00/13] Verbs flow counters support
Date: Sun, 27 May 2018 19:22:31 +0300
Message-ID: <20180527162231.GC3085@mtr-leonro.mtl.com>
References: <20180527102346.15149-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180527102346.15149-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 27, 2018 at 01:23:33PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog v0->v1:
>  * Decouple from DevX submission
>  * Use uverbs_attr_get_obj at counters read method
>  * Added define for max read buffer size (MAX_COUNTERS_BUFF_SIZE)
>  * Removed the struct mlx5_ib_flow_counter basic_flow_cnts and
>    the related structs used, used define instead
>  * Took Matan's patch from DevX
>  * uverbs_free_counters removed void* casting
>  * Added check to bound ncounters value (added define
>  * Changed user supplied data buffer structure to be array of
>    struct <desc,index> pair (applied this change to user space also)
>
> Not changed:
>  * UAPI files
>  * Addition of uhw to flow
>
> Thanks

Sorry for the noise, but please drop this series.

We found improper locking sequence in one of error paths which can be
triggered by the user.

Thanks

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbCttGAAoJEORje4g2clinTn4P/iOfDh83t5pIfG6DwK+hDYGA
bMxriU7uOrXU62SShRSG4A7AK9yKl8DBGy8HnklYLGnYWrxDW326qlI4Zr3JHjzM
ofoF88P6dnqq2HhbJNzGIQS2PRsmkD/7ehxlWuGGHlzeqvAF4QlD/2RuFwfqLenI
hrbysLMD3oYfz14wpO1GukthXaWY4sdyO+kXQA4kH0DrMrNI3d0pXgZwMp9syXS6
bHESiW4zDRWqXxDmdAF9S4q+hJTlR4MulCHefq0ZIK9iOKhKShoHlRhpAwk8Qpkk
+/gsQw1ri8+eyESSxzJ1dqc1qHQn2iRQZXg08qRzq/mlk9f8uCq+Kkk/b+QG1iID
RiQfO1jstBLWwirPHgHuDIhb2AgU7LiiEDXncom6mpyRfgnOGsoda2OwnosCLWwW
u4eMpdb4JtJ3hhBiqAgZtbo9KY6K3nY/NOT8HGLH5kUqNuQwWf63cIvqrHZBK6bD
Qt+V8gyyqwPKof/3qKAOUapIw6U8EB63TnSU9XXaq3pxmcKu70hmQlZrim0SEOCq
KrPXA+/I5y1hmIc1yukdgFMcnAii6eOwnsTUZZAewLQUH1JkJVvJh1Y4DyusYt4H
wrFi28GZ2+dUfTN6/bk18xd4TVYpXtjxo1vzsIa7pLqOn7zUcBEuljIvWbBAC1BV
Z4To0iC5aFdYspIa8Gn0
=M6MU
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
