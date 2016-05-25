From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Wed, 25 May 2016 13:56:18 -0400
Message-ID: <d4913637-7167-8491-88ea-fa65d1e0c22d@redhat.com>
References: <20160522140351.GA10696@phlsvsds.ph.intel.com>
 <20160522175715.GD25500@leon.nu>
 <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
 <b9dc4ac8-cfa2-d66e-7e36-f28116f23e59@redhat.com>
 <20160524175409.GI25500@leon.nu>
 <a4477030-c966-636e-e395-96857454c7de@redhat.com>
 <20160524201317.GK25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB050188@ORSMSX109.amr.corp.intel.com>
 <20160524205425.GA7950@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kq4IlDLNriDT99i477CE1kVvAAjhERwbR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524205425.GA7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dalessandro Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haralanov Mitko <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Weiny Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Marciniszyn Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kq4IlDLNriDT99i477CE1kVvAAjhERwbR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/24/2016 04:54 PM, Jason Gunthorpe wrote:
> On Tue, May 24, 2016 at 08:29:41PM +0000, Hefty, Sean wrote:
>>> Let's assume that you are planning to provide block of 20 ioctls per
>>> device. Right now, there are 10 (or 8 if we count driver families) dr=
ivers in
>>> drivers/infiniband/hw/ + 1 is coming (HSI) + uverbs (approximately 40=
)
>>> =3D> 8 * 20 + 20 + 40 =3D 220 ioctls =3D> we already in shortage with=
out room
>>> to expansion.
>>
>> Ioctl commands are naturally scoped per open file.  Unless the
>> opened file supports ioctls directed to every piece of hardware, I
>> don't see why there's an obsession with command space.
>=20
> The kernel standard is to have ioctl numbers be globally unique, even
> though technically you are right and they are scoped to a file.

A not very well followed standard...


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--kq4IlDLNriDT99i477CE1kVvAAjhERwbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRedCAAoJELgmozMOVy/dyEAQAJ0XQ11TzTMuzCn3yu6X2Dz1
0nnkBxnsCtUqcp5hhRNzLQZu2fj72ApcMBR7a95A5pU20BpTOJyrGPOCEkqVXwpA
oN/JoZfaxcnQmB0Ypf+Ih/gUlZPtPKtL/8F2hFIlKfbLJ+HkCfs67NB9a4vjuJsT
KVxzUCFkmrRvZimno0Vm+n3g01ItPI705kysMqQQ3zyWB+SCcHX6aQ3zKxnRn0gN
jr833uZ4UPTNfj5UY+YdAdo2UknS+MHLdmDF24zumxMFiRw+hsCU7KshGXBGoUq4
ZznwfrVfbHIxfeQk5dr5xmAxrs+jLfORza+gmBxpRyOIXH7lFtE3any/T0VNI53B
BUS8D33yjK7SLylxD1Z5oRWBAZUXYp9TO+d/pAN2dxHR06AcQJKHIZMmYEL6IJf/
z1MXtFP+HlLM9ZtEpJ56PQUGl/+8YC2BtEvyvPzH4H25RDZUMmDVsy0sWJBaLXks
wiOm1tsnqLc9dPM4ZE/mAVywdbZ4FokXbVvunG92DqpzI5IPXKAUDRYfY9ItiTo8
KKnv1U8H5/riggkFFCAsC2mPHPG4z1Hzk3Vj2q7/Ew7OzQR/ycgVJ5XXAZtA7cHo
h1Gt/7BMobM2bUy7llrJdHWEWOAjTDPPYyGlHz0lsb9c9USN8fhEwRsNPh+dvlCX
l1c81z8PtkIcPuWQ+9sE
=OudE
-----END PGP SIGNATURE-----

--kq4IlDLNriDT99i477CE1kVvAAjhERwbR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
