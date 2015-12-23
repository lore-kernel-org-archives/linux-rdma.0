From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] IB multicast cleanup patches V2
Date: Wed, 23 Dec 2015 13:11:11 -0500
Message-ID: <567AE3BF.6020407@redhat.com>
References: <20151221144252.575119561@linux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TUGs7HL7SFHoPBMa6x4Pa7QLiDObq3Ffi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221144252.575119561-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TUGs7HL7SFHoPBMa6x4Pa7QLiDObq3Ffi
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/21/2015 09:42 AM, Christoph Lameter wrote:
> V1->V2
>  - Add Reviewed by's for first patch from Ira Weiny
>  - Change name of ipoib_check_mcast_sendonly() to
> 	ipoib_check_and_add_mcast_sendonly() as requested by Ira
>=20
> This patchset cleans up the code a bit after the last round of multicas=
t
> patches related to the sendonly join logic. Some of the bits of code
> landed in ipoib_main.c instead of ipoib_multicast.c.
>=20
> - Move the multicastbits into that file so that everything is neatly to=
gether
> - Reduce the number of functions exported from ipoib_multicast.c
>=20
> This patchset can be retrieved from a git repo on kernel.org via
>=20
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/rdma.g=
it cleanup
>=20

Thanks, applied (with Ira's name fixed).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TUGs7HL7SFHoPBMa6x4Pa7QLiDObq3Ffi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeuO/AAoJELgmozMOVy/dk+AP/i5LxfplzhCrzgOvqIrS4Ffg
TivoGtB6Ml+WBKOu1WJe/a05SSiwwXH3UWaLM6wJn/fTUn9KZhU6R4L2llmUqDsV
cOjsHXhGyoc/i2q506LjucTs4AJ7yWZMSYspl/PNW8kPQvFBhrlR8uwHRSRuxqsy
fQZokSfJ23gGsiI/OvK3dcCGTgGrceTsFpLH9Rbzg2ejNICgfjKiIo1FDfIrbs1p
10NfI7Rn5lpyGw0jRrBY4sE79zKXFqLCL6XWN8+qq92kXW6oj4bozE4lPtXJuvZA
mfZEyM9EG0+kUbfdemjGnKp1cAv+BoAjv4GbI7IYgCZhgoHtlHrkoYgkTY361zcy
2wlsCIRJmjnAQqeTgx+EPf6xPfyNNNO2ALqLxAPw89Fo36w1sl6cXJp6SSTw2z4t
9EFneUv8btiwr8VSHW6B90xbrBWx7EMk8Q4C1P7NbUadS0mAno5o417TitKRC0Jw
BeRcjbl+oYFiRAkxe/hhUh8XOpxMTU/HB5d+KDWCWJbakC0O7FFBeW9OGPe+pPUK
CxH2yX9PvKz94J1WMME6CwRQUHdpLGrPGZO2OU8DX/atPbhyGUIY8UlhplIeRwOo
j+KICS9Qm5N8LVbOdnVMRCYV53UFs5iuvpkeiWXbmPfWISPHQbUZ3L87d/WLwACH
3nmUMATE1CSA3uFssLGZ
=pxvK
-----END PGP SIGNATURE-----

--TUGs7HL7SFHoPBMa6x4Pa7QLiDObq3Ffi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
