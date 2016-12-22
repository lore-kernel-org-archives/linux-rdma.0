From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
Date: Thu, 22 Dec 2016 13:28:52 -0500
Message-ID: <521e87db-24b1-1df9-0d5b-af74c0b46304@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221220840.36268-6-jarod@redhat.com>
 <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3@redhat.com>
 <20161222173302.GA29518@obsidianresearch.com>
 <74c5651b-4125-0a7a-3184-d510814cdc0d@redhat.com>
 <5f0f6060-deb4-da27-c6a0-12d1ede4ca2b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BVim6Ta7Brh9Ri7IwL90T2AdBOBkvtFKS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5f0f6060-deb4-da27-c6a0-12d1ede4ca2b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BVim6Ta7Brh9Ri7IwL90T2AdBOBkvtFKS
Content-Type: multipart/mixed; boundary="30jHEl1sxKVmjj8f4BjPVWA7GUsg2vRmi";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <521e87db-24b1-1df9-0d5b-af74c0b46304-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
References: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161221220840.36268-6-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222173302.GA29518-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <74c5651b-4125-0a7a-3184-d510814cdc0d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <5f0f6060-deb4-da27-c6a0-12d1ede4ca2b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <5f0f6060-deb4-da27-c6a0-12d1ede4ca2b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--30jHEl1sxKVmjj8f4BjPVWA7GUsg2vRmi
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 1:23 PM, Jarod Wilson wrote:
> On 2016-12-22 1:15 PM, Doug Ledford wrote:
>> On 12/22/2016 12:33 PM, Jason Gunthorpe wrote:
>>> On Thu, Dec 22, 2016 at 02:17:52AM -0500, Jarod Wilson wrote:
>>>>> %files -n librdmacm
>>>>> %{_libdir}/librdmacm*.so.*
>>>>> -%{_libdir}/rsocket/*.so.*
>>>>> +%dir %{_libdir}/rsocket
>>>>> +%{_libdir}/rsocket/*.so
>>>>
>>>> Minor error here, should be rsocket/*.so* to pick up the symlinks
>>>> too, at
>>>> least until they get neutered.
>>
>> I hand fixed this when taking the original series BTW...
>=20
> Okay, this fixup was in my follow-up patch as well. Guessing what to
> patch against a little, since it's not pushed yet. ;)

So, that was my mistake.  I pushed using --tags and that sent the tag,
but not the master ref update.  I just pushed out my current master.  I
thought adding --tags to the push command would add tags to the push,
not replace the normal push with only a tag push.  My mistake.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--30jHEl1sxKVmjj8f4BjPVWA7GUsg2vRmi--

--BVim6Ta7Brh9Ri7IwL90T2AdBOBkvtFKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXBtkAAoJELgmozMOVy/dNUIQALfCDsPpFn3KInZGOQ/wCbWK
KKknV3KbO6g4wTFzU1R/KD/izRvjhohODaDX8CDKI3iRu6TBqNKIf64iMCJIkUsJ
YONFUqWpaQZSNABe5MRmlI5ZX9AYk+uctvlKP8oMBlXBTvPNMQWECzaIoGWSQbE3
2cMe2c5DmuUS+p01pjPg/EcwasBo+Lm1Tl++LM/gHKaOKa8JEfO/eq3+yxMyZ9ES
TUclt3GFlJw2DxftfYDcZTiBysovffjjW1IhICwvX+yg2dmYCj3W7l9SEbLFHD30
XGQtk8a4wMnOM2amXkmSxeTTMj8mb/RcEQSCGpSKTXZIFT/zgdYWxj0mWCz1/GiN
tdmdtySzP8kKmRcr/YaiqnhDhapj0VTdXDCBITAFMfFuwd/T19sbeZjdKPwS0FBN
wg0J6vhSCuP9iEJDpFg0jCs8dDQugYVlmMZztccqrz+c0NCdpslCFzkLZYWFQXeY
1OGQfjwCjdeCqfEPI6ZVDJ+ZPKRiHaXawZfBmofA4PdQtBtJuRexiVQy3wfTzSNr
8kJ8hyOZO+7GMR4BZ3V5aKSmT2putAhl8esU3hKT+SADNGhcVaM5RoqipOCCuh9c
1Lttfl2DOU0gLto0xl0u2iFPM4RC54sCOwLpTXMXyQE6JCFRSW0L0qjYkFo+cOxC
mOqv6FyZ0WFt4BDTEoiw
=zU6M
-----END PGP SIGNATURE-----

--BVim6Ta7Brh9Ri7IwL90T2AdBOBkvtFKS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
