From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 00/22] Remove deprecated create_workqueue instances
Date: Fri, 16 Sep 2016 13:26:26 -0400
Message-ID: <67bc634b-80c9-7848-2859-e39652daeb53@redhat.com>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AFKc72sN6tn2wUFUXpqq2IWRago45L0gh"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1471283717.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Leon Romanovsky <leonro@mellanox.com>, Chuck Lever <chuck.lever@oracle.com>, Mark Bloch <markb@mellanox.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>, Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Matan Barak <matanb@mellanox.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustaf>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AFKc72sN6tn2wUFUXpqq2IWRago45L0gh
Content-Type: multipart/mixed; boundary="72iI65baB6AL6qbIfvQ14pfmEmPbhAOmr";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
 Yishai Hadas <yishaih@mellanox.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>,
 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
 Leon Romanovsky <leonro@mellanox.com>, Chuck Lever <chuck.lever@oracle.com>,
 Mark Bloch <markb@mellanox.com>,
 Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
 Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>,
 Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>,
 Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>,
 Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>,
 Matan Barak <matanb@mellanox.com>, Chien Tin Tung
 <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>,
 Shiraz Saleem <shiraz.saleem@intel.com>,
 Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
 Steve Wise <swise@chelsio.com>, Mike Marciniszyn <infinipath@intel.com>,
 Bart Van Assche <bart.vanassche@sandisk.com>,
 Yotam Kenneth <yotamke@mellanox.com>,
 Somnath Kotur <Somnath.Kotur@Avagotech.Com>, Moni Shoua
 <monis@mellanox.com>, Shachar Raindel <raindel@mellanox.com>,
 Parav Pandit <pandit.parav@gmail.com>, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@infradead.org>, Dean Luick <dean.luick@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Kaike Wan <kaike.wan@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tejun Heo <tj@kernel.org>
Message-ID: <67bc634b-80c9-7848-2859-e39652daeb53@redhat.com>
Subject: Re: [PATCH 00/22] Remove deprecated create_workqueue instances
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
In-Reply-To: <cover.1471283717.git.bhaktipriya96@gmail.com>

--72iI65baB6AL6qbIfvQ14pfmEmPbhAOmr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/15/2016 1:57 PM, Bhaktipriya Shridhar wrote:
> This patch set removes the instances of deprecated
> create_singlethread_workqueue (scheduled for removal) in
> drivers/infiniband by making the appropriate conversions.
>=20
> Bhaktipriya Shridhar (22):
>   IB/sa : Remove deprecated create_singlethread_workqueue
>   IB/mad: Remove deprecated create_singlethread_workqueue
>   IB/multicast: Remove deprecated create_singlethread_workqueue
>   IB/ucma: Remove deprecated create_singlethread_workqueue
>   IB/cma: Remove deprecated create_singlethread_workqueue
>   IB/addr: Remove deprecated create_singlethread_workqueue
>   IB/iwcm: Remove deprecated create_singlethread_workqueue
>   iw_cxgb3: Remove deprecated create_singlethread_workqueue
>   IB/qib: Remove deprecated create_singlethread_workqueue
>   iw_cxgb4: Remove deprecated create_singlethread_workqueue
>   IB/mthca: Remove deprecated create_singlethread_workqueue
>   i40iw_main: Remove deprecated create_singlethread_workqueue
>   i40iw_cm: Remove deprecated create_singlethread_workqueue
>   IB/mlx5: Remove deprecated create_singlethread_workqueue
>   IB/mlx5/odp: Remove deprecated create_singlethread_workqueue
>   IB/mlx4: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/mad: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/mcg: Remove deprecated create_singlethread_workqueue
>   IB/nes: Remove deprecated create_singlethread_workqueue
>   IB/ipoib: Remove deprecated create_singlethread_workqueue
>   IB/ipoib_verbs: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/alias_GUID: Remove deprecated create_singlethread_workqueue
>=20
>  drivers/infiniband/core/addr.c             | 2 +-
>  drivers/infiniband/core/cma.c              | 2 +-
>  drivers/infiniband/core/iwcm.c             | 2 +-
>  drivers/infiniband/core/mad.c              | 2 +-
>  drivers/infiniband/core/multicast.c        | 2 +-
>  drivers/infiniband/core/sa_query.c         | 2 +-
>  drivers/infiniband/core/ucma.c             | 3 ++-
>  drivers/infiniband/hw/cxgb3/iwch_cm.c      | 2 +-
>  drivers/infiniband/hw/cxgb4/cm.c           | 2 +-
>  drivers/infiniband/hw/i40iw/i40iw_cm.c     | 7 +++++--
>  drivers/infiniband/hw/i40iw/i40iw_main.c   | 2 +-
>  drivers/infiniband/hw/mlx4/alias_GUID.c    | 2 +-
>  drivers/infiniband/hw/mlx4/mad.c           | 4 ++--
>  drivers/infiniband/hw/mlx4/main.c          | 2 +-
>  drivers/infiniband/hw/mlx4/mcg.c           | 4 ++--
>  drivers/infiniband/hw/mlx5/mr.c            | 2 +-
>  drivers/infiniband/hw/mlx5/odp.c           | 4 ++--
>  drivers/infiniband/hw/mthca/mthca_catas.c  | 2 +-
>  drivers/infiniband/hw/nes/nes_cm.c         | 4 ++--
>  drivers/infiniband/hw/qib/qib_init.c       | 4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_main.c  | 3 ++-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 2 +-
>  22 files changed, 33 insertions(+), 28 deletions(-)
>=20
> --
> 2.1.4
>=20

The commit message of patch 20/22 was not matching what you actually
did.  I fixed that up (the commit message, the patch was right), then
series applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--72iI65baB6AL6qbIfvQ14pfmEmPbhAOmr--

--AFKc72sN6tn2wUFUXpqq2IWRago45L0gh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3CtCAAoJELgmozMOVy/dgJwQALZcOYM0um7CgZxe5ESom6XX
3Dsu0alXHP+kn+Ogw8AiWaXMcu1PrPLkRA4tflMWIl/HBYpwMet2byU+027W3M65
pMMpSbmxjhvp8rHA2tpXYuK/DgsTsDooJrBTS99tozhZmW8UxvSSo74a1BXdERkL
vP5IEsEYFAzwW4LnS3NHZqxPfGu3cKtztYBA2Ytow/3kj/uIIr0nS5tdWeoYn+wD
YjEPeNlF2WoPCZBtsXsn1OUWUgapGjHPqZOU/ymlX4BlNSW+XXafHXLxevkyzCab
Nkcdlw0t981DYlRy701aCDPZNN2/eENwed20kYYxSHHVz6YmZgPXlJnhMwQHk53u
KXqgei6Oh0RLQQUEUTKcDn0IrQc/8X2wZnyfoyS2ez10qBrvdDhJLXAzlvQzPyQW
oWlLc2ZSRMRJqW7QeYHn3EGaYhWQbycO+EvepT5Va3zjz0FqDzD9Xn5UU796vK6X
/B5Dh5eMtQU3FOxFmDclfLKqM366VrLFigkZW8nE3iUYmsIXZy9MbnohVJo2lklF
xruQ24hZ603NyTh972arumP/rCwWfQGKUXn5oW3cF1TTEyHsvnWJCwYPm83iV4x+
RsyNOFQlUFedLZ908wl7lVA2EzV1wJ/Ig0j3BkPhV1huRH6ZMTiqfCjKBWl65W7+
ZFWEwz+VK1dtKeIA7Al/
=ZgOP
-----END PGP SIGNATURE-----

--AFKc72sN6tn2wUFUXpqq2IWRago45L0gh--
