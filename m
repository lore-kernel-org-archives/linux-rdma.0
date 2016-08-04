From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 07/15] IB/pvrdma: Add device command support
Date: Thu, 4 Aug 2016 07:30:56 +0300
Message-ID: <20160804043056.GI27667@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-8-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBdJBemW82xJqIAr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-8-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gBdJBemW82xJqIAr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 04:27:36PM -0700, Adit Ranadive wrote:
> This patch enables posting Verb requests and receiving responses to/from
> the backend PVRDMA emulation layer.
>=20
> Changes v2->v3:
>  - Converted pvrdma_cmd_recv to inline.
>  - Added a min check in the memcpy to cmd_slot.
>  - Removed the boolean from pvrdma_cmd_post.
>=20
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma_cmd.c | 105 ++++++++++++++++++++++++=
++++++
>  1 file changed, 105 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
>=20
> diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c b/drivers/infiniba=
nd/hw/pvrdma/pvrdma_cmd.c
> new file mode 100644
> index 0000000..45aa31f
> --- /dev/null
> +++ b/drivers/infiniband/hw/pvrdma/pvrdma_cmd.c
> @@ -0,0 +1,105 @@

=2E...

> +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_req *req,
> +		union pvrdma_cmd_resp *resp)
> +{
> +	int err;
> +
> +	dev_dbg(&dev->pdev->dev, "post request to device\n");
> +
> +	/* Serializiation */
> +	down(&dev->cmd_sema);
> +
> +	spin_lock(&dev->cmd_lock);
> +	memcpy(dev->cmd_slot, req, min(PAGE_SIZE, sizeof(*req)));

No,
We already had conversation why min(..) in memcpy is wrong.
Please reread and do it properly.

Thanks

--gBdJBemW82xJqIAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXosT/AAoJEORje4g2clinDz8QAIL2/AgsqCXz/K7v2TahwlxH
ds/oW4YZaB2aL/+hMsjqo75VbRrBabD9urG/rBHa02jA5C7txz7pZ6p38d2E8giB
szH8iRnaThnGrO5Dc+46zpwYWXdQhn654FHS7zhuEmKZ9F06dk3UbMMql60YLkTC
dOCIlZWMMN4uJLqxYTZicVzYwvEoDZn/BOk5fIHflQChWX/C+LWmA8xpG5FvxJ4d
QtO34UUlbgPYicLsoMIXvgDzKeSZA7GxepxvUogyROnJVgDyiPK/AHCptRj9XaIO
HBI8lt5B2K/jngKDe063WfHEfRXSI1+BhOOUE2d4CBX3/Nz347/Fbq1zJSqF0NPn
H6rov/Z1EOfVYMxZtudHPx1VrhBy7ec88hr7+StNcPTr3JZlCTWNizBdnPB48Uy9
8pQCgJUfYzarGBTkDvxAJwp33PMz5lUMOjFB39DqTQGnHSMPsKViOZFAF9Q1CC6b
Fv3o2Hzbyk4ZWGWqG7FX+cevwsjNVuyF8c0mXmzO+aJMrU/rlFOw795jBuqTMMIE
pKFJZa7mSNxxx8W9jjFlHcSzVFcx1gFP603U/xqv4e9m6ZfcKU6BVl7acKTQPw4B
xp9Bs0n+g9N+F901Qlt/hc9GqZ6ZKzfXw5Qsm/wyaV8kLcyaXsPn7puc3xQqtov/
h4XADPSwc2kxHPJiHmHQ
=TBTX
-----END PGP SIGNATURE-----

--gBdJBemW82xJqIAr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
