From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Thu, 27 Jul 2017 14:34:57 -0400
Message-ID: <a1abee42-58d2-aba6-bc56-9bf1830a4539@redhat.com>
References: <20170726053749.GV3259@mtr-leonro.local>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
 <20170726130350.GW3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6qiKC8JE6DXxVfbBj5FacoEvFmcS8fhPe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6qiKC8JE6DXxVfbBj5FacoEvFmcS8fhPe
Content-Type: multipart/mixed; boundary="nuaCsKuwjwN34IsQ4OOa28qSE5rJs1MqA";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Message-ID: <a1abee42-58d2-aba6-bc56-9bf1830a4539-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
References: <20170726053749.GV3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170726130350.GW3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--nuaCsKuwjwN34IsQ4OOa28qSE5rJs1MqA
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/2017 9:03 AM, Leon Romanovsky wrote:
> On Wed, Jul 26, 2017 at 08:24:44AM -0400, Dennis Dalessandro wrote:
>> On 7/26/2017 1:37 AM, Leon Romanovsky wrote:
>>> Reply to: "Re: [PATCH for-next 7/9] IB/core: Allow QP state transitio=
n from reset to error"
>>>
>>> On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
>>>> On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
>>>
>>> <snip>
>>>
>>>>> BTW, when will you post for-4.14 branch so we will be able to base =
our
>>>>> submission queue for the -next?
>>>>
>>>> Tomorrow.  I wanted to base it on 4.13-rc2 so it would get all of th=
e
>>>> fixes that went in this week.
>>>
>>> Any news on the matter?
>>>
>>
>> Check Doug's GitHub, I see a 4.13-rc2 based "for-next" branch there.
>=20
> Are you referring to this branch?
> https://github.com/torvalds/linux/compare/master...dledford:k.o/for-nex=
t
>=20
> It doesn't have most of mlx5/mlx4/cavium/core/e.t.c features.

Oh, and I never said I would be *done* processing the for-next area all
in one go.  You said you wanted regular progress and updates, and the
branch I have represents that.  But regular progress does not mean take
everything all at once.  As I process more patchsets, more will be added.=



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--nuaCsKuwjwN34IsQ4OOa28qSE5rJs1MqA--

--6qiKC8JE6DXxVfbBj5FacoEvFmcS8fhPe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZejJRAAoJELgmozMOVy/dIH0P/AwxfuILtHiNGFKZ/e6Oz69x
S2lNov16TealPrfwRawH+Jb0Nhu6Ya7UWG/v9H/F6KNI4aMbRsleFRXPPw/6s9yd
3I4NFYZ6i07DJ0tY5jYi8T6JA4nEhLbw9GCyMdKav6fe9MBuq3zg+VS0EIQkPGsv
MTWpxK/2r6srhDSAdTV1Rwtaf0+kMvpnpXyO3bdCeaptbUYhBnxLefC1z5dheVD2
AuzXqW8/79kB/Y2jZ9hlIunj3OUp7hBMEW0JTpJQh4uOfXQjXB9jwGpOkfqv4STY
ivO0VazSJ5YHeb6zNGp8rZjxPdxYS0snW80tE/ot35HuS4D4aUB385yb3Ux+u5VU
LYGYrBANJnjB7+H1v5VRXoaMTT2PimpbJ8fgPHi/jGRXVipp7mXevxqkanPqal5q
s4JN89X/hCUHWsxCnWl+YTQC/XmWKauodHScHb/jwOQfrOcmNEBfXr08GVagrnbG
V/AGdV1v+LvkQce2AWTdEtMOp/0gl09H6wyEiCaushS8i4qNWn6Ad1ZhLm1VVHm5
W6i7hVC8qFDxfiv23xnTDhRW7Y2sLP2RGnPt4oPs4o/h56vmRNqZVSUTX9nHIu4Q
hoMWL6vf2k0LBck+DJKCMAmWGURldCMwsctUZ61GwENiTRLoTCWRIztKMKbn0LDZ
6c2ohP68Fd329AZaNY4N
=2KSM
-----END PGP SIGNATURE-----

--6qiKC8JE6DXxVfbBj5FacoEvFmcS8fhPe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
