From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/2] mlx5_core: mlx5_ifc updates
Date: Thu, 28 Apr 2016 21:41:37 -0400
Message-ID: <5722BBD1.3030005@redhat.com>
References: <1460563864-22931-1-git-send-email-saeedm@mellanox.com>
 <CALzJLG__o56edSf__To-BM6jakuwP7zAAEEQH8LQNTKp-2LRDQ@mail.gmail.com>
 <20160415.172254.1148340547086083909.davem@davemloft.net>
 <20160418151205.GO6349@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wUbUifba4aHLpvkFXm5aA3P62unDkeE4v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160418151205.GO6349-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org
Cc: saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wUbUifba4aHLpvkFXm5aA3P62unDkeE4v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/18/2016 11:12 AM, Leon Romanovsky wrote:
> On Fri, Apr 15, 2016 at 05:22:54PM -0400, David Miller wrote:
>> From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> Date: Fri, 15 Apr 2016 20:10:07 +0300
>>
>>> On Wed, Apr 13, 2016 at 7:11 PM, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=
 wrote:
>>>> Hi Dave and Doug
>>>>
>>>> Changes form V0:
>>>>         - 2nd patch commit message fixes.
>>>>
>>>> This series include mlx5_core updates for both net-next and rdma
>>>> trees for 4.7 kernel cycle. This is the only shared code planned
>>>> for 4.7 between rdma and net trees. Hopefully, this will prevent
>>>> future conflicts when merging between ib-next and net-next once
>>>> 4.7 cycle is over and merge window is opened.
>>>>
>>>> Both Mellanox rdma and net submissions will proceed once this series=

>>>> is applied into both trees.
>>>>
>>>> Future shared code will be sent to both maintainers as pull requests=

>>>> from Mellanox's kernel.org tree.
>>>>
>>>> We have included all the maintainers of respective drivers.
>>>> Kindly review the change and let us know in case of any review comme=
nts.
>>>>
>>>> Saeed Mahameed (1):
>>>>   net/mlx5: Update mlx5_ifc hardware features
>>>>
>>>> Tariq Toukan (1):
>>>>   net/mlx5: Fix mlx5 ifc cmd_hca_cap bad offsets
>>>>
>>>>  include/linux/mlx5/mlx5_ifc.h |  253 +++++++++++++++++++++++++++++-=
-----------
>>>>  1 files changed, 179 insertions(+), 74 deletions(-)
>>>>
>>>> --
>>>
>>> Hi Dave,
>>>
>>> This series is still in "Changes Requested" state in patchwork, but
>>> there is nothing to change here.
>>> I will be glad if you give it a shot, it is blocking all of our mlx5
>>> activities for both net and rdma trees.
>>
>> Series applied, thanks.
>=20
> Hi Doug,
> Can you please take this patchset in addition to Dave? It will save
> our list from many kbuild errors.

Dave, did you pull this from Leon's git repo, or apply patches and
generate new, unique commit hashes?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wUbUifba4aHLpvkFXm5aA3P62unDkeE4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIrvSAAoJELgmozMOVy/dBKoQALdUEnLtIDdHRFlmnoEf9a+5
8Rf6h3lIBCd9YNHn7ExFAnY375QKuI6UhPsaPDcRBnyNr/xAq513vaPu0XUHQPFr
wyEJL6shtShocPUwL47zUKMKjXL6BhIxCkXpVF1yakLWFlXJxpK8+5ICK6AREslu
pYJqZDO3crHSHEeDHPgMqE6LhpWxmAsZ1ULeh69cUEdlE1Rzg5rY1vqMjKcHvzjN
PjgAS2TLLLJ+VRyWc9d8rU+EftJ++MRNv6JnqglJvCHpHaVrtWiOw6b8hDC8b30U
V5TsqseFI9tH8cTSV4rZ0jq88mVtki9eC3BJND2xjRDNHOCT3u2N33/YEHbP127z
1j+RUU0hh17IqLBYppvaVjiJBvcpZcqSb3H5fGGKpJzno6ylKgck0QO9eDyF5oMO
9p1KbuHzmt+xn1P37GURBv3Nx/54XLEONTXOCbsH2ixKQQ0iMJrqerCDJXDhXH66
B3hpeI37LQmkgsLDnR80bFySNcEq+OqkgWSHImtPjP8z9RdG/jPRudEHC871rTWx
FahZj4gUlFFLsDqtOr0eBZBvh50SoOqcQgvy5vNo3vCXlWb4rDECa6zg8/w5O96w
8UogmYu/TSviIqZ3YCqwPy3+fXQNY66MEiXVZON920+LTgr2/p+m9FWqIGnYDFkR
Xs8iYL7FGcQ1SuHUZICw
=c64k
-----END PGP SIGNATURE-----

--wUbUifba4aHLpvkFXm5aA3P62unDkeE4v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
