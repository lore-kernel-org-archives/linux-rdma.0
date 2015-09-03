From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Thu, 3 Sep 2015 13:41:31 -0400
Message-ID: <55E8864B.3080004@redhat.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P1vCvSUVMVxvJ94F9t6PAbi8pdXI2MVPD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818141542.4127.90517.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P1vCvSUVMVxvJ94F9t6PAbi8pdXI2MVPD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/18/2015 10:15 AM, Mike Marciniszyn wrote:
> The move from infiniband to staging requires a temporary
> PCI dependency to fix 0-day build issues.  The
> drivers/infiniband/hw/Kconfig gratuitously added it for all drivers.

This was no longer needed after I created drivers/staging/rdma and moved
all the drivers into subdirectories of that directory.

> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/hfi1/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/hfi1/Kconfig b/drivers/staging/hfi1/Kconfi=
g
> index 78bc89e..8a079ba 100644
> --- a/drivers/staging/hfi1/Kconfig
> +++ b/drivers/staging/hfi1/Kconfig
> @@ -1,6 +1,6 @@
>  config INFINIBAND_HFI1
>  	tristate "Intel OPA Gen1 support"
> -	depends on X86_64 && INFINIBAND
> +	depends on X86_64 && INFINIBAND && PCI
>  	default m
>  	---help---
>  	This is a low-level driver for Intel OPA Gen1 adapter.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--P1vCvSUVMVxvJ94F9t6PAbi8pdXI2MVPD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6IZLAAoJELgmozMOVy/d3UUQAK01OY6WCaeQIR0xiFVIgQTg
K+J+d80DfmEG7jBA2CU+FmTt6mMlE2BGdH/bcx0hhEvAxGU77jdQiXkjLGxNKPd8
lU8zLM/h+3KLqcvag0sNeTq7KcKERLQqe21teKPbS0x99ERJ1Fak8zLpo+m5MCid
l2B527ylykmJSNeBoKGQzbOIv53UEfYfcbvgbPFfsVNG/aBbJIO/tOvXnARnOtnS
QKbjNuPCoxxa/MfirhMPcb7nwfE3LwdhjdYxkccBlmlSGrTwXkMMwckWl2ms9Uwm
sW0A2Kyo4yxNauhT84vSjkEg6qdJiiSWV8l7HpFfKb2V9zSy8cxDQ1CQWLAVSNp+
NTUkY3Y45kJvkvyJFK4VyihdrN4YALsm0oAvZx2CL3TN4FtJ8Ga3+nNBKmB3Wh5n
/osZsX8aRPE7fmlJ/vfGVtYTx2M5SHi+lTHiKfdVhCuYQhfsLtxHRrRRym3BJ29R
HwsDUnGN/3T/D6U73eHXty2cMs8xi2SSiNxs1i9olJ9FPMESr6TQ+trCRZNfVWne
wp8Pp8YxrXEaXXPnMroWx8c/+Wo66shZI3AJJckAlbaVy8UWH708cW4cP7/X+C0x
rgpDYWNmNuqp7lueOCoBv40lSOsta9Nc4b/Pt6kLF+uRhWfzlIp30YUi07wiyBDn
c3rsgv9VkHrkkS605bNE
=vkpR
-----END PGP SIGNATURE-----

--P1vCvSUVMVxvJ94F9t6PAbi8pdXI2MVPD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
