From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Validate header in set_armed_active
Date: Mon, 22 Aug 2016 14:22:47 -0400
Message-ID: <6690fc03-ff08-a204-f6e6-8703de6a9df7@redhat.com>
References: <1470755996-14187-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7meaKVlxeTtEQrPdBc0PB4OlT14FxusdT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470755996-14187-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7meaKVlxeTtEQrPdBc0PB4OlT14FxusdT
Content-Type: multipart/mixed; boundary="Mc36tu2QUpfWIJhAKe2Ae1hjrAdf4NSpV"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <6690fc03-ff08-a204-f6e6-8703de6a9df7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Validate header in set_armed_active
References: <1470755996-14187-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1470755996-14187-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--Mc36tu2QUpfWIJhAKe2Ae1hjrAdf4NSpV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/9/2016 11:19 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> These are 2 simple fixes but there is a dependency here so I'm sending =
them
> together.
>=20
> Mike Marciniszyn (2):
>   IB/hfi1: Pass packet ptr to set_armed_active
>   IB/hfi1: Validate header in set_armed_active
>=20
>  drivers/infiniband/hw/hfi1/driver.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20

Series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Mc36tu2QUpfWIJhAKe2Ae1hjrAdf4NSpV--

--7meaKVlxeTtEQrPdBc0PB4OlT14FxusdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0L3AAoJELgmozMOVy/dgiYQAKPRxad91MBR9yAmvN9t7heQ
SCllwqGxbYVrums6LlFZdNP6KAOjPqVAqULx3ESw1iaNLpYssvHNxTUxSeiTIcLJ
/Xc3HagOcZQyO4XMsJhHvTF0Hnr+pTZqO/04jAVWWlXH3DEH096JiHQC9sytGiLi
MR9LKDlFMcvRvxVoyq+ZAEjbR/fphiprSrmWoIp29iW6SgwKcQtNTCGDSWkxndpJ
yUf/QlAy1d+/KY6i7qt1tik2fC6mp61s3zHR26yFYnvK7YKBjTFCQf34QTsbtiWn
bABp1E2GZ83/anM8KtGQWjjs5Ukap3AnhzCCZWSE9Cbxc0MCPXp4rsx+AtxjFqmE
ZKmhi8mklKq8HEwMNAzZ/es47Z6sbIDFFRXsBhYGfTCRKY27OVV8gjyBJNq8kFPX
SQFFjapL/obeRLdNghc4F9D8EgikCilXHQdr+TOThSDjVzcOs6W+NNJBYPK1TGYK
ulvL9rFSQe4GqHo00stkSVRngk05TOEhOe+PArJDRs0q3bFLpfxGbQf+1KQ7lEcK
qxCmFA7klfvS62R9M1mMm9o1Rde7WIEoHyrkm8p6+D7QEp0e0Lk/W0iDs82AOySf
7AcGxbIHHECR74y4iHfRf5UbIJo4exZLn61LXpaQxnza08PMXR9cul3h8WVVzj75
NwcL5wJ/tFtt4JOUHz44
=YecB
-----END PGP SIGNATURE-----

--7meaKVlxeTtEQrPdBc0PB4OlT14FxusdT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
