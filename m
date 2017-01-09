From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for rdma-next] RDMA: Adding ethertype ETH_P_IBOE
Date: Mon, 9 Jan 2017 09:52:50 +0200
Message-ID: <20170109075250.GW15685@mtr-leonro.local>
References: <1482175726-27366-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+OVWeTxrbAwQuiek"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482175726-27366-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+OVWeTxrbAwQuiek
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 19, 2016 at 11:28:46AM -0800, Selvin Xavier wrote:
> Update the if_ether.h with the  ethertype for Infiniband over
> Ethernet packets. Also, removing the occurances of 0x8915
> from infiniband vendor drivers.
>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c                    | 6 +-----
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c           | 4 ++--
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c           | 3 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h          | 5 -----
>  drivers/infiniband/hw/qedr/qedr_cm.c               | 2 +-
>  drivers/infiniband/hw/qedr/qedr_cm.h               | 1 -
>  drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h | 1 -
>  drivers/infiniband/hw/usnic/usnic_fwd.h            | 3 ++-
>  include/uapi/linux/if_ether.h                      | 1 +
>  9 files changed, 9 insertions(+), 17 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--+OVWeTxrbAwQuiek
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhzQVIACgkQ5GN7iDZy
WKc6vQ/8Cr6sNvCIlG4WAyZr5es907kWKSj1RwDNSwweZadhdBYvCtTJ32sSq7D0
Oj4UleATQtDichKChX5RXx4Rrl9p/K9jM0wDJnsvej00OHNjgHfMhCEhz3rB5L8s
BThqa87B+db0I7IffgTuqs3XPWfZGTlLc/vafvJ1sJsyHKdJe41PjwVUGB7ox49q
lB9RVJWV+Dhhbb5YlQCeiEhFD65A+jJitwvJYKWubkKMT4rE23qpbwxLEqduYkP0
Ufmh3Hv6a9ZFmBCMvTYQIUpKklQ3+ln3l2YKekA2aucVvqIC+a4EL4AGy6RUV7f6
GxzP3l3N0Zw2QsQ8JJe0UFh83ovjRCjvw+VDcojbBIslsQ2+RrPWMNM6HSB8SFDV
WkZLiUI3W6CCtRPvlYdqdmksdRdT7lfVZQRZOtUNZnNncgPvLdxJdiqsPzCACYX5
kNdEYdadauxQM4OAeDXbiObO5Fvk4iTkSPuOi/lSJHI4QIPG3qTIb460NxM4xfTH
KW/JLgFbOvspKt0WNWWonft+uuitD4ANM0i4TGTVdy82/imxbSk9Pm8O0rL61/kB
+OSekdySwB9BRoG4VY0+zXS8XA9c9QhLc/fe6RCg+MIMhkuSMyCf8pi0tx3fwnCc
UDmTc/r4kZnZf8EUlEUPX9GHDawIiGGE0JNLVwqNxo+bKu6fQTs=
=TKeX
-----END PGP SIGNATURE-----

--+OVWeTxrbAwQuiek--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
