From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/security: Restrict use of the write() interface
Date: Wed, 18 May 2016 15:05:05 -0400
Message-ID: <53639dec-5d1d-58af-3022-963368c144db@redhat.com>
References: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford@redhat.com>
 <20160518172012.GA6879@kroah.com>
 <c6c952ea-3562-48e1-cf56-5b8c810654f1@redhat.com>
 <CAJ3xEMi0Rg7nc7TN9Hn7=nuWmBZH1qoncKr+HuzjUP=8yMRrDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NFdO6PPRCqEj0fLLtrWF2NuJd3qTOsLdG"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMi0Rg7nc7TN9Hn7=nuWmBZH1qoncKr+HuzjUP=8yMRrDA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Greg KH <greg@kroah.com>, stable@vger.kernel.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NFdO6PPRCqEj0fLLtrWF2NuJd3qTOsLdG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 02:59 PM, Or Gerlitz wrote:
> On Wed, May 18, 2016 at 8:57 PM, Doug Ledford <dledford@redhat.com> wro=
te:
>> On 05/18/2016 01:20 PM, Greg KH wrote:
>=20
>>> I don't understand, is this only for 3.14.x?
>=20
>> Yes.
>=20
> Wait, any reason not to apply it on all stable kernels?

It already is.  The only kernel that Greg takes care of that it failed
to apply to was this one, and so nothing was applied.  For the two
kernels that Kamal manages, he munged the upstream patch to apply by
dropping the hfi1 hunks, but that didn't add in the missing ipath hunks,
so that's the reason for the two other patches I sent, they were for him
so that he could apply those to his two trees to update his patch to
cover everything.

> Or.
>=20
>> You already applied the same patch against 4.5.x, but without the
>> update to include the ipath driver and with the hfi1 driver still in t=
he patch.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--NFdO6PPRCqEj0fLLtrWF2NuJd3qTOsLdG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPLzhAAoJELgmozMOVy/dbc4P+wcPeShlZs2qLrCoBGh2qGBm
gDtQfjR7LZF4EIADG5XcYqFeyCVmSXbM3gf3jQSBzoIptW6OhVFZzN/f5chvdql0
9Y6ZSG4QLuYhmHp9ffIpCbd5ldyNH/SZ4yjx0USZGlyOa//S9hPVa9NrrW1H00hB
wDk2u+Foiem3zKd4uJ5db0wsRxE4FioyKGITktjKgAJnwnimqEDn8tmXggXfedBo
qfAAWrTO5sr++DwMm8vm8tEamAxmhWLBfMsJ1G8DSKv8nx3BlUk2ZYUk87aHXy5d
n8s4khBfZBen1uDbjaBLD3CiZ0I+KdK7MbJqHMUEAd0m64dB4JLOYtzu9Cj0oooO
6OH35qdJScIDVmzOxh2ESfXVv3vXRvUihmWGEy2qvHlmP0DUK7uq6tsGttFT7JTp
RPxG6THcjvpXzmHdlLPc9/hr4KraDs1kOLMTtgTNysPToYCODi2wntyhvMJSWvMu
Vddc2nZ+7ThM/02NWuzxBiPK6rk5PR/TYKgB4VXWHtA3ZLRJpQXmI1qUTx02zhKl
2oeiKH1045OwOa2CsxYYucUNRn1JSr0BDMWBM99o5XDqeTop23IfqO02RS5t3CnU
sYL5XRQShFZzNWQFha6HXqmNVzx8DdnsknHFJ57h2+4Q4GOmsgiDIoBeAb3har4v
0dBIpYOz5mITshOol/mn
=5Y3i
-----END PGP SIGNATURE-----

--NFdO6PPRCqEj0fLLtrWF2NuJd3qTOsLdG--
