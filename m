From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
Date: Thu, 22 Dec 2016 13:19:35 -0500
Message-ID: <ed8ea5d4-9cb2-465d-88a8-bdca848efcfd@redhat.com>
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1a61e971-4944-b8db-0fd5-b73118b578db@redhat.com>
 <20161222171323.GC18935@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ar9voopKAOPF4xeFE0FK9c9U98XRTt2iG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222171323.GC18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ar9voopKAOPF4xeFE0FK9c9U98XRTt2iG
Content-Type: multipart/mixed; boundary="qKffdC8Ahq6Hh7awiO2WCgtOLp9tbFbNB";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <ed8ea5d4-9cb2-465d-88a8-bdca848efcfd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <1a61e971-4944-b8db-0fd5-b73118b578db-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222171323.GC18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161222171323.GC18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--qKffdC8Ahq6Hh7awiO2WCgtOLp9tbFbNB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 12:13 PM, Leon Romanovsky wrote:
> On Thu, Dec 22, 2016 at 11:53:20AM -0500, Doug Ledford wrote:
>> On 12/19/2016 3:31 PM, Tatyana Nikolova wrote:
>>> RQ WQE size other than 128B is not supported.
>>> Correct RQ size calculation to use 128B only.
>>>
>>> Since this breaks ABI, add code to provide
>>> compatibility with V4 kernel driver, i40iw.
>>>
>>> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Thanks, applied.
>=20
> Hi Doug,
>=20
> Please can you clarify a process here?
>=20
> In previous discussions, you mentioned that the reason of not accepting=

> some code to rdma-core was because it is part of next kernel and we
> patiently waited for release. This code is definitely not relevant for
> current kernel, but you are already took it before we ever released fir=
st
> version of rdma-core.
>=20
> So why are we waiting with libpvrdma and RoCE address handle?

You're right, that was a mistake on my part.  I'll probably have to
revert this patch, then reapply it for the next version since the 4.10
kernel is the first one to provide the abi field to the user space librar=
y.

>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>     GPG Key ID: B826A3330E572FDD
>>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 =
2FDD
>>
>=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--qKffdC8Ahq6Hh7awiO2WCgtOLp9tbFbNB--

--ar9voopKAOPF4xeFE0FK9c9U98XRTt2iG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXBk3AAoJELgmozMOVy/dkl8P/0vthQEKuZ95z1qkpyj8l4qA
/QoMXchaSNsBn/6vnIgNZDOllqhuiYvUhhf3mFc1iL3Lh5KPTiQxKChjfLoxEC0w
km3FCuSBHOb0fQ7Lu5IFw3UQRs93rCQ09S7MSb5N+PTisKDW9iZR6Yc8Jz8B+ZCW
XnVtmLXqh/4kLINGSs5QVq8+sGQ384pyzupBJOSdnXmKBnQpBSrJTt71MZoqqR5z
2IB9mdVsbpVtRgPD7WnpJ+TzQBguV40mDWqEYZhGMkHHtaq+nJxiPbVVI4Vnzodb
/usQU9NsgAEpgVN4a6zEy2ZxQE/NVOQHZxzi4xoTezhX185mVb/qIL70wuUhz8F8
sp9vuf8S8BqwEhAshmM9iL9RME0y+WQuyXVDFMu5ZMylstisDPVoQHXuyb+rZ6Rk
DZeI6hKV5NLqbYpG/HEeMckE2IXlO/GesOnTu0mzeG3UMdfKcTfn7LALO4C2zRFL
7V401+AS9JGOD+SxWniv145O9VXfXPocAOlbDkUw32rcQGqBvQE9OP+Pr5kJm5DI
Pjp3dJ8HgOEFnzzX6wfzELadvQLpaQh0BDYc0kbLgLGT6iGDLZLp1KYJqfM+OzP/
MD7Oke7IZ6d5wWpgvGe8EsCGvv2ZnrM2CcXu2EyaycOhpYykDcGNmSY2OTPx4wuE
tERWHAZa7sFsb3sA37ik
=+l5S
-----END PGP SIGNATURE-----

--ar9voopKAOPF4xeFE0FK9c9U98XRTt2iG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
