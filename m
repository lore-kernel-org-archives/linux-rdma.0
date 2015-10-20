From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] IB/cma: Use inner P_Key to determine netdev
Date: Tue, 20 Oct 2015 03:20:57 -0400
Message-ID: <5625EB59.4020304@redhat.com>
References: <1445323981-28582-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fiH8ae5iJ2cuNxEbubwgRfxNaFpotR6gc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445323981-28582-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fiH8ae5iJ2cuNxEbubwgRfxNaFpotR6gc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/20/2015 02:53 AM, Haggai Eran wrote:
> When discussing the patches to demux ids in rdma_cm instead of ib_cm, i=
t
> was decided that it is best to use the P_Key value in the packet header=
s.
> However, the mlx5 and ipath drivers are currently unable to send correc=
t
> P_Key values in GMP headers. They always send using a single P_Key that=
 is
> set during the GSI QP initialization.
>=20
> Change the rdma_cm code to look at the P_Key value that is part of the
> packet payload as a workaround. Once the drivers are fixed this patch c=
an
> be reverted.
>=20
> Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to
> RDMA CM")
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes from v0:
> - improve commit message
>=20
>  drivers/infiniband/core/cma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
> index 59a2dafc8c57..e8324543e085 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1067,14 +1067,14 @@ static int cma_save_req_info(const struct ib_cm=
_event *ib_event,
>  		       sizeof(req->local_gid));
>  		req->has_gid	=3D true;
>  		req->service_id	=3D req_param->primary_path->service_id;
> -		req->pkey	=3D req_param->bth_pkey;
> +		req->pkey	=3D be16_to_cpu(req_param->primary_path->pkey);
>  		break;
>  	case IB_CM_SIDR_REQ_RECEIVED:
>  		req->device	=3D sidr_param->listen_id->device;
>  		req->port	=3D sidr_param->port;
>  		req->has_gid	=3D false;
>  		req->service_id	=3D sidr_param->service_id;
> -		req->pkey	=3D sidr_param->bth_pkey;
> +		req->pkey	=3D sidr_param->pkey;
>  		break;
>  	default:
>  		return -EINVAL;
>=20

And, to be clear, you are looking for this to be part of 4.3-rc updates,
yes?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--fiH8ae5iJ2cuNxEbubwgRfxNaFpotR6gc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJetZAAoJELgmozMOVy/d4f4P+wYHoq5KdgPu69Q3YFxMuTcT
oXHexvZ5QmYhvQOO/kLAxzqSqFuF0HeU3GSisAQBnZf7DrxaXDQ2hvdut551HhvV
oWXRJDrnWqEiQzaCf24+/kCjY0ZN3o/ffaSImh3Jii/r8txO4oIe+x/5ju2Hy7Ua
iFmD1xjwtpEX2toYAtHthwLqOP0hiZfBKuA86S+lvvasq5hQHNQHL4yp+J8COEYr
lKa85+UNBfXpE27EFeVRVc6PqJ0eJ0trAMSvfYlAQ6KPu1o7H03aZOOnMN42HJZq
PfHOKrdricuWJoffCWJZt+954R/q0WyCkaC3H6h9lDxbZeaxSHrGzuoRtSv5rp1E
/kJApdXodhgq0NtxMbmeGWOAOVOLlqbtInemjC0ySdmV/TtycpxJtgvMOTQiRgXn
nSG6d7x6ypIVBwIuWgMXAENqlteKV9PVVVlAucvZwrRrtMWtoTx43Xk9qc3gdQ9n
/8PrTg6yehTMvj9h7JFFm8gxRQp9nVgghH9CoklyJhRVeysVa4E6dqP3U5oQqXQY
naB0j/10iVsWTJOKm87NxBBhCTP/DUikkna2hn8UL55dG4rfccEE+WNNpxaeldQd
bVdeb46Fbo+xWBcLBD5jElw8yboecTL1DA6YxNbguru45TpIpODvNzotCeGIPN6m
2at5Ybvikt0W95ZXpPF4
=vcUt
-----END PGP SIGNATURE-----

--fiH8ae5iJ2cuNxEbubwgRfxNaFpotR6gc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
