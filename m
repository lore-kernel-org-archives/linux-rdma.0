From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v1 rdma-next 6/6] RDMA/nldev: provide detailed PD
 information
Date: Wed, 14 Feb 2018 15:33:30 +0200
Message-ID: <20180214133330.GY2197@mtr-leonro.local>
References: <cover.1518552800.git.swise@opengridcomputing.com>
 <f272bfd34c913d540bd74008cccfa2544d8e100f.1518552800.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ucfHZChuBC0NsER/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f272bfd34c913d540bd74008cccfa2544d8e100f.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ucfHZChuBC0NsER/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 02, 2018 at 01:24:44PM -0800, Steve Wise wrote:
> Implement the RDMA nldev netlink interface for dumping detailed PD
> information.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/nldev.c  | 173 +++++++++++++++++++++++++++++++++++++++
>  include/uapi/rdma/rdma_netlink.h |   8 ++
>  2 files changed, 181 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ucfHZChuBC0NsER/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqEOqoACgkQ5GN7iDZy
WKeB9RAAhTI+hJFJGxkKjZhazSwersntLRrEYLQQCwNrPyc1SWZU/UJhv41YP/Cm
6Y0JupYRcqpCYbj1tvU2srtayM/5D9YaOZtb1V3LBpyHPCYLZdEQU+r/O1qWBGfp
OVJNbq1eAExdaHJkBoCy2IcdFvJaBQcQlzxFyMFQqydBWszPDQUNlt8TklctpGGl
kmfEAk10QVEbKK5fO8GC6cLjOZKBM6ZGzASSnigZBwbQlwd/b/AjCVUStY8HfO3F
7EGUZTWSi/rvutFFm0Pw5gROfhjHu6QSh9mKcthPe+Jmmen3kJWNeaVHYV9AcgJc
p5uWTmgN4r0vDl+rl3eaMlrpKEeanoTQcD8uhBke4gNkDSnC9iK1ubmtL++ox3km
vUBkgI4qYyrtzhXqefwNprktw7lGk7dihIoPhhJTW4pjYITqWtsCsspvwzRhEYwT
NQ/FKIlFBRJH9FHv2DE8uwcqD6z6sbBelaJ21M3a+B14onEx/JOW4zywWCErbUqm
8zOZG2JvNhjYQgDBZTuU4hwdD2P+67J3vaLLq713UbuzivtjW4FZLYAeKMnVAqA+
De/sLA7XUP2Qy9KKdRo6yc4YPWUT7vsO7hltef1ZlEcfQv+4hcf23KYuU4fOR6uo
jEoGBONA7RZYzd5GWLMquDjRHCATln/0irFE369Lsb0faF19AK8=
=kWHO
-----END PGP SIGNATURE-----

--ucfHZChuBC0NsER/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
