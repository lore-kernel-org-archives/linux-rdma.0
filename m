From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
Date: Mon, 22 Aug 2016 14:32:23 -0400
Message-ID: <c67f0026-691c-b13a-eae7-109a5ebc4016@redhat.com>
References: <1471015057-9886-1-git-send-email-ira.weiny@intel.com>
 <20160814085511.GB21270@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ngOoXDo4XWcP00k2mqSQQAWVAIjAMNVTH"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160814085511.GB21270@leon.nu>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, ira.weiny@intel.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ngOoXDo4XWcP00k2mqSQQAWVAIjAMNVTH
Content-Type: multipart/mixed; boundary="7NBbB30pLaUnoCrG3xsHMOahjU9uLlOvf"
From: Doug Ledford <dledford@redhat.com>
To: Leon Romanovsky <leon@kernel.org>, ira.weiny@intel.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn
 <mike.marciniszyn@intel.com>, stable@vger.kernel.org
Message-ID: <c67f0026-691c-b13a-eae7-109a5ebc4016@redhat.com>
Subject: Re: [PATCH V2] IB/hfi1,IB/qib: Fix qp_stats sleep with rcu read lock
 held
References: <1471015057-9886-1-git-send-email-ira.weiny@intel.com>
 <20160814085511.GB21270@leon.nu>
In-Reply-To: <20160814085511.GB21270@leon.nu>

--7NBbB30pLaUnoCrG3xsHMOahjU9uLlOvf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/14/2016 4:55 AM, Leon Romanovsky wrote:
> On Fri, Aug 12, 2016 at 11:17:37AM -0400, ira.weiny@intel.com wrote:
>> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
>>
>> The qp init function does a kzalloc() while holding the RCU
>> lock that encounters the following warning with a debug kernel
>> when a cat of the qp_stats is done:
>>
>> [  231.723948] rcu_scheduler_active =3D 1, debug_locks =3D 0
>> [  231.731939] 3 locks held by cat/11355:
>> [  231.736492]  #0:  (debugfs_srcu){......}, at: [<ffffffff813001a5>] =
debugfs_use_file_start+0x5/0x90
>> [  231.746955]  #1:  (&p->lock){+.+.+.}, at: [<ffffffff81289a6c>] seq_=
read+0x4c/0x3c0
>> [  231.755873]  #2:  (rcu_read_lock){......}, at: [<ffffffffa0a0c535>]=
 _qp_stats_seq_start+0x5/0xd0 [hfi1]
>> [  231.766862]
>>
>> The init functions do an implicit next which requires the rcu read loc=
k
>> before the kzalloc().
>>
>> Fix for both drivers is to change the scope of the init function to on=
ly
>> do the allocation and the initialization of the just allocated iter.
>>
>> The implict next is moved back into the respective start functions to =
fix
>> the issue.
>>
>> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>> CC: <stable@vger.kernel.org> # 4.6.x-
>>
>> ---
>> Changes from V1:
>> 	use do.. while loop to execute first iter call.
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>=20

Sorry, responded to v1 email, but I applied the v2 patch.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--7NBbB30pLaUnoCrG3xsHMOahjU9uLlOvf--

--ngOoXDo4XWcP00k2mqSQQAWVAIjAMNVTH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0U3AAoJELgmozMOVy/dc2cP/1xTtLhjT9NIMzhGqqCx4w3s
zGCa5o0RYwbLqdAO0CIIBpQ+1iN9Q7yqRsZJELFd4aZYP37GmbXPDuX5zKfHVzbT
7SiyJfF7of8Vi2tpOdWGs6ieTiY4lEPAQHjMfZf8ZFszIBnZAt5FNSjQmIjP/Qh6
WowNZj1J8xfbEeQDi0GucWvBzU8t1LBmYV1YiIhFWLSGI476wwb9n3CrJrBDXLKj
Y2PDFl1SDckuk9m6Ns2ZtJtIB5z9PtAy4OcOT8GHzA1KvRZeer/kvOkm+BUsXF8e
lFSD/1Ovw7pAE5kN5AZFKyDx0oKDjNDwr/D5+AN1/YI7Uuasl3c1Mf7gj/YGJz3o
C6mQ/djkeS/p4dqaa935ZytX50dcyIYa7N1wQI18Idus6F6+VRrB/nHYm2ae9+Zb
4hPpnpC95eo2Uf4dEnw55QWCjG/W0oZa4/frx36GJrbq9LE6RyVZk8ec+MtAFawQ
fWQOt55L9pPL/MX8vpwc+0A7pAYMeVt1TnaiR5ZESM9IhVoY5yffvKJkeBGdi3FP
gCYlgYH8wPLIdjMdWlRpsQH9XJ/nDUV2Ly4ZEN1WKkA81qCtvnK87krHWszJG6TW
NVEAZB4jxNRtLASceqWDgVFrWd+NH1/1JULNoUk9PEnkxF6h4TQFmLQzYTtuxjLe
+Dtqns3L9nwFHanytVHA
=bfST
-----END PGP SIGNATURE-----

--ngOoXDo4XWcP00k2mqSQQAWVAIjAMNVTH--
