From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Define platform_config_table_limits once
Date: Mon, 12 Dec 2016 15:19:57 -0500
Message-ID: <7c293f94-0b9f-847b-00a9-3d0f7ec7fe8e@redhat.com>
References: <870f083a-df8e-8a22-52c2-e4d2dde46b9d@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="47fd5KRMLH8Uwl8V7ELGjni1Hdgp032Ub"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <870f083a-df8e-8a22-52c2-e4d2dde46b9d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--47fd5KRMLH8Uwl8V7ELGjni1Hdgp032Ub
Content-Type: multipart/mixed; boundary="e1vxowfQp9cQgG0wceO8FCfodSoib3nEL";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <7c293f94-0b9f-847b-00a9-3d0f7ec7fe8e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Define platform_config_table_limits once
References: <870f083a-df8e-8a22-52c2-e4d2dde46b9d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <870f083a-df8e-8a22-52c2-e4d2dde46b9d-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--e1vxowfQp9cQgG0wceO8FCfodSoib3nEL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/5/2016 7:48 PM, Bart Van Assche wrote:
> Defining static data structures in a header file is wrong because
> this causes the data structure to be instantiated once in every .c
> file it is included in. Hence move the definition of a static
> array from a header file into the only .c file in which it is used.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--e1vxowfQp9cQgG0wceO8FCfodSoib3nEL--

--47fd5KRMLH8Uwl8V7ELGjni1Hdgp032Ub
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTwZtAAoJELgmozMOVy/dh5YP/RwWEmP+/RFLWVKCn5C0fhTm
MEejWpSZnNGRlyW/bSAfsQPuRljSIlNERf4sD5saMGUWhqyqqHUYRJAwXJp0p4V7
RFY8U0iu8FbDOI1gw5botmBPQFvzEacM85X8lmb09JujL3NcSMfycvf7mLMjCCQQ
NzZ1pBLSdNZ2RaA1HQ+FLFAHJp5RDYSy9enUsDluqHWK9rTQV//o/xLr64xiK7Xe
FTqWMOMKLY9uxtojl0tPZXOu7CG0sYl/+qm5oSRipSggnQKxkyB3Wejnz+Vg+QTB
xMdhnz+T8ZDhTjKGQMRogUYhSUEoLxSoGvZxmN/enbhG2AnAy2UCKnzLwXp7T+a2
5YDUyMtY9hpRh/AcUndd/ftd3oli5Fdc8d2xm39MqMAK+A4H2hitF1QyqsXhtst0
J/Vxh0Va90Ba0tw+GYGVO7cpaLhmgzBppxJfR0PLxKxn9isaqCrT9OWeUSJfUFk1
uDtM92ROupNCmwEfGaE805rsMLvBkqrSAh3fS1AolwTPEf+rBkAQyCzzgpbvd3TD
lq3DiZQGCi0A9dEb1fHxf2SrQe7v+yPJqbGbaCWpxJrQMNbPq3lHtZS314KRoBZ9
fs//xPQio44qeyLywOaFdUYkcPa+4ZutduAS6Wrwroqym8xFLlNHkAbQcl7N+OnF
bkq4Z0bwM94lNVGEQ9im
=L6Hf
-----END PGP SIGNATURE-----

--47fd5KRMLH8Uwl8V7ELGjni1Hdgp032Ub--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
