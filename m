From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
Date: Mon, 7 Aug 2017 13:35:11 -0400
Message-ID: <2b71135e-2cfb-e71b-f511-95dcfbc3be34@redhat.com>
References: <20170726181232.7363-1-leon@kernel.org>
 <2679977c-6258-ed15-a234-3682b8be65f3@intel.com>
 <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q4DnUMG5E3HmckfVDlcFTqRgrbdoKB4iE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q4DnUMG5E3HmckfVDlcFTqRgrbdoKB4iE
Content-Type: multipart/mixed; boundary="KOsMHnH57i2VtS9K1o9NTNkxcsKTnfDjK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <2b71135e-2cfb-e71b-f511-95dcfbc3be34-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
References: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <2679977c-6258-ed15-a234-3682b8be65f3-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--KOsMHnH57i2VtS9K1o9NTNkxcsKTnfDjK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/27/2017 11:06 AM, Dennis Dalessandro wrote:
> On 7/27/2017 11:05 AM, Dennis Dalessandro wrote:
>> On 7/26/2017 2:12 PM, Leon Romanovsky wrote:
>>> The following changes since commit
>>> a62ab66b13a0f9bcb17b7b761f6670941ed5cd62:
>>>
>>>    RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -04=
00)
>>>
>>> are available in the git repository at:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>>> tags/rdma-rc-2017-07-26
>>>
>>> for you to fetch changes up to 5dc78ad1904db597bdb4427f3ead437aae86f5=
4c:
>>>
>>>    IB/ipoib: Notify on modify QP failure only when relevant
>>> (2017-07-23 10:52:00 +0300)
>>>
>>> ----------------------------------------------------------------
>>> IPoIB fixes for 4.13
>>>
>>> The patchset provides various fixes for IPoIB. It is combination of
>>> fixes to various issues discovered during verification along with
>>> static checkers cleanup patches.
>>>
>>> Most of the patches are from pre-git era and hence lack of Fixes line=
s.
>>
>> I'm not sure that patches 4,6,7,8, and 11 really should go in the RC.
>> I think those should go to for-next. My opinion anyway.
>=20
> Ugh, one of those days, hands move faster than brain. That should have
> said 9 instead of 11.
>=20
> -Denny
>=20

I agree with Denny on 6 and 7, but I think the others are reasonable
fixes.  And given that both 6 and 7 are so small, I'm OK letting them
pass through this time.  I've pulled this series and pushed the
resulting k.o/for-4.13-rc branch to github.  Once it clears 0day testing
I'll push to k.o and send a pull request since we don't have any other
-rc submissions queued at the moment that I know of.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--KOsMHnH57i2VtS9K1o9NTNkxcsKTnfDjK--

--q4DnUMG5E3HmckfVDlcFTqRgrbdoKB4iE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZiKTQAAoJELgmozMOVy/dPZ4QAJvmhF3b9tzu4bu851aytUx0
Ormj1KNGFF4F9T3IYAp98xswJ/B3IOOAuEQ4Us6wkhS5fS5a33qPMnI0buASMUA/
8A1ufgILtugtI/3+1f0eWQFGn3xwvzVWgCpuwiV+5ugrBtnX9itd3clW+YZacFvp
h7go6IedporIdD+gaccQS+QjSFJLn8dH7vWvkdvfATKH8VFPk0xQPK1jqTvWnu3t
DzNqmsZN9O+KBLylOdHGtZAanexfSahbs57PZr/o5eXfgKLK8jECo++t02xu4LcS
M6Cii3OVKTICvaTuMKuvC4O4L0on3wljZDc83m1FqoDcCpbIcPeEAtLoomihw3OQ
Hm4eQWlN20wC9uNq7aaK3unyPu11g5bSnhK2Qhh2WYQkm9N1QvPXjIb7lviSC+ra
9V7pstRGcribi608g8p3u6aLFMasr2USup7AXnxDm5H03FXplIu27R5IXZYiHOfY
vbQs059mn2tBxEGQUNWoXrzItvf2QObIkAl+0lGVGWO77aolNF00vsnsekq3Ojfn
0kOhMEbTzVPNUaJCmZSadQfS8wu28HmB7F4zfpje7X8JrBI6AMe8i+254EPW8W13
6sUFR2/fQ2dXltX7apSMvmnXcP9pq4eSx9DPm73IgXZkEbr/DqHNXAzaQCk3iS6v
ZMUubhIVy27ei08bwyGJ
=5INV
-----END PGP SIGNATURE-----

--q4DnUMG5E3HmckfVDlcFTqRgrbdoKB4iE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
