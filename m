From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] infiniband:Fix error checking in the function
 ocrdma_dereg_mr
Date: Fri, 4 Sep 2015 12:45:38 -0400
Message-ID: <55E9CAB2.3060106@redhat.com>
References: <1441384543-32447-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IgEnhJwDaQOGDEHkJxcEcndGjLiru2F2A"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441384543-32447-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, selvin.xavier@avagotech.com
Cc: devesh.sharma@avagotech.com, mitesh.ahuja@avagotech.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IgEnhJwDaQOGDEHkJxcEcndGjLiru2F2A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/04/2015 12:35 PM, Nicholas Krause wrote:
> This fixes error checking in the function ocrdma_dereg_mr to properly
> check if the call to ocrdma_mbx_alloc fails as if so we must exit this
> function immediately and return the error code to the caller of the
> function ocrdma_dereg_mr to signal a non recoverable error has occurred=

> when calling this function that needs to be handled by the caller in it=
s
> own intended error paths.

This is probably not the right solution here.

Emulex will need to speak to this as it involves firmware interactions.
 But, in a nutshell, there are only a few very specific ways in which a
mailbox command to a device should ever be expected to fail:

1) The device firmware is hung.  In which case we have bigger problems
than the application can deal with and the driver needs to take its own
actions, not leave it up to the calling kernel code or application.

2) The mr is still in active use.  I'm not even sure that this will
cause a failure.  It depends on the firmware.  If the firmware knows it
is still in use (by a queued work request) and fails to dereg the mr,
then I could see returning that error code.  However, if the firmware
simply does the dereg whether the mr is in use or not (presumably
causing any work request still using this mr to fail once it finally
attempts to use the mr), then there wouldn't be an error to return here.

3) Unspecified PCI error resulting in an inability to communicate with
the card at all.  This falls under the same category as #1 and is beyond
the scope of a calling application.

So, depending on Emulex's answer in regards to #2 above, I doubt this
patch is the right thing to do.  For #1 and #3, the card will certainly
have to be reset before it can be used again, and will loose all of its
registrations anyway, so we would need to *not* return from an error
condition and we would need to proceed to clean up all of the dangling
resources and then return a 0 result as the application should not be
involved in the recovery that must take place.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infi=
niband/hw/ocrdma/ocrdma_verbs.c
> index bc84cd4..ea7dfc5b 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -969,8 +969,11 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
>  {
>  	struct ocrdma_mr *mr =3D get_ocrdma_mr(ib_mr);
>  	struct ocrdma_dev *dev =3D get_ocrdma_dev(ib_mr->device);
> +	int ret =3D 0;
> =20
> -	(void) ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);
> +	ret =3D  ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);=

> +	if (ret)
> +		return ret;
> =20
>  	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
> =20
>=20


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--IgEnhJwDaQOGDEHkJxcEcndGjLiru2F2A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6cqyAAoJELgmozMOVy/datYQAI0M8GhG/LnPoic0MXEryhUn
HN/GRn9idQ3g0zo67Uv64YfCU2ykd6kQqe5VRBsfPJVJCzjOIouo1BxhMlncBn3m
myGcNBBJxK+q/kZh5x1Tol0c83H/hRYtVNN1OdDLcpNzn65hS5tq8ZWVydH3pk1D
XE9X1h+YhMbgaR1PyfMTHYgVe8k6ANqT4jTwrwYdwda8MQGu+7nocU+tmFN7qFzs
7zv/T3PCvvzZh535fR/il+A15XxhJeTvX2oQafJJpMPM2DUXkr+jvHqpyrq31zPx
7MdwocStnhWsFCzu66C5TqGMxbI0GEcGCEHwrtlPDuMqu0DAAqkMD4KhUxDHzJqh
4R5O7AuIVsPozKSmShA1dPX8u4uuQNYPdNu5nK5pmI4yHA1rkfOUPS2lajn7EXk2
wQP2NLSn+AD1ACGwFNliFX4eLGuY1l7Ejke38YQ/IkpBQPUtShSDeLK+n1/xOuvA
cDYa5wNsfucf/+PT4YZHcbUEp2K+rBSVBZpkSH49C8+dYNibiNp9emfmiw+b9mYl
54PZoShzVigV9sBG66M2HGzBwa+RvrlHq92MqMWFpAnBNv0hjf/KEZXz8ST9/a2m
OLeSImr+qHvUryk6377cXhAYpulBMiUHeMZPZcTbNJMjSshQXobLNOP+XUSvZK6T
yRfzHqvNSvarI055X6LA
=46Sx
-----END PGP SIGNATURE-----

--IgEnhJwDaQOGDEHkJxcEcndGjLiru2F2A--
