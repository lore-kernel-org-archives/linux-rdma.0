From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/rxe: add the static type to the variable
Date: Sun, 7 Jan 2018 15:38:33 +0200
Message-ID: <20180107133833.GB6823@mtr-leonro.local>
References: <1515326928-22282-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515326928-22282-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 07, 2018 at 07:08:48AM -0500, Zhu Yanjun wrote:
> The variable recv_sockets is only used in the file rxe_net.c. So
> it is better to add static type to it.
>
> CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_net.c | 2 +-
>  drivers/infiniband/sw/rxe/rxe_net.h | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpSItkACgkQ5GN7iDZy
WKdD3hAAkDAlYe6kNNazwjrtxN7X6ttXem5U7N1i7ix1Uj0pcYZ09klJ6sSkA3YG
ERZRgaakHR6KaeemSNvBWayc3lbW22UAbh5lHKqKGosp5dFR7eVPNIpsADY1J6q1
t1HABxb8AmvC+0xiQ2/XrXpz3SVTCeKat23Pswn6dd+29gPoX7ZeoVaa0SfTclNg
fNweUWZkoyPt1Ge0yv+zzzqTenGN97gOb4cQZNVQL51UD9MhGpIJXaZ12Ha9gxVL
p8yhwU0bpfI6PXnpoTPzAEtUw7tg+KM/xROikvOEFTX/9ifradoTO47o+RFxe8Nz
bm9Sdy4JUiUjZgp4xRT8nrN1G2TSWNQJD4zlPQwWg2CtbWWHLSQjCW+wExbEaC8A
46i57eAVE+s4qjm+Pft//HlNG7ARZq05TGHDA/14Pi5g+HgO/xyzykRn9EYDh/ip
b2uw45NkvsBZPf1dHk2kU9T6D2Tsju53pbTUt/rCAqajWY1CCKWt5fnTRiw2XK6M
BWo6XrVLV6hM59sLxmKkRMgkROiMIM2EX9cw+s3SqdyzQtMiUn5YvcTII89jt6FY
yhl6bZ5i0s9y6nWOj/3u+CwcR0432FdOtz4XeHlPhX2QKA/STJlaGnYTrIO+gJRr
8B5nfFzbiIZ95y2jEhTJT6+FfkOB190XELnkcOAbhpuPnRVRQLQ=
=9VmQ
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
