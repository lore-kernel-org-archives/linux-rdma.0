From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v7 4/9] IB/core: Enforce security on management datagrams
Date: Fri, 19 May 2017 23:57:05 +0000
Message-ID: <DB5PR05MB1671BF6DE9B1EC2E66867870C4E50@DB5PR05MB1671.eurprd05.prod.outlook.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
 <1495198139-69993-5-git-send-email-danielj@mellanox.com>
 <CAHC9VhSqarh9TepvumkQxcS51bvtm_bH+gWpSeiR-XG83JbT-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2017 2:21 PM, Paul Moore wrote:=0A=
> On Fri, May 19, 2017 at 8:48 AM, Dan Jurgens <danielj@mellanox.com> wrote=
:=0A=
>> From: Daniel Jurgens <danielj@mellanox.com>=0A=
>>=0A=
>> Allocate and free a security context when creating and destroying a MAD=
=0A=
>> agent.  This context is used for controlling access to PKeys and sending=
=0A=
>> and receiving SMPs.=0A=
>>=0A=
>> When sending or receiving a MAD check that the agent has permission to=
=0A=
>> access the PKey for the Subnet Prefix of the port.=0A=
>>=0A=
>> During MAD and snoop agent registration for SMI QPs check that the=0A=
>> calling process has permission to access the manage the subnet  and=0A=
>> register a callback with the LSM to be notified of policy changes. When=
=0A=
>> notificaiton of a policy change occurs recheck permission and set a flag=
=0A=
>> indicating sending and receiving SMPs is allowed.=0A=
>>=0A=
>> When sending and receiving MADs check that the agent has access to the=
=0A=
>> SMI if it's on an SMI QP.  Because security policy can change it's=0A=
>> possible permission was allowed when creating the agent, but no longer=
=0A=
>> is.=0A=
>>=0A=
>> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>=0A=
>>=0A=
>> ---=0A=
>> v2:=0A=
>> - Squashed LSM hook additions. Paul Moore=0A=
>> - Changed security blobs to void*. Paul Moore=0A=
>> - Shorten end_port to port. Paul Moore=0A=
>> - Change "smp" to "manage_subnet". Paul Moore=0A=
>> - Use the LSM policy change notification and a flag to track permission=
=0A=
>>   instead of calling the LSM hook for every SMP. Dan Jurgens=0A=
>> - Squashed PKey and SMP enforcement into the same patch and moved the=0A=
>>   logic into security.c. Dan Jurgens=0A=
>>=0A=
>> v3:=0A=
>> - ib_port -> ib_endport. Paul Moore=0A=
>> - Use notifier chains for LSM notification. Paul Moore=0A=
>> - Reorder LSM hook parameters to put sec first. Paul Moore=0A=
>>=0A=
>>  drivers/infiniband/core/core_priv.h | 35 ++++++++++++++=0A=
>>  drivers/infiniband/core/mad.c       | 52 +++++++++++++++++----=0A=
>>  drivers/infiniband/core/security.c  | 92 ++++++++++++++++++++++++++++++=
+++++++=0A=
>>  include/linux/lsm_hooks.h           |  8 ++++=0A=
>>  include/linux/security.h            |  6 +++=0A=
>>  include/rdma/ib_mad.h               |  4 ++=0A=
>>  security/security.c                 |  8 ++++=0A=
>>  7 files changed, 197 insertions(+), 8 deletions(-)=0A=
> ...=0A=
>=0A=
>> diff --git a/security/security.c b/security/security.c=0A=
>> index 6eef315..b69fe6f 100644=0A=
>> --- a/security/security.c=0A=
>> +++ b/security/security.c=0A=
>> @@ -1540,6 +1540,12 @@ int security_ib_pkey_access(void *sec, u64 subnet=
_prefix, u16 pkey)=0A=
>>  }=0A=
>>  EXPORT_SYMBOL(security_ib_pkey_access);=0A=
>>=0A=
>> +int security_ib_endport_manage_subnet(void *sec, const char *dev_name, =
u8 port_num)=0A=
>> +{=0A=
>> +       return call_int_hook(ib_endport_manage_subnet, 0, sec, dev_name,=
 port_num);=0A=
>> +}=0A=
>> +EXPORT_SYMBOL(security_ib_endport_manage_subnet);=0A=
>> +=0A=
>>  int security_ib_alloc_security(void **sec)=0A=
>>  {=0A=
>>         return call_int_hook(ib_alloc_security, 0, sec);=0A=
>> @@ -2014,6 +2020,8 @@ struct security_hook_heads security_hook_heads __l=
sm_ro_after_init =3D {=0A=
>>=0A=
>>  #ifdef CONFIG_SECURITY_INFINIBAND=0A=
>>         .ib_pkey_access =3D LIST_HEAD_INIT(security_hook_heads.ib_pkey_a=
ccess),=0A=
>> +       .ib_endport_manage_subnet =3D=0A=
>> +               LIST_HEAD_INIT(security_hook_heads.ib_endport_manage_sub=
net),=0A=
>>         .ib_alloc_security =3D=0A=
>>                 LIST_HEAD_INIT(security_hook_heads.ib_alloc_security),=
=0A=
>>         .ib_free_security =3D=0A=
> The same problem as 2/9 regarding the LSM hook code.  I'll also drop=0A=
> this block, but update your patch in case you need to respin.=0A=
>=0A=
Thanks, updated locally as well in both cases.=0A=
=0A=
