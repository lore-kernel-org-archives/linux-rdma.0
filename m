From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: remove the unnecessary memory free
Date: Sun, 12 Feb 2017 19:22:32 +0200
Message-ID: <20170212172232.GG14015@mtr-leonro.local>
References: <1486709322-19362-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GdbWtwDHkcXqP16f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486709322-19362-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GdbWtwDHkcXqP16f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2017 at 01:48:42AM -0500, Zhu Yanjun wrote:
> In the function ipoib_cm_nonsrq_init_rx, the memory is not
> allocated successfully. It is not necessary to free it.
>
> CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--GdbWtwDHkcXqP16f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAligmdgACgkQ5GN7iDZy
WKcJsxAAp7Vvv3Z9HNgkAv4FU/oxWip+ti7rbrAgWPbXp0zE+gT6g5v0VWyYXhUa
Wt0LxowbAtvyLD9wFceF/4PjTssg5TYvaN/IrbF9HXlLhLSok42jxqRjFdnVhUTc
CrFUiGTEh6oJm17BjYl/CEKXUxTShhgCZCReuyFRB4nOW5H6paYzz/ODmxTcrKL3
goCeoCAL6tEJ9k23qavNqadqfLHdE/qEYux07TaQiWz3L9XxbtXm3flKV+ME54al
hInhJ6yJF1k+1s2wXgBALEG/uvcDAwH7vlTSITNnTVW0mvszRA3MkOgRxK3mhPQQ
xnnY0ZVRnoXUzfcSelMXnklnB87YVIZfb3efdRv9yAyFyALBPbNhpvbNT5co9g8L
kBY4bt7cGELHrF19rH1lsLPffkWuSe4/olqk7EULyeP9Xm8AhK/nxqy7sWCu7g1Y
AyfVdWgyoP8qZc5hgsf/O77B+3CA8E5K4Gkwjnngt6MrTBQV0PeM6WapAxishmbY
AkEon47+Jn5ogYlYsHrcO8bQDdyZhPHGa7GiaqTKxkulMvcMKeKhbI7MPN4ltDCu
VWKq3RMI7cQLsDHgTh41Adxvjz1F2uvGjBRXq1axKEeAtGbkkFkpwbuYZSQStRbq
0MZoR475nrRIAVhuedthwWQn+DcIeme5h7Si73LGY1K2QfWRUEQ=
=YVim
-----END PGP SIGNATURE-----

--GdbWtwDHkcXqP16f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
