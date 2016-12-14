From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma UAPI: Use __kernel_sockaddr_storage
Date: Wed, 14 Dec 2016 11:43:12 -0500
Message-ID: <d5436ba7-e1e4-f288-9d21-d49e9fcfa807@redhat.com>
References: <1477587077-15410-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bqSBlUPQH5cXvi8e9V67O1E1l41Ems5Eq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477587077-15410-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bqSBlUPQH5cXvi8e9V67O1E1l41Ems5Eq
Content-Type: multipart/mixed; boundary="msRgDde04Wsd5nwQV8RANADhlE49LO1RI";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <d5436ba7-e1e4-f288-9d21-d49e9fcfa807-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma UAPI: Use __kernel_sockaddr_storage
References: <1477587077-15410-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <1477587077-15410-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--msRgDde04Wsd5nwQV8RANADhlE49LO1RI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/27/2016 12:51 PM, Jason Gunthorpe wrote:
> The kernel side is #ifdef'd to this type, and the UAPI header
> should use it directly. It has slightly different alignment
> requirments from the usual user space version.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--msRgDde04Wsd5nwQV8RANADhlE49LO1RI--

--bqSBlUPQH5cXvi8e9V67O1E1l41Ems5Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXagAAoJELgmozMOVy/dVDEP/jHI91VQBl6UHhreViKYOsZU
W/jRJKpyqNvhtBrSgCdxG1UwI5DdbZvPLrKPDYU3Gk5U40HmPObp4gSDlap0iq6R
3w35xxZ6eF3ggHslgXWK9VYfgpnaN6LvJq708+XnnzTPCoBIMb5G+iybmtcnW/Kv
Ea9vQ6CYbOLYsliYwAmGl35SfXR9cdE2SokzrhloBaix+VJVuR9rLVuwQwmwAMz/
MFUSDuq94SpmjRiFxV64+D5uTFffVYRPLrJgGaA6uAwTa+r5p92eyUpOmnxqVXxv
txQ+sPjvNEHAZLWQBd8YeZGPZavO6Uqa93VysjR5NyBvfQYejzOYzLzFlb2/mfgh
IZYQ2xq51lhHUTMynE13S8if4bXjbBXxoHHLekZFMR/r8TuZGjZuVlpiMplIpYkB
1bapMvuytoHxWYhkigy7PF4yyIGFz0QCdjtFkX0W0n6hx+YymgcSHxr2FPlKI8ie
utuCUV34NQw9qnQohizUIMBTxRc6h3KSDv2XZtEo0VAAgePbg9bHpA2U2Y0ngCR7
2rpJiNyMU/ifaL31ltd//TyPL+00Lr34ovkKKlJ7YPWB0LizKNJ7nMoDkWaiEJKm
/MiOlbCFhp+e87pbmEGC5IYZNVmElTa1cfS2WmxBXtH1bWbWMUrone3Gy/cT3IXN
3cwYp+shwYCoPnJPQbG1
=kPjE
-----END PGP SIGNATURE-----

--bqSBlUPQH5cXvi8e9V67O1E1l41Ems5Eq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
