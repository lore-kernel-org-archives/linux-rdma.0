From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] User-index fixes
Date: Thu, 3 Mar 2016 10:08:56 -0500
Message-ID: <56D85388.6010905@redhat.com>
References: <1455467752-3170-1-git-send-email-matanb@mellanox.com>
 <56C49D8C.2000605@redhat.com> <56D80A9D.6030507@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7pPnETwa4lRPLhjNl0JATJkowUxxAfQDw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D80A9D.6030507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7pPnETwa4lRPLhjNl0JATJkowUxxAfQDw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/03/2016 04:57 AM, Majd Dibbiny wrote:
>=20
> On 17/2/2016 6:19 PM, Doug Ledford wrote:
>> On 02/14/2016 11:35 AM, Matan Barak wrote:
>>> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> Hi Doug,
>>>
>>> This series fixes two issues introduced in 4.5 after applying my
>>> series "Raw Packet QP user-space support for mlx5".
>>>
>>> SRQs don't use user-index, therefore the user shouldn't pass it and t=
he
>>> kernel shouldn't verify. The first patch fixes this by avoiding
>>> user-index verification for non-xrc srqs.
>>>
>>> The mlx5_ib driver fails libraries that support user-index but don't
>>> pass it. It relies on the input length of the vendor specific part to=

>>> determine whether the user-space supports user-index.
>>>
>>>
>>> In Legacy verbs, the given vendor specific part input length is given=

>>> including struct ib_uverbs_cmd_hdr. In contrast, extended commands
>>> pass the same length exluding the header size.
>>> The vendor driver doesn't know whether the command is a legacy
>>> command or an extended command. Thus, we need to modify IB/core
>>> in order to pass a consistent size. The second patch fixes the input
>>> length in the IB/core and the wrong usage in the mlx5_ib.
>>>
>>> We verified that other vendors don't use the inlen parameter and thus=

>>> won't break by this change.
>>>
>>> Thanks,
>>> Majd and Matan
>>>
>>>
>>> Majd Dibbiny (2):
>>>   IB/mlx5: Avoid using user-index for SRQs
>>>   IB/{core, mlx5}: Fix input len in vendor specific part of
>>>     create_qp/srq cmd
>>>
>>>  drivers/infiniband/core/uverbs_cmd.c |  9 +++++---
>>>  drivers/infiniband/hw/mlx5/srq.c     | 41 +++++++++++++++++++-------=
----------
>>>  2 files changed, 28 insertions(+), 22 deletions(-)
>>>
>> These went in already in case you missed it.  Thanks.
> Hi Doug,
>=20
> I can't see those patches in your git repositories.
> Where were they applied to?

I *thought* they had went in via 4.5-rc already.  Upon double checking,
they weren't there, but I had marked them accepted in patchworks.  I
never mark them accepted until I download the patch files, and the patch
files for these two patches were no longer in my download directory.
That means either I applied them at one point and then they got removed
(probably by a git reset --hard HEAD~# to redo something before I pushed
it) or else simply never got applied when I thought they did.  In any
case, thanks for catching this.  I've added it to my k.o/for-4.5-rc
branch to go out later today to Linus.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7pPnETwa4lRPLhjNl0JATJkowUxxAfQDw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2FOIAAoJELgmozMOVy/dYUQP/R2DIEe2sJ1YZI0XfDi+91ek
l+07d9xHL1JTGE/2fElxOQw4R7fX9UfNEuIkNl/rUaH+nnsc7VM4XAkHrrqA3DA/
+AiUNduDrBN751EKgjiyVEthS+UGVvVHIO3agqaV+/Elu1RAzJoxDGSCBTB8/stH
Y/Pw54x5rZUGoUW+UKBwVNPv3Phr9GQ3aFVuIx2JlNlFgD3qWqcRzoaGxG+a8loV
6xVN2g58kvSt//krtchEPqvMTi4BkHxjOG3jcfPF1OIshRNRXQpZWyYJFkausW8x
4CcvDd7YZkIiiu/vuYWpvBVOEBPscrndp4ZrLoFoJj4AmsRx2ou0WntMgvvAMhQh
KRmETJFqZyFRJxJWJbmQDsULQB+Ts2jmLIzpP1a/GXTRxO61YU5EuZSaupLD+lUn
ED8gXU+KOzuCXJjnutZqRIZZjm3PnOcMjoczgYD+taUuuzdRe/2XcKRRK+O6uThv
UhTu2NIyuUXWwYbdzwbDmwExaGV08f9D/Tp33Uz53TnZgEieGfc9D1JDvXVDUPNg
9rz6Lb0fbGbJn9/mNeF/uLgUOQuEWzS3AwCUvTO4Hgt7b0MsE8qbr4eJuz1rrmpj
PEwx3AbwDBJt7+6KZ/YdfBnWgF2+TahRfY9K/ooH95vkznBZIC9rY3ZjIlTpYoWq
HjSmo9gekaXMrtaLAEBI
=f2YZ
-----END PGP SIGNATURE-----

--7pPnETwa4lRPLhjNl0JATJkowUxxAfQDw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
