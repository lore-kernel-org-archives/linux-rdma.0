From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/9] Add RoCE v2 support
Date: Mon, 23 Nov 2015 14:53:37 -0500
Message-ID: <56536EC1.6020800@redhat.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
 <CAAKD3BBm2WZ8TqSFi7gC82BwBTCc+D-SJSpSSqhEqMjL8-Fq_A@mail.gmail.com>
 <CAJ3xEMiAkz0aouPgHWD31CwrX4SmOQfysJBX2kQOZ91gVP+94g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bT71EHH3P6pw7C2OvFOi8fugbQOaxlrk7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiAkz0aouPgHWD31CwrX4SmOQfysJBX2kQOZ91gVP+94g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bT71EHH3P6pw7C2OvFOi8fugbQOaxlrk7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/22/2015 04:28 PM, Or Gerlitz wrote:
> On Mon, Nov 16, 2015, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On Thu, Oct 15, 2015 , Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
>>> Hi Doug,
>>> This series adds the support for RoCE v2. In order to support RoCE v2=
,
>>> we add gid_type attribute to every GID. When the RoCE GID management
>>> populates the GID table, it duplicates each GID with all supported ty=
pes.
>>> This gives the user the ability to communicate over each supported ty=
pe.
>=20
>> Hi Doug,
>> This series was posted a month ago.
>> If you have any comments, I would appreciate if you could please post =
them.
>=20
> Doug,
>=20
> Correction. The series was posted on Aug 13 -- three months ago, see [1=
].
>=20
> I think it's terribly fair enough to know where it stands w.r.t
> deployment into 4.5

It's normally fair as you say.  However, as you know, I've been out for
a while.  This set only missed 4.4 because I didn't have time to review
it prior to the merge window.  Not the fault of anyone who submitted it,
but a reality of my life circumstances none the less.  Reviewing this
and getting the blocked code moving forward is at the top of my 4.5
candidate list.

> Lack of RoCE v2 support in the IB core is slowing down the RocE
> support for mlx5 and adoption of Soft-RoCE, it's fair enough to ask
> for you as maintainer to react/respond after three months the patches
> are waiting.
>=20
> Or.
>=20
> [1] http://marc.info/?l=3Dlinux-rdma&m=3D143948192926723&w=3D2
>=20
>> Otherwise, could we please push this series to v4.5?
>> If you need, I can rebase it over your for-4.5 branch once you'll open=

>> such a branch.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bT71EHH3P6pw7C2OvFOi8fugbQOaxlrk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWU27IAAoJELgmozMOVy/dCicP/05YSe7x9IhtqVBsvBmJUQaC
IRQvIC2QaYv3jf3qmB0Cp4+ZmlQTGf4Jlb+Uthqr3uTA0a5vsTVlVWbGIVmq8IYm
Vn1Km7oHMTfWFt4a4EXtrFtCc4K4ROx9ozwSZnHBpfGyoKHIaDGqRtrtoCpVKaGi
SdCaIJP3kNga1iUljzf1ThRZcmcZ2c1o0/h0HMK2vEqwc5+FyBQH44phu4/QdQK6
4l4DAKaAV5KmQe1B5Flbjm11cKirZYddtzv0FhV9BPhimvpxFo6J164Uy6qYn10v
SSiCs8gwBmSURjiEcfkgmbapkbefiH8wr6xoPP+XZ7AJbgQDou/T2w8qRoTrr0Sh
6UR8IJqUni3q5uhVdWf5Su3sxkwH8VMrv+ZxVheeIVJTkON4huAjej/N+MA/QFr3
gCNtpBz8yHPFXvV6biFffef9BWOfdykGUetV+WURKENrzw6wMtA4C02lI5AO4O7C
cRgNpfNymC85EyUiY0yLYcuJVa24rUphkKieuwpDB1+/LRZBem4LUfES+OLz982c
fa5PMqihZjWU/O9d2vDhm1cr7oBwPLIRXylsk1IuXxcW4OGMzXLPFmsi5IJLQS1j
0zG6jXCEhpEDXcJZFRzsPikqf9Ls4LU5MyjrJQ7mX6MjhsLwAqN1KB3jXrHxbvaZ
mgaY8G/SzhSadkvFrwkv
=Bfqx
-----END PGP SIGNATURE-----

--bT71EHH3P6pw7C2OvFOi8fugbQOaxlrk7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
