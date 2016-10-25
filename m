From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
Date: Tue, 25 Oct 2016 08:40:29 +0300
Message-ID: <20161025054029.GM25013@leon.nu>
References: <20161024204830.620592-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DRfr/2Y1Zz/5r+Kb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161024204830.620592-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--DRfr/2Y1Zz/5r+Kb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2016 at 10:48:21PM +0200, Arnd Bergmann wrote:
> We get a false-positive warning in linux-next for the mlx5 driver:
>
> infiniband/hw/mlx5/mr.c: In function =E2=80=98mlx5_ib_reg_user_mr=E2=80=
=99:
> infiniband/hw/mlx5/mr.c:1172:5: error: =E2=80=98order=E2=80=99 may be use=
d uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1161:6: note: =E2=80=98order=E2=80=99 was declare=
d here
> infiniband/hw/mlx5/mr.c:1173:6: error: =E2=80=98ncont=E2=80=99 may be use=
d uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1160:6: note: =E2=80=98ncont=E2=80=99 was declare=
d here
> infiniband/hw/mlx5/mr.c:1173:6: error: =E2=80=98page_shift=E2=80=99 may b=
e used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1158:6: note: =E2=80=98page_shift=E2=80=99 was de=
clared here
> infiniband/hw/mlx5/mr.c:1143:13: error: =E2=80=98npages=E2=80=99 may be u=
sed uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1159:6: note: =E2=80=98npages=E2=80=99 was declar=
ed here
>
> I had a trivial workaround for gcc-5 or higher, but that didn't work
> on gcc-4.9 unfortunately.
>
> The only way I found to avoid the warnings for gcc-4.9, short of
> initializing each of the arguments first was to change the calling
> conventions to separate the error code from the umem pointer. This
> avoids casting the error codes from one pointer to another incompatible
> pointer, and lets gcc figure out when that the data is actually valid
> whenever we return successfully.
>
> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 39 +++++++++++++++++++++--------------=
----
>  1 file changed, 21 insertions(+), 18 deletions(-)
>
> v2: fix whitespace typo

Thanks

--DRfr/2Y1Zz/5r+Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDvBNAAoJEORje4g2clinlv4P/RDiVJ9GodRnxi8V1wdCalo7
s6Dd09JTYoHShZ9O+NbW5dmCjnt+rCiiFutQaGszwJ6NR7O+HJ9MjK3N2AYCqRAk
kVDYKsSLyvOQ1kvb4XihrteRXa8oJnEAVvlPz0n6NJeyIIgOMzlTg/00tvoixumd
7kTHts5ZsWto8kXj5HLmaGxbDwtQn4xewcqu6MMoe9RW2eabFTqj8pYlSBzIl+86
JUMSSPFN+UxKQ++ewiv93ZH57Ob630yDGw8i/yGXOIHM3V8AfTnDUKTomc/nqdH2
ngP+r1jSDQmLk4He1cF5fVrTJBOiSrC0osdLY1AS1+QOlUqeFiOUoM4HVD3/kqiN
tgCQE0oveLXBCT+uAR2XNsE4rEstU/huL73gtuf6RXmJuZWjSmMFvnR24Vh+N/vo
RimLUX+nRQ+ktd/mk+P8Mly4TiV64VDOhlqLg8Pc8UahuVdEzuhBL2ocZvMYEU5S
kVNPcCJCxjZv0Ub7+wAtyb2KrXmmV6tgYDVJslOpC4Wo+EdF8dEdHjE2++xAp6Dp
TuVxcbh760LMgRvtVB8XD4P6w14OGcf5tjQ9xMtqdmHPHzECFJJznlKZ9LPimjBI
nRr2jXR2G1dEX215I+tijC2xg0aCfacQbXQBKcaLFbR70RjHdRsIpx/ddw8GG5ol
zugW/RkWDVZREg2i+5yA
=6Jga
-----END PGP SIGNATURE-----

--DRfr/2Y1Zz/5r+Kb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
