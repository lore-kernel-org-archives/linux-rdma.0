From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core packaging and multilib
Date: Wed, 15 Mar 2017 12:34:37 -0400
Message-ID: <79c87a2b-6b8e-d2f3-0246-bb549c52f8f3@redhat.com>
References: <bb6b2274-a120-6a16-0025-4c0b1b090029@redhat.com>
 <20170314181708.GA25495@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2g79jPo7HlufKxonPoBT4VSfrPEOCPLi3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314181708.GA25495-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2g79jPo7HlufKxonPoBT4VSfrPEOCPLi3
Content-Type: multipart/mixed; boundary="m3cBARMkaGrxCHKtQPDOIecgsBOfS5ST8";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <79c87a2b-6b8e-d2f3-0246-bb549c52f8f3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core packaging and multilib
References: <bb6b2274-a120-6a16-0025-4c0b1b090029-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170314181708.GA25495-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20170314181708.GA25495-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--m3cBARMkaGrxCHKtQPDOIecgsBOfS5ST8
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 3/14/2017 2:17 PM, Jason Gunthorpe wrote:
> On Tue, Mar 14, 2017 at 02:02:15PM -0400, Jarod Wilson wrote:
>=20
>> Report from TEST_MULTILIB:
>> [BAD] [ibacm] Subpackage ibacm is not multilib-clean for x86_64 vs i68=
6: 2
>> files have non-equal 32/64bit content:
>>   /usr/share/man/man7/ibacm_prov.7.gz
>>   /etc/rdma/ibacm_opts.cfg
>=20
> Yep
>=20
>> ibacm_prov.7.gz on x86_64 vs i686:
>> ...
>> -2. be installed under a configured directory, eg., /usr/lib64/ibacm;
>> +2. be installed under a configured directory, eg., /usr/lib/ibacm;
>> ...
>>
>> Similar for ibacm_opts.cfg:
>>
>> -# provider_lib_path /usr/lib64/ibacm
>> +# provider_lib_path /usr/lib/ibacm
>>
>> Not sure what the ideal resolution is for this. I'd rather not put in =
the
>> wrong path for one arch or the other, and I think lib64 isn't used
>> universally by all 64-bit distros.
>=20
> cmake substitutes in the correct path string at build time.
>=20
> If you want these files to be identical then we cannot include the
> path names at all

That's not entirely true.  The man page specifically says the path in
the man page is an example, so it need not match the arch in use, it can
simply be one or the other with no substitution.  For the provider lib
path, it's in a comment, so again it would be possible to use proper
verbage to express that it is a sample and not use substitution.  We
might even be able to do something like:

# Modern distros commonly use either /usr/lib or /usr/lib64 for the
# default _libpath.  Substitute the correct value below before
# uncommenting
# provider_lib_path _libpath/ibacm

> , just put place holders and say to run 'ib_acme -D
> . -O' to learn the configured value.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--m3cBARMkaGrxCHKtQPDOIecgsBOfS5ST8--

--2g79jPo7HlufKxonPoBT4VSfrPEOCPLi3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYyW0dAAoJELgmozMOVy/dsicP/ieBn8GfuNuajgxJutSrMLqs
xAHvgx4FhlomkpZWZYcpGEcyQQaNBxxQZLkJ6McxuuLS4quuaE5U96rAHjhXbJyI
/GsCALOy2ksvGEQ+PBpHue3oLWZHmLwseTARFJVsrntMj6VITDfr8JR0qorQYQEN
8HaE1ULyRuwIrZA0CJEg1lLnFTl+m4gnigKxD8SiLASn3E7yKECHnIDS0/FvLpl9
Igg2cRJkaT33K+b45geWaYLgZSDVsrrgT/pZV3Md0G4cG7xlcuQ/fpjEy1KnSfpw
WErrLzin/OsfLqDyPdjWQ81cFjN7GtSs1e5Zidvr+LmnShdDEU69Zvkw6lmgz0I5
FepYC+W5LxpN8+9hdmJkt4gDdAzg6+0zs5/ijG97eQC/tjvQWlNe3wJtdq6I3RJy
9ypS3evdDUWKfEJJz/lu6k3CEV+2nZVzgmQWOVUtZ4aEiGn6nZgCG+bJG13Wcsg/
5Wibe/RNpZ0Jts1wd25rP0b0HVO+5RnAvMGfEGH3eyRO2BSxXCSTFf7+S5y4lN1M
Sy6yffn4VEfAYhq/Ll0miHuSNUFDjUm6Lv9Al2i6004hDlPPiOeW2ZIDHL1eCEV1
NNMLMecP6eh5OfUwEIV73Uf8HO+drAoWCm2i8Ons9yW2NzpRFceAnhECePSQOaLl
wGDcvSvflGsIckDr6ffw
=p0NT
-----END PGP SIGNATURE-----

--2g79jPo7HlufKxonPoBT4VSfrPEOCPLi3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
