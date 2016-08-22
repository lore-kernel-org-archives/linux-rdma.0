From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: display ocrdma tech preview status
Date: Mon, 22 Aug 2016 14:54:55 -0400
Message-ID: <a96c1f64-7911-1f96-3a99-2ccedff238a9@redhat.com>
References: <1471521740-28353-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Lalr930vVCnN6e458vS4bwN89H11P7rdh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471521740-28353-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lalr930vVCnN6e458vS4bwN89H11P7rdh
Content-Type: multipart/mixed; boundary="6cGGwWMaEjTgtmv7ScM7lftKS67vQ6v49"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <a96c1f64-7911-1f96-3a99-2ccedff238a9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: display ocrdma tech preview status
References: <1471521740-28353-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1471521740-28353-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

--6cGGwWMaEjTgtmv7ScM7lftKS67vQ6v49
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/18/2016 8:02 AM, Devesh Sharma wrote:
> This patch adds a code to display ocrdma driver technology
> preview status on ocrdma module load.
>=20
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

This patch isn't really appropriate for the upstream kernel.  The
upstream kernel has no specific state of "tech preview".  I know we use
that term at Red Hat, others like Oracle and SuSE might too, and it has
specific connotations in terms of the provided support SLA for the given
technology, but those things are not relevant to upstream kernels.  For
upstream, only a few things are appropriate:

1) Your driver is in drivers/staging
2) Your driver is fully supported (from a kernel community point of view)=



> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infin=
iband/hw/ocrdma/ocrdma_main.c
> index 07d0c6c..9b8774c 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -444,6 +444,16 @@ void ocrdma_update_link_state(struct ocrdma_dev *d=
ev, u8 lstate)
>  		ocrdma_dispatch_port_active(dev);
>  }
> =20
> +void ocrdma_print_tech_preview_status(void)
> +{
> +	printk(KERN_INFO
> +	       "*************************************************************=
\n");
> +	printk(KERN_INFO
> +	       "RoCE supported at Tech Preview level in all OCE141XX Adapters=
\n");
> +	printk(KERN_INFO
> +	       "*************************************************************=
\n");
> +}
> +
>  static struct ocrdma_driver ocrdma_drv =3D {
>  	.name			=3D "ocrdma_driver",
>  	.add			=3D ocrdma_add,
> @@ -456,6 +466,7 @@ static int __init ocrdma_init_module(void)
>  {
>  	int status;
> =20
> +	ocrdma_print_tech_preview_status();
>  	ocrdma_init_debugfs();
> =20
>  	status =3D be_roce_register_driver(&ocrdma_drv);
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--6cGGwWMaEjTgtmv7ScM7lftKS67vQ6v49--

--Lalr930vVCnN6e458vS4bwN89H11P7rdh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0p/AAoJELgmozMOVy/dWzIP/32kY/EbOmSarH6ME/+ufK9M
cI+PYweM8qfzhsc5sJXtKnYOH4nIBZZMBSep52Jn6AYtEDnpvnqcX2gYy0WzH0Kw
nCXFOTLJn3cM0ErjLXeKP1VJBZkAKZNXtUUzH14L26rTPo3rzryV9ZKLsUbOuja6
l/ZYTGn1dpewSZTIYasNHewxGXmv+6KE9eyTBM9IcfW4sBS28RFFFwXoo8Ajv2Tv
CrVTKWRvw+zkFDhQ1r4A6K5lVE/Wxoas+/CQHcjYqIq8K7g/HTs6PVfxVkSrXKJa
zEX/Y/TWRF8O3bwfTkyeI3Ka7tubOhyWB0AXIlBfrVHdYeRA+mVN28M4SpK2g1J7
j2pbvnfaEUEduOFh+ZOqnblYR1zyNJ+hw1pH2lkxyvAmG6WxFBLhPnHE5JJVZwuI
qTDudD/8qny/ulKez8H9HL8of5WFgbe+29QsdFqq/Y5GN6Z+W/nLfTp61eHfgFZn
zpmyWVqwHkIoz+dF/Qtgev3I1iyDV1eQx6tPfMIpuLSh0smB+Sa2XK/wHce56s5e
TJ8XLYdI6f7V/0cgeqjmOnAsiJcH6imJUsTNnMHLS6EFvepmGPIdUycH5aiHhdDU
1iEsm9rOXBDzSxizbbdp3Evk5Sq5TGe3wyX5ruDO30r36bWzLoKrcFXPvrGhG9bV
0Ojls/Ye8oeQdwfw/0wz
=+o5g
-----END PGP SIGNATURE-----

--Lalr930vVCnN6e458vS4bwN89H11P7rdh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
