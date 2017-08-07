From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
Date: Mon, 7 Aug 2017 11:58:57 -0400
Message-ID: <b1e023eb-d852-2c79-b2d1-6d03e93db7a6@redhat.com>
References: <20170726181232.7363-1-leon@kernel.org>
 <20170806082018.GD3636@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6KqWQLhHerqTcDGxnEIQei1l6sHfPASXN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806082018.GD3636-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6KqWQLhHerqTcDGxnEIQei1l6sHfPASXN
Content-Type: multipart/mixed; boundary="RBI1U0K2F2me3P8H3fGFnbtvWWsggdf6P";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <b1e023eb-d852-2c79-b2d1-6d03e93db7a6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
References: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170806082018.GD3636-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170806082018.GD3636-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--RBI1U0K2F2me3P8H3fGFnbtvWWsggdf6P
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/6/2017 4:20 AM, Leon Romanovsky wrote:
> On Wed, Jul 26, 2017 at 09:12:21PM +0300, Leon Romanovsky wrote:
>> The following changes since commit a62ab66b13a0f9bcb17b7b761f6670941ed=
5cd62:
>>
>>   RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -0400=
)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git ta=
gs/rdma-rc-2017-07-26
>>
>> for you to fetch changes up to 5dc78ad1904db597bdb4427f3ead437aae86f54=
c:
>>
>>   IB/ipoib: Notify on modify QP failure only when relevant (2017-07-23=
 10:52:00 +0300)
>>
>> ----------------------------------------------------------------
>> IPoIB fixes for 4.13
>>
>> The patchset provides various fixes for IPoIB. It is combination of
>> fixes to various issues discovered during verification along with
>> static checkers cleanup patches.
>>
>> Most of the patches are from pre-git era and hence lack of Fixes lines=
=2E
>>
>> There is one exception in this IPoIB group - addition of patch revert:=

>> Revert "IB/core: Allow QP state transition from reset to error", but
>> it followed by proper fix to the annoying print, so I thought it is
>> appropriate to include it.
>>
>> Thanks
>> ----------------------------------------------------------------
>> Alex Vesker (2):
>>       IB/ipoib: Prevent setting negative values to max_nonsrq_conn_qp
>>       IB/ipoib: Add multicast packets statistics
>>
>> Erez Shitrit (3):
>>       IB/ipoib: Use cancel_delayed_work_sync when needed
>>       IB/ipoib: Make sure no in-flight joins while leaving that mcast
>>       IB/ipoib: Notify on modify QP failure only when relevant
>>
>> Feras Daoud (3):
>>       IB/ipoib: Fix race between light events and interface restart
>>       IB/ipoib: Set IPOIB_NEIGH_TBL_FLUSH after flushed completion ini=
tialization
>>       IB/ipoib: Add get statistics support to SRIOV VF
>>
>> Leon Romanovsky (3):
>>       IB/ipoib: Clean error paths in add port
>>       IB/ipoib: Remove double pointer assigning
>>       Revert "IB/core: Allow QP state transition from reset to error"
>>
>>  drivers/infiniband/core/verbs.c                |  1 -
>>  drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
>>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  1 -
>>  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |  3 ++-
>>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 25 +++++++++++++++++=
+-
>>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 19 +++++++++------
>>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 33 +++++++++--------=
---------
>>  7 files changed, 50 insertions(+), 33 deletions(-)
>=20
>=20
> Reminder


Yep, was planning on going through these today.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--RBI1U0K2F2me3P8H3fGFnbtvWWsggdf6P--

--6KqWQLhHerqTcDGxnEIQei1l6sHfPASXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZiI5CAAoJELgmozMOVy/d16MP/0xsqyfvrzYEvClUQ88IO2ac
iH6W9x3kV/bZodk/VB1r1hwSzD1+nA+r1Pw/B5jhQ49+5nburd/IAo+LbhOS+mhr
0L6cM0XaYkkwcBk9pN7PF6lXzUWTsZ5nKmhugfcfGIpQMCwIDpHhS6pGSAdtGRQL
rkG4hMNZWwrAl44CSJN0iC2lt/1hRY++PnxyrjlMQuWCpS5pHhFi6RgvihEBeAds
huT34jvDx+CMwYGgJlxTi/jjtHeruPzIAxTJYnB1uUi0hlqYgPfzM7MKbl3WcodI
Xc59hdovLbDQHoEJab48wP+krar8WgN/YFsVBisfyec7utDavT+WRfq4Y85E5C9m
fSitHYut8uZCCHzoTqQCKD4/7+wjCwskBaAjVnXTmdYImj5XU5IijPesOc9Y9JjO
cQvs4mgupcOqJZqiyJfK6F3JL1Sta5DnQJER6GhzxCykmLU3etbuEOL5hj8ozwDr
O0L+mc8JLo1WduO7/GaMhmHt7OaAmTniQHs9KjtmHd4mn8WfgChEOfUrIUFpKlOB
oJ9KqbDWwb/eUIB2cWAU0t10KeJe52uqx0Gw+IsW+8XLS4p+rtnji816eEEgJYUz
9lkA4zZB+fT7XJV5njTlztrTLU3Nq5/UaTQYCRxjQqCS0ZijMOhSl4wCUxN5MEtF
mG0Dfcg83/Q4xM90Xqi2
=+04/
-----END PGP SIGNATURE-----

--6KqWQLhHerqTcDGxnEIQei1l6sHfPASXN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
