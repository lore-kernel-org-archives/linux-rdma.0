From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] pci: drop link_reset
Date: Wed, 18 Jan 2017 19:19:48 -0500
Message-ID: <1484785188.2406.73.camel@redhat.com>
References: <1484775540-8405-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-km/rawHupG5hejW5E2Um"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484775540-8405-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linas Vepstas <linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-km/rawHupG5hejW5E2Um
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 23:39 +0200, Michael S. Tsirkin wrote:
> No hardware seems to actually call link_reset, and
> no driver implements it as more than a nop stub.
>=20
> This drops the mentions of the callback from everywhere.
> It's dropped from the documentation as well, but
> the doc really needs to be updated to reflect
> reality better (e.g. on pcie slot reset is the link reset).
>=20
> This will be done in a later patch.
>=20
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This is going to conflict with the two patches I have in my for-next
branch related to this same thing (it drops the stubs from qib and
hfi1). =C2=A0It would be easiest if I just added this to my for-next and
fixed up the conflicts prior to submission.

> ---
> =C2=A0Documentation/PCI/pci-error-recovery.txt | 24 +++------------------=
-
> --
> =C2=A0drivers/infiniband/hw/hfi1/pcie.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0| 10 ----------
> =C2=A0drivers/infiniband/hw/qib/qib_pcie.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=
=C2=A0=C2=A08 --------
> =C2=A0drivers/media/pci/ngene/ngene-cards.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A07 -------
> =C2=A0include/linux/pci.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A03 ---
> =C2=A05 files changed, 3 insertions(+), 49 deletions(-)
>=20
> diff --git a/Documentation/PCI/pci-error-recovery.txt
> b/Documentation/PCI/pci-error-recovery.txt
> index ac26869..da3b217 100644
> --- a/Documentation/PCI/pci-error-recovery.txt
> +++ b/Documentation/PCI/pci-error-recovery.txt
> @@ -78,7 +78,6 @@ struct pci_error_handlers
> =C2=A0{
> =C2=A0	int (*error_detected)(struct pci_dev *dev, enum
> pci_channel_state);
> =C2=A0	int (*mmio_enabled)(struct pci_dev *dev);
> -	int (*link_reset)(struct pci_dev *dev);
> =C2=A0	int (*slot_reset)(struct pci_dev *dev);
> =C2=A0	void (*resume)(struct pci_dev *dev);
> =C2=A0};
> @@ -104,8 +103,7 @@ if it implements any, it must implement
> error_detected(). If a callback
> =C2=A0is not implemented, the corresponding feature is considered
> unsupported.
> =C2=A0For example, if mmio_enabled() and resume() aren't there, then it
> =C2=A0is assumed that the driver is not doing any direct recovery and
> requires
> -a slot reset. If link_reset() is not implemented, the card is
> assumed to
> -not care about link resets. Typically a driver will want to know
> about
> +a slot reset.=C2=A0=C2=A0Typically a driver will want to know about
> =C2=A0a slot_reset().
> =C2=A0
> =C2=A0The actual steps taken by a platform to recover from a PCI error
> @@ -232,25 +230,9 @@ proceeds to STEP 4 (Slot Reset)
> =C2=A0
> =C2=A0STEP 3: Link Reset
> =C2=A0------------------
> -The platform resets the link, and then calls the link_reset()
> callback
> -on all affected device drivers.=C2=A0=C2=A0This is a PCI-Express specifi=
c
> state
> +The platform resets the link.=C2=A0=C2=A0This is a PCI-Express specific =
step
> =C2=A0and is done whenever a non-fatal error has been detected that can b=
e
> -"solved" by resetting the link. This call informs the driver of the
> -reset and the driver should check to see if the device appears to be
> -in working condition.
> -
> -The driver is not supposed to restart normal driver I/O operations
> -at this point.=C2=A0=C2=A0It should limit itself to "probing" the device=
 to
