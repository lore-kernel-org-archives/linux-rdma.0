From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next v1 1/2] RDMA/vmw_pvrdma: Add RoCEv2 support
Date: Thu, 24 Aug 2017 07:33:52 +0300
Message-ID: <20170824043352.GC1724@mtr-leonro.local>
References: <cover.1503468979.git.aditr@vmware.com>
 <91bf53451b8618acc731f6b8b4235103abae7687.1503468979.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VnCKLxguT6BBzdXa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <91bf53451b8618acc731f6b8b4235103abae7687.1503468979.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VnCKLxguT6BBzdXa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 11:19:00PM -0700, Adit Ranadive wrote:
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>
> The driver version is bumped for compatibility purposes. Also, send correct
> GID type during register to device. Added compatibility check macros for
> the device.
>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  2 ++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 28 +++++++++++++++++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 36 ++++++++++-------------
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c    |  7 +++++
>  4 files changed, 51 insertions(+), 22 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--VnCKLxguT6BBzdXa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmeVzAACgkQ5GN7iDZy
WKfiTA//aCW029423v5yCuTIgk7f+WRChVc0awB+Yv2vfCLYqGljmtvJ8Z+V3AcZ
dCv0SyvQnQNGCAhkt9I6OyQe9RZkxQ6sWQAPgJbQCWKDJYc0A0+ztGCET05+m323
GMwk48QqtNT3Fsp9qGOs/uNhVnj9dLJsLGnX19TmgsXMNs6+hmnJIcqnyL1Sph7H
AduzIa5DrlT7Szfbl2NmK5HF1ujO/D/l0mXUVPVPg3RxuDKw42Edrv08/37nNK9t
JqGdYuvEhgqNrE7MIZRB75w/zqJJ3A0PSu9qJMohsW67ksKCDCJaFZdJNfNEXcHH
Uzf0rW0hflFwlcx2QO1jZIiKl8wW6e1Gr4Yvz86sM4cYaI9lLZ7QVzuI47NYhpLO
tZd+wE0T8J69NeuBkfKqdXTPW+tMdyl1kJ6mayy8RZWhOwriGQs4K/aNbo4QzFnw
3Q+WVeywIJdmjgSI+773HxUyYi/l9VDd5r1qNnB6pY+Qf5ciyvRSf/7YAuA7fzJF
QWmoISWIvD1r980g6OQe5qHKbA9kPZ/ey7mIFj1sherpB0Q2DoF6TKzE42I1sW2D
2PXexaHdNKBLnbwLhxW6D7hym5MxGO0SsQhg9FHRKhtrO4cnuVJq+6PrTErkSoKM
dhmCwtM3jkuM5Zw4OAoPCNLC8zKTzRiZsMDnYLeZZWaqTclHvc0=
=oEqg
-----END PGP SIGNATURE-----

--VnCKLxguT6BBzdXa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
