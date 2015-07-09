From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.2] IB/mlx4: Fix and optimize SRIOV slave init
Date: Thu, 09 Jul 2015 08:31:41 -0400
Message-ID: <559E69AD.9050406@redhat.com>
References: <23f3dca9ff4b71155bd898be1f3cbd8eeb9df27f.1436394658.git.dledford@redhat.com> <559E30C3.5050702@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sxcKqVIrQG6u5WhMoLONmI5ElNCFKQ9j6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559E30C3.5050702-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sxcKqVIrQG6u5WhMoLONmI5ElNCFKQ9j6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/09/2015 04:28 AM, Or Gerlitz wrote:
> On 7/9/2015 1:30 AM, Doug Ledford wrote:
>> In mlx4_main.c:do_slave_init(), the function is supposed to queue up
>> each work struct.  However, it checks to make sure the sriov support
>> isn't going down first.  When it is going down, it doesn't queue up th=
e
>> work struct, which results in us leaking the work struct at the end of=

>> the function.  As a fix, make sure that if we don't queue up the work
>> struct, then we kfree it instead.
>>
>> The routine was also sub-optimal in its loop operations.  Instead of
>> taking and releasing a spin lock over and over again, let's just take =
it
>> once, and quickly loop through what needs to be done under the spin lo=
ck
>> and then release it.
>>
>=20
> Hi Doug,
>=20
> I'd like Jack to review this before we ack, not sure if he's in today,
> so he might get to look on that only on Sunday.

Try to get it reviewed before then please.  If it passes my
build/functional tests (which I want to get to today), it will go in a
pull request tomorrow.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--sxcKqVIrQG6u5WhMoLONmI5ElNCFKQ9j6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnmmtAAoJELgmozMOVy/dB3UQAKTFTMQZeuQTzpIx2c1Vf6CG
PZhh2clCYSrVIToDcuTNcIb0MhIAsBj95bhAPTeXKvz0HEXCN4Oed5s/wL2A92NU
Hp/HgTpckZxBlFfBJvDWCkisp+/4djNIrHqFw112BVfWnHpmJsfxvuLUfi3N7L6p
3MP4hcMUz8LBKhHYxX7CpI5U6yUoNZYrooS8MR2ptsFqTEvUR9Mv8563zbcbzInI
7BwPY6gaVPUUM9pTvqKnMXNUlxp92OgO0I7xh9A1jMxN8VKg75gayus5zzz/9nn5
7URfNixsE+V66cGO1W9zW1c3nzXl2nC6vTLsH2mXcGomUVffk0WffsIEr3b1VS5w
zsBk0IBMhZ54nVPPsKa/xeqLyhQua8OyjQYseQKYhXw/c2rCh4TmQrAF6ywc0BM0
BVICznTFQcMOXGr/07+0Gabtl8Td+CokBcOFIXuF+DPFcqBpy1EEceMESozRyrds
78428Y7z3bsNvlH+BksfzCfCWMMN7A7T02fCRQQM5GNUEC2rWgTt8u55qlZgyKYF
ltoH34Cfp9f0gKftjNRSiWBa7jnJIkLwPjrwHpYnePghOgcSn85ka8vDj42hABj4
Xv9x25EDY99ZuVFQMQor2IJWnj4NeNJrhFylRAKB83JxeZhMox8xlIXoZsw7mVvX
B84V8gF3K3dgLVeTTpWh
=nYWb
-----END PGP SIGNATURE-----

--sxcKqVIrQG6u5WhMoLONmI5ElNCFKQ9j6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
