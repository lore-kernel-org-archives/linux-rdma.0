From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Potential NULL dereference in cma_id_from_event
Date: Tue, 20 Oct 2015 13:22:36 -0400
Message-ID: <5626785C.5040606@redhat.com>
References: <1442840522-12691-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0iEt8LdRKuLnmWju4MsMu4sg7qfIsmDMb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442840522-12691-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0iEt8LdRKuLnmWju4MsMu4sg7qfIsmDMb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/21/2015 09:02 AM, Haggai Eran wrote:
> If the lookup of a listening ID failed for an AF_IB request, the code
> would try to call dev_put() on a NULL net_dev.
>=20
> Fixes: be688195bd08 ("IB/cma: Fix net_dev reference leak with failed
> requests")
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
> index b1ab13f3e182..b92a3c2c060b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1302,7 +1302,7 @@ static struct rdma_id_private *cma_id_from_event(=
struct ib_cm_id *cm_id,
>  	bind_list =3D cma_ps_find(rdma_ps_from_service_id(req.service_id),
>  				cma_port_from_service_id(req.service_id));
>  	id_priv =3D cma_find_listener(bind_list, cm_id, ib_event, &req, *net_=
dev);
> -	if (IS_ERR(id_priv)) {
> +	if (IS_ERR(id_priv) && *net_dev) {
>  		dev_put(*net_dev);
>  		*net_dev =3D NULL;
>  	}
>=20

This one got lost back in the noise of all the for-next patches.  Sorry
to have missed it.  I've picked it up now for -rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--0iEt8LdRKuLnmWju4MsMu4sg7qfIsmDMb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJnhcAAoJELgmozMOVy/dUXcP/RA6G6SC0f8nlkhjwGToN9eq
QImxSqDILLRByFSuvhemhJzwLYUGP1X6kDCsGWqzMHmKlHI9F4mJ5/CN86SmGSI5
SEMYZ4CzbBTpSGNRkwUnX6aIcTlmGGdT74c78EzZp1DFAmybQyh40fz3fmw/ndB0
5OuMpV7WFuOFxgOks//PCaMkMi+3CcknRWUfcob/4f9oIopm96JpRoFHQ5oTNQCa
x6ceaDFKj6hQKelBPA/nl6QdnS3X7Gv/DDQaV+RC082fdtsRIXn3DZbeRGSGM1Uk
37keXHR+4rqESqz72qxis0DcqxFKRByXxUTEmYdjfCjN02QpO7sn1gmJg62ASxd6
SHkrymADZMQXTpWujY0+oLmc/vHIDvSNt8oU4huftS6HztbxcWXTofHRdJBygU9Z
aYh/CzGB6Jhenme29UNHatvCjOEPKWC6/Mwn16D/tBGgzEME6i28/KgRIW1wtINI
2flD4sRyuFNTZwgv1fyNIsr58FQNXo6Fp6fdfcyw3KPb+dt4C2DCVvqex50MZ5EY
NJqgblUYKmYIWg75BEvxNpIHYMJbTYVmc57ljx6CSfZ/GsMwMpzcCzyKKxdulOTe
bxD0KBcIvq88SNZW5SCP31+AzjyjbzdKDySvRjTJaV8PJu2Upkxjr4Wc4tf6X0Sd
xslTZOpyk0/jGPA/dMAa
=XIGQ
-----END PGP SIGNATURE-----

--0iEt8LdRKuLnmWju4MsMu4sg7qfIsmDMb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
