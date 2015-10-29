From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 28/26] IB/ipath: Remove fast registration from the code
Date: Thu, 29 Oct 2015 11:49:50 -0400
Message-ID: <5632401E.1090006@redhat.com>
References: <1446132812-20170-1-git-send-email-sagig@mellanox.com>
 <1446132812-20170-2-git-send-email-sagig@mellanox.com>
 <56323F02.8040803@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nSE8Fj70eKIVE59PEahhRbKE3cOG64CXx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56323F02.8040803-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nSE8Fj70eKIVE59PEahhRbKE3cOG64CXx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 11:45 AM, Doug Ledford wrote:
> On 10/29/2015 11:33 AM, Sagi Grimberg wrote:
>> The driver does not support it anyway, and the support
>> should be added to a generic layer shared by both hfi1,
>> qib and softroce drivers.
>=20
> Thanks, applied.

Thanks for the quick turnaround Sagi, this has my compiles working again
with the final 26/26 patch back in place and lets me move on to other
patchsets.

I've pushed everything up to this point to k.o and github.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nSE8Fj70eKIVE59PEahhRbKE3cOG64CXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMkAeAAoJELgmozMOVy/dT2kQAJO2JzJT7aRPVfEk1Xg7E3zD
RJWu43deEl5ECDeVQ1hRM7RddNzv4qBzlnRcq2G/JPuWSQN3s7OeLaBmUQaRcxV5
sSvTeNs34zF+SBeZfxhtOUcBU05DVoYULHq9Yj0M5fvlkyHZu5AzOAUnHkTJ2/Vu
xF0OKFpuRUA2SwH2RS01g69ivkgg73igc3A8Y8bwT1/ty+CNShyEOV+T2dKmMuIV
f7G6wH6OkIkTem2KXQqFNUKHkiajb/77bTtKnQWD3W6s/gkKCA14AWNUvWH4zBnN
ZsaWyzjNnFzA1Ms5OwJLlZRCKN/KgDj2W9B+YA6iQlLr56Er//gT6cmDNAa+F1GR
Hgy0Ul61XKBl+6LcmzLZge4fr5rFJEXeAa6zfq/69RnrC8invoNwAbvNg2j6WWuR
DnpkJLxfilzfrYM5MO/t0yr8DuyTeJ7t80EZBOa2kGqAeeG7S/PGadq+w+nrjrtq
/oNf0TGMkxRN20PPtkm9DlyyjxjbezP0asIBWT4mh1U7n3Bnnj6dc77rqAAse6jN
NNIyS15bO7+3aca6Ypg4nfcBXtdnCLFhXqNn+lnGfQuGaqYANl9t8uaKaYrx6dog
uWVvJkAuRzXWfH3Vgn6LIEmhoFB6ghyto/LR6ZvpEjAZJ9d4v17hBpCgTPYa3TH5
M23dK/HEGNdRe/lWrV9Q
=YTR0
-----END PGP SIGNATURE-----

--nSE8Fj70eKIVE59PEahhRbKE3cOG64CXx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
