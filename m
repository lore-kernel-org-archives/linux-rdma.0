From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000070a78
 IPoIB
Date: Thu, 23 May 2013 14:55:22 -0400
Message-ID: <519E661A.5090209@redhat.com>
References: <51963BC6.1050901@profitbricks.com> <519B6DD6.4090502@profitbricks.com> <519B909A.8010004@profitbricks.com> <519E37DE.1080504@profitbricks.com> <519E54D9.1050506@redhat.com> <519E65B5.1090909@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HPDPUAGRQECOGIGEWNVS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519E65B5.1090909-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HPDPUAGRQECOGIGEWNVS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/23/2013 02:53 PM, Jack Wang wrote:
> On 2013=E5=B9=B405=E6=9C=8823=E6=97=A5 19:41, Doug Ledford wrote:
>> On 05/23/2013 11:38 AM, Jack Wang wrote:
>>> Tainted: G           O 3.4.23-pserver-hotfix+ #109 System manufacture=
r
>>                          ^^^^^^^
>>
>> I would try a newer kernel.  There are a couple known issues fixed sin=
ce
>> this kernel (including a memory corrupter that was involved with
>> neighbor list handling, and some of your traces look vaguely familiar =
to
>> that old failuer).
>>
>>
>>
>=20
> Thanks Doug for reply, I tried branch rdma-for-linus, It panic in other=

> places.
>=20
> Could you point me which commit do you mean exactly?
>=20
> Regards,
> Jack
>=20

Just try the official v3.9 kernel from Linus and see how it does.  A
'git checkout v3.9' will do the trick.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



------enig2HPDPUAGRQECOGIGEWNVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRnmYaAAoJELgmozMOVy/dzd4P/1SHk2pDekz259X4R+z7hm1L
3meHDgvpeMV4662B1u1O0Lc9KVue12HiK+SHsgoWDR2cv9eY52S3QwWKCu8XpcJ4
4LEATQp2+oDRpdkCZ/9PkW4lbe7fzLVMGsPhYjSuvHOCEj02MiLcWyJX/asuMqJ4
6C/EzcQaWrSAvY29xY8+d623fp/E4IRLxfeXeBtcZY+xbwCBrtxGZiB3T++iT++W
dGIRimDbsG9zQlWxD++4ifsphtSHdlR0wykOfhiUEHlpaM87CCUs9D4jc+4zxgds
ELK2G1zMAcOuhLB7d13GFmeu0gFZPHl6kZ9q13jqlvIyBOWeAAksdjtFixk0jKpM
KnxBvMusDWuDgVMyio3dAx3nNPbfRnrlSiNyhvrAOs+NUcaq02spMOgYfN8gSpI6
19Ow3rzk5a2pQQZAEt5YqUNUs6+8DyQKllv/aErMPcqIswCOY9QFjUnlNFwGPjUY
INtFniv9GV+eFQao5dhkhAN/8JzwGhCE83cJJ7uD47haufqhLnDOgCMU8u+zWDxm
3d9YaE26Dm19RoSkAtPeiZu3P4KYiZqnKXbEOwCGzbZAB6a+r5lhbKHh8ownrZRm
6QByslXbzBp3UMAKqBRO5r7OjESKcMR6/+xth3v8OUypc2f5luce0qayeViUmeEm
AiwIGSxBRa2Zy1Ypjz7T
=CzVB
-----END PGP SIGNATURE-----

------enig2HPDPUAGRQECOGIGEWNVS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
