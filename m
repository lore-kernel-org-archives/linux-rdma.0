From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/15] IB/pvrdma: Add virtual device RDMA structures
Date: Tue, 26 Jul 2016 08:46:29 +0300
Message-ID: <20160726054629.GF20674@leon.nu>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-7-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="slMCvwAS3D50yFKj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468352205-9137-7-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--slMCvwAS3D50yFKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 12:36:36PM -0700, Adit Ranadive wrote:
> This patch adds the various Verbs structures that we support in the
> virtual RDMA device. We have re-mapped the ones from the RDMA core stack
> to make sure we can maintain compatibility with our backend.
>=20
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h | 450 +++++++++++++++++++=
++++++
>  1 file changed, 450 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h
>=20

=2E..

> +enum pvrdma_wc_opcode {
> +	PVRDMA_WC_SEND,

=2E..

> +	PVRDMA_WC_RECV_RDMA_WITH_IMM
> +};

=2E...
> +
> +enum pvrdma_wc_flags {
> +	PVRDMA_WC_GRH			=3D 1 << 0,
=2E...

> +	PVRDMA_WC_FLAGS_MAX		=3D PVRDMA_WC_WITH_VLAN,
> +};
> +

Sometimes you put "," at the last line of enums, sometimes you don't.
Can you please be more consistent?

Thanks.

--slMCvwAS3D50yFKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlvk1AAoJEORje4g2clinbrkP/j7tDth8eeHYoEjeQreBP+Cu
Lw6grWb8FfCuBHds2fCVoJsQOh1C6EuqjcBGyMRJOZKF8k+ChTMX2Rhnr0w5Zknc
vkwN5zwyjwhYfQDTjFi/vFAqXfJkJKkAqVDEHD8zzsy3MOzvDfBacdE2Iv6SsThz
RyBg3v/AKAanp7o1zkybWa14ZRZoYAMF5Y43qpk/aUvzFQR1dM955bdIu/PrHOTQ
TUTp8cr2PO/JXwo1wYEpWhJ6KJUd7cXQAa9NeC8IGvVHBD4gf70OXrz/4R0yvwYY
Oc9j9HO4yJ+Mo4h9JPDi7LLbMTu31dVeEEiR5uGZnB1CqPFln/i9Ai1UTVT69f1L
dfFkpMn8Vw8WQhOMj/CAHGudP6ytzuqEBZHTetk4rnMyb8vYeozCFwuHYAUDzzsz
cI759aPQdJEHdfGLFJVqBG6GH3wlkweC1pfcu6ifSOKTXoPGWi5hta/5n9oHR4xH
KRXcgqWXZCq1s31M22ZQ9LCVkKN865Pv94BxKGtoyrh6+Qgwb6pXS5hqOeUfUXwe
kfpXnW4fR5H8ReaPuD62BiQLJBlKmh6cn3OpYyM6M/ugIwBeNTXxUuo392o8EO7v
SlIrFnFhaugKwr+0IMJzJXcBloGAydELmE7ycElCmUcGjwOUD6J517KbH7l38tLa
StE/DA6xYNic7nEgX3Oc
=uiWu
-----END PGP SIGNATURE-----

--slMCvwAS3D50yFKj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
