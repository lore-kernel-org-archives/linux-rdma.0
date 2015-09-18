From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/hfi1: fix copy_to/from_user() error handling
Date: Fri, 18 Sep 2015 11:50:10 -0400
Message-ID: <55FC32B2.1060004@redhat.com>
References: <20150915103525.GA20813@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GUlBNGq1ArU0AWxO1xGaABlDpkL5XDXDm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150915103525.GA20813@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GUlBNGq1ArU0AWxO1xGaABlDpkL5XDXDm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/15/2015 06:35 AM, Dan Carpenter wrote:
> copy_to/from_user() returns the number of bytes which we were not able
> to copy.  It doesn't return an error code.
>=20
> Also a couple places had a printk() on error and I removed that because=

> people can take advantage of it to fill /var/log/messages with spam.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GUlBNGq1ArU0AWxO1xGaABlDpkL5XDXDm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV/DKyAAoJELgmozMOVy/dZi0QAIhVCPM1Ky528IpGjGN2ppZ9
ZawlwoRaaPxpG0eJ1sfyMU3pEV6UtLRkGQjzHL4pDxb4U4NyVyBwLJVvNxeD0Exw
qY8sV0wjYpwAVUD7j7T0U3o8eiEk15gknv/vaNTDt7Uv8kp+RDTsFJw30t/GoJPh
2SwGpFX2CgkcYAmvVpr07fC1qL+PxJr+Q0VyJyomANt0vtv1GAt+FevOtofH6hNT
5+9vo0y0ZLmoJ3UC11SF/v2FvAelpU/TEcfA4bfukM2Gq1TpTKEALMtasBZuJswi
SwZpumdewVsdf2lE6rZxLUbG90AsmsgX7z3woHLwZu7YtG5vhI0NMSUiKDJhNq0p
tUrT5IJhmcCQ8zoK8hUsc+eoTto8fWdlj+/UFq5RtIG4UQ1S/84n49dbBi6PZMLb
ZxPvLYo6tcXLS5wXCLtxn24nk28KGhoJoccowu1baC9UwRbGZPUgHlp4lxAf98qR
7apmpfjKRR8fR70KNzVuvO4MxGxyur0IwjGYqqU6/s9ThEYwtPc+C90y2nywbdp/
D1bcw2nYWPKReHMmNgOl7TmNZHrI2Yn9tRyQwIFV5sHu/3tdLv24yibSti2L+vcD
/4JHhI03hT0XKrwOf5SFyE95i3BBbtnev8FernTuA6nPm5cO9wa/P/OYHIfbmQt+
rCa+sv3pfkhHKhNdiCZ+
=njLT
-----END PGP SIGNATURE-----

--GUlBNGq1ArU0AWxO1xGaABlDpkL5XDXDm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
