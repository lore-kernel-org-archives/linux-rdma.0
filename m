From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v5 2/9] IB/core: Enforce PKey security on QPs
Date: Tue, 22 Nov 2016 23:39:21 +0000
Message-ID: <VI1PR0501MB24296BD04561DA6EAF7AABF0C4B40@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com>
 <1479843638-67136-3-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1611230923240.3895@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/22/2016 5:24 PM, James Morris wrote:=0A=
> On Tue, 22 Nov 2016, Dan Jurgens wrote:=0A=
>=0A=
>> From: Daniel Jurgens <danielj@mellanox.com>=0A=
>>=0A=
>> Add new LSM hooks to allocate and free security contexts and check for=
=0A=
>> permission to access a PKey.=0A=
> I guess Doug's is best tree for these patches?=0A=
Maybe? In earlier versions I had kept the LSM, RDMA, and SELinux changes in=
 separate patches Paul Moore thought it was best to squash them together fu=
nctionally. Once everyone agrees they can merged they could all go to one t=
ree.  They apply cleanly to Paul and Doug's trees for sure.=0A=
>=0A=
>> ---=0A=
>> v2:=0A=
>> - Squashed LSM hook additions. Paul Moore=0A=
>> - Changed security blobs to void*. Paul Moore=0A=
>>=0A=
>> v3:=0A=
>> - Change parameter order of pkey_access hook. Paul Moore=0A=
>> ---=0A=
>>  drivers/infiniband/core/Makefile     |   3 +-=0A=
>>  drivers/infiniband/core/cache.c      |  21 +-=0A=
>>  drivers/infiniband/core/core_priv.h  |  77 +++++=0A=
>>  drivers/infiniband/core/device.c     |  33 ++=0A=
>>  drivers/infiniband/core/security.c   | 617 ++++++++++++++++++++++++++++=
+++++++=0A=
>>  drivers/infiniband/core/uverbs_cmd.c |  20 +-=0A=
>>  drivers/infiniband/core/verbs.c      |  27 +-=0A=
>>  include/linux/lsm_hooks.h            |  27 ++=0A=
>>  include/linux/security.h             |  21 ++=0A=
>>  include/rdma/ib_verbs.h              |  48 +++=0A=
>>  security/Kconfig                     |   9 +=0A=
>>  security/security.c                  |  31 ++=0A=
>>  12 files changed, 925 insertions(+), 9 deletions(-)=0A=
>>  create mode 100644 drivers/infiniband/core/security.c=0A=
>=0A=
> Acked-by: James Morris <james.l.morris@oracle.com>=0A=
>=0A=
>=0A=
=0A=