> -check its recoverability status. If all is right, then the platform
> -will call resume() once all drivers have ack'd link_reset().
> -
> -	Result codes:
> -		(identical to STEP 3 (MMIO Enabled)
> -
> -The platform then proceeds to either STEP 4 (Slot Reset) or STEP 5
> -(Resume Operations).
> -
> ->>> The current powerpc implementation does not implement this
> callback.
> +"solved" by resetting the link.
> =C2=A0
> =C2=A0STEP 4: Slot Reset
> =C2=A0------------------
> diff --git a/drivers/infiniband/hw/hfi1/pcie.c
> b/drivers/infiniband/hw/hfi1/pcie.c
> index 4ac8f33..ebd941f 100644
> --- a/drivers/infiniband/hw/hfi1/pcie.c
> +++ b/drivers/infiniband/hw/hfi1/pcie.c
> @@ -598,15 +598,6 @@ pci_slot_reset(struct pci_dev *pdev)
> =C2=A0	return PCI_ERS_RESULT_CAN_RECOVER;
> =C2=A0}
> =C2=A0
> -static pci_ers_result_t
> -pci_link_reset(struct pci_dev *pdev)
> -{
> -	struct hfi1_devdata *dd =3D pci_get_drvdata(pdev);
> -
> -	dd_dev_info(dd, "HFI1 link_reset function called,
> ignored\n");
> -	return PCI_ERS_RESULT_CAN_RECOVER;
> -}
> -
> =C2=A0static void
> =C2=A0pci_resume(struct pci_dev *pdev)
> =C2=A0{
> @@ -625,7 +616,6 @@ pci_resume(struct pci_dev *pdev)
> =C2=A0const struct pci_error_handlers hfi1_pci_err_handler =3D {
> =C2=A0	.error_detected =3D pci_error_detected,
> =C2=A0	.mmio_enabled =3D pci_mmio_enabled,
> -	.link_reset =3D pci_link_reset,
> =C2=A0	.slot_reset =3D pci_slot_reset,
> =C2=A0	.resume =3D pci_resume,
> =C2=A0};
> diff --git a/drivers/infiniband/hw/qib/qib_pcie.c
> b/drivers/infiniband/hw/qib/qib_pcie.c
> index 6abe1c6..c379b83 100644
> --- a/drivers/infiniband/hw/qib/qib_pcie.c
> +++ b/drivers/infiniband/hw/qib/qib_pcie.c
> @@ -682,13 +682,6 @@ qib_pci_slot_reset(struct pci_dev *pdev)
> =C2=A0	return PCI_ERS_RESULT_CAN_RECOVER;
> =C2=A0}
> =C2=A0
> -static pci_ers_result_t
> -qib_pci_link_reset(struct pci_dev *pdev)
> -{
> -	qib_devinfo(pdev, "QIB link_reset function called,
> ignored\n");
> -	return PCI_ERS_RESULT_CAN_RECOVER;
> -}
> -
> =C2=A0static void
> =C2=A0qib_pci_resume(struct pci_dev *pdev)
> =C2=A0{
> @@ -707,7 +700,6 @@ qib_pci_resume(struct pci_dev *pdev)
> =C2=A0const struct pci_error_handlers qib_pci_err_handler =3D {
> =C2=A0	.error_detected =3D qib_pci_error_detected,
> =C2=A0	.mmio_enabled =3D qib_pci_mmio_enabled,
> -	.link_reset =3D qib_pci_link_reset,
> =C2=A0	.slot_reset =3D qib_pci_slot_reset,
> =C2=A0	.resume =3D qib_pci_resume,
> =C2=A0};
> diff --git a/drivers/media/pci/ngene/ngene-cards.c
> b/drivers/media/pci/ngene/ngene-cards.c
> index 423e8c8..8438c1c 100644
> --- a/drivers/media/pci/ngene/ngene-cards.c
> +++ b/drivers/media/pci/ngene/ngene-cards.c
> @@ -781,12 +781,6 @@ static pci_ers_result_t
> ngene_error_detected(struct pci_dev *dev,
> =C2=A0	return PCI_ERS_RESULT_CAN_RECOVER;
> =C2=A0}
> =C2=A0
> -static pci_ers_result_t ngene_link_reset(struct pci_dev *dev)
> -{
> -	printk(KERN_INFO DEVICE_NAME ": link reset\n");
> -	return 0;
> -}
> -
> =C2=A0static pci_ers_result_t ngene_slot_reset(struct pci_dev *dev)
> =C2=A0{
> =C2=A0	printk(KERN_INFO DEVICE_NAME ": slot reset\n");
> @@ -800,7 +794,6 @@ static void ngene_resume(struct pci_dev *dev)
> =C2=A0
> =C2=A0static const struct pci_error_handlers ngene_errors =3D {
> =C2=A0	.error_detected =3D ngene_error_detected,
> -	.link_reset =3D ngene_link_reset,
> =C2=A0	.slot_reset =3D ngene_slot_reset,
> =C2=A0	.resume =3D ngene_resume,
> =C2=A0};
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 30d6c16..316379c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -661,9 +661,6 @@ struct pci_error_handlers {
> =C2=A0	/* MMIO has been re-enabled, but not DMA */
> =C2=A0	pci_ers_result_t (*mmio_enabled)(struct pci_dev *dev);
> =C2=A0
> -	/* PCI Express link has been reset */
> -	pci_ers_result_t (*link_reset)(struct pci_dev *dev);
> -
> =C2=A0	/* PCI slot has been reset */
> =C2=A0	pci_ers_result_t (*slot_reset)(struct pci_dev *dev);
> =C2=A0
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-km/rawHupG5hejW5E2Um
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYgAYkAAoJELgmozMOVy/dQ7wP/3+2/QI8ZdmtTQVd0mdi8qSf
HC+KjY/f1cewrV3lU/YYhtZYtCe1EtRFJLGDomuXRsczfzmQ56QaMo2Yx3ZNyEX+
cDRCEQr2YQvnuLLGKy2rkyad2m9b9pagmxaSIO4+Bgas1+RMr8aJY7XW9Cp4Q8Gf
aZ+pFFE3jaVn5OuxE3OQRzeJ6tm7thKNQY3IH/wpRvlOROfDA8V5K7BsVSxGPtJn
Gm+PJcBBtO7gK53YvXrOcURbI1TbDOrDSBtXCVpje5a1kYpxV932T2Kv4rjUDFYi
raXikWzpcG6eX8Br8dJ5txERrEOvXVWEdP5DfRjXmt0psH82qvKVDzCjGb2gfkr7
Fr4RCs3VDXxF8CbZeXmllvxlk1J5BNFgfMb3GUOKEIyZuTfysqwv7i1E9lSJmvRi
soM4z69ifXE11WV5JbkjnKId+2DwVzix2W8XeYm0BDuvYLBROcJ+YyVONL3V5Rif
3Bh+bryF0rLY2TiGsEoaDTaZ7/677VyxDEJS0jj1c2WBAMCWuw5HH+eLrlA+igDo
2UBTjiEeldKPEGP+dgAKnGR5ALziqntibFjz2NN/h7JyzABuZ384syBPDd6dppnp
eKJk0OPYsTEkR/ctlvo4qcDN93Mz4jpbq4lcrJmk7qLpF/BP1ZXII3qN/U/dHO8C
YwTx9HrNX7QetUIoUksm
=2/4A
-----END PGP SIGNATURE-----

--=-km/rawHupG5hejW5E2Um--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
