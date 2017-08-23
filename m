From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next v1 2/2] RDMA/vmw_pvrdma: Update device query
 parameters and port caps
Date: Wed, 23 Aug 2017 12:09:20 +0300
Message-ID: <20170823090920.GN1724@mtr-leonro.local>
References: <cover.1503468979.git.aditr@vmware.com>
 <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uVnQoIow9AuRQRua"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--uVnQoIow9AuRQRua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 11:19:01PM -0700, Adit Ranadive wrote:
> Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len
> and the IP_BASED_GIDS port cap flag.
>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 9 ++++++++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   | 9 +++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> index 3a308ff..df0a6b5 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> @@ -149,6 +149,13 @@
>  	((_dev->dsr->caps.mode == PVRDMA_DEVICE_MODE_ROCE) &&		\
>  	 (PVRDMA_IS_VERSION17(_dev) || PVRDMA_IS_VERSION18(_dev)))
>
> +/*
> + * Get capability values based on device version.
> + */
> +
> +#define PVRDMA_GET_CAP(_dev, _old_val, _val) \
> +	((PVRDMA_IS_VERSION18(_dev)) ? _val : _old_val)
> +

The current macro implementation will require you to go and update all
the places once you will move to new version. In simple case, everything
is supported and you will change your check of PVRDMA_IS_VERSION18 to
something PVRDMA_IS_VERSIONXXX and it will work.

In more complex case, when one of the features is supported in one version
but isn't supported in another you will need to add "if(specific_feature)" magic
into it.

>  enum pvrdma_pci_resource {
>  	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
>  	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
> @@ -251,7 +258,7 @@ struct pvrdma_device_caps {
>  	u8  atomic_ops;				/* PVRDMA_ATOMIC_OP_* bits */
>  	u8  bmme_flags;				/* FRWR Mem Mgmt Extensions */
>  	u8  gid_types;				/* PVRDMA_GID_TYPE_FLAG_ */
> -	u8  reserved[4];
> +	u32 max_fast_reg_page_list_len;
>  };
>
>  struct pvrdma_ring_page_info {
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> index 2851704..48776f5 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> @@ -83,6 +83,8 @@ int pvrdma_query_device(struct ib_device *ibdev,
>  	props->max_qp_wr = dev->dsr->caps.max_qp_wr;
>  	props->device_cap_flags = dev->dsr->caps.device_cap_flags;
>  	props->max_sge = dev->dsr->caps.max_sge;
> +	props->max_sge_rd = PVRDMA_GET_CAP(dev, dev->dsr->caps.max_sge,
> +					   dev->dsr->caps.max_sge_rd);
>  	props->max_cq = dev->dsr->caps.max_cq;
>  	props->max_cqe = dev->dsr->caps.max_cqe;
>  	props->max_mr = dev->dsr->caps.max_mr;
> @@ -101,8 +103,14 @@ int pvrdma_query_device(struct ib_device *ibdev,
>  	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_REMOTE_INV) &&
>  	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_FAST_REG_WR)) {
>  		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
> +		props->max_fast_reg_page_list_len = PVRDMA_GET_CAP(dev,
> +				PVRDMA_MAX_FAST_REG_PAGES,
> +				dev->dsr->caps.max_fast_reg_page_list_len);
>  	}
>
> +	props->device_cap_flags |= IB_DEVICE_PORT_ACTIVE_EVENT |
> +				   IB_DEVICE_RC_RNR_NAK_GEN;
> +
>  	return 0;
>  }
>
> @@ -143,6 +151,7 @@ int pvrdma_query_port(struct ib_device *ibdev, u8 port,
>  	props->gid_tbl_len = resp->attrs.gid_tbl_len;
>  	props->port_cap_flags =
>  		pvrdma_port_cap_flags_to_ib(resp->attrs.port_cap_flags);
> +	props->port_cap_flags |= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS;
>  	props->max_msg_sz = resp->attrs.max_msg_sz;
>  	props->bad_pkey_cntr = resp->attrs.bad_pkey_cntr;
>  	props->qkey_viol_cntr = resp->attrs.qkey_viol_cntr;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--uVnQoIow9AuRQRua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdRkAACgkQ5GN7iDZy
WKexoRAAs1WyHhtMXH5mQ8lUqyOL36IXHYQIgE0/zu4nURppumDWHmr2aTpGsRYC
SzK6GOSoVxivjhRWcZpSKo5FROo5NPeHjJeYR9wkGzvC0zh6825pWz1NtLeYA9Fr
jPQDsJz+3dJ3llg2OTK5lnbNhiwrkL6IUhpqq3jjQZldSG5qM4UbXp37TLasq7qX
rT8G0SNugemlVc06avlTuehU5EJvRpzpS7JvBuX+NnKMWS1hfvl6NX771kxKn7KL
VyVbkwbtQTrr5p1NxsnKi2tiOn0AS3v1YC0eRS7N9+4fHPt86LsSisnA29HglKn1
miTIqAgUeOqxlTY2rlASQkMO4UNLgdwDWra9t1YGxYfIvfOj+YrqPSwWX0r5R5un
rFL5xYUhpCLugBelphmvpQu5SAxxvvj3+r0R5W4mg0Mp02rZj6s7LgBkVZA1hZk/
5M9XPSubtMtBpRZDoQ1nhBPMDqVWeZ36p7922OyKXAPvI59Akx6Gi9BI1XVFQ1+B
1/watWoZvBCnnLjWK6H+idiEY1UfSSPfkitDEKpufDkA0cu+CKPIp69EjuZ/1P4A
MTKL+zt0OT2gEOs1YQELn3bkoBqGFVdJVEVMypSqlSwFJSHRRtWge6NZ2E1f0z+Z
z5GrGN2cjFKWR0TAdR+C5SjtyHh2+ZIOdnOcrejzgWdU1skjAks=
=kKYb
-----END PGP SIGNATURE-----

--uVnQoIow9AuRQRua--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
