From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v7 0/9] SELinux support for Infiniband RDMA
Date: Fri, 19 May 2017 16:47:44 +0000
Message-ID: <VI1PR05MB1678F822760B7C5F8E263573C4E50@VI1PR05MB1678.eurprd05.prod.outlook.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2017 7:49 AM, Dan Jurgens wrote:=0A=
> From: Daniel Jurgens <danielj@mellanox.com>=0A=
>=0A=
> Note on v7, it applies cleanly on Paul Moores' tree.  'git am' fails to=
=0A=
> apply patch 0002* to Dougs' tree, but 'patch' applies it without rejects.=
=0A=
> There's a new file that needs to be added before resolving the git am,=0A=
> drivers/infiniband/core/security.c=0A=
=0A=
There's actually a trivial merge conflict in drivers/infiniband/core/uverbs=
.c that doesn't cause patch to create a reject file, in the function create=
_qp a my patch adds a "goto err_destroy;".  In Dougs' tree it needs to be c=
hanged to "goto err_cb".=0A=
=0A=
=0A=
>=0A=
> Infiniband applications access HW from user-space -- traffic is generated=
=0A=
> directly by HW, bypassing the kernel. Consequently, Infiniband Partitions=
,=0A=
> which are associated directly with HW transport endpoints, are a natural=
=0A=
> choice for enforcing granular mandatory access control for Infiniband. QP=
s=0A=
> may only send or receives packets tagged with the corresponding partition=
=0A=
> key (PKey). The PKey is not a cryptographic key; it's a 16 bit number=0A=
> identifying the partition.=0A=
>=0A=
> Every Infiniband fabric is controlled by a central Subnet Manager (SM).=
=0A=
> The SM provisions the partitions by assigning each port with the=0A=
> partitions it can access. In addition, the SM tags each port with a subne=
t=0A=
> prefix, which identifies the subnet. Determining which users are allowed=
=0A=
> to access which partition keys on a given subnet forms an effective polic=
y=0A=
> for isolating users on the fabric. Any application that attempts to send=
=0A=
> traffic on a given subnet is automatically subject to the policy,=0A=
> regardless of which device and port it uses. SM software configures the=
=0A=
> subnet through a privileged Subnet Management Interface (SMI), which is=
=0A=
> presented by each Infiniband port. Thus, the SMI must also be controlled=
=0A=
> to prevent unauthorized changes to fabric configuration and partitioning.=
 =0A=
>=0A=
> To support access control for IB partitions and subnet management,=0A=
> security contexts must be provided for two new types of objects - PKeys=
=0A=
> and IB ports.=0A=
>=0A=
> A PKey label consists of a subnet prefix and a range of PKey values and i=
s=0A=
> similar to the labeling mechanism for netports. Each Infiniband port can=
=0A=
> reside on a different subnet. So labeling the PKey values for specific=0A=
> subnet prefixes provides the user maximum flexibility, as PKey values may=
=0A=
> be determined independently for different subnets. There is a single=0A=
> access vector for PKeys called "access".=0A=
>=0A=
> An Infiniband port is labeled by device name and port number. There is a=
=0A=
> single access vector for IB ports called "manage_subnet".=0A=
>=0A=
> Because RDMA allows kernel bypass, enforcement must be done during=0A=
> connection setup. Communication over RDMA requires a send and receive=0A=
> queue, collectively known as a Queue Pair (QP). A QP must be initialized=
=0A=
> by privileged system calls before it can be used to send or receive data.=
=0A=
> During initialization the user must provide the PKey and port the QP will=
=0A=
> use; at this time access control can be enforced.=0A=
>=0A=
> Because there is a possibility that the enforcement settings or security=
=0A=
> policy can change, a means of notifying the ib_core module of such change=
s=0A=
> is required. To facilitate this a generic notification callback mechanism=
=0A=
> is added to the LSM. One callback is registered for checking the QP PKey=
=0A=
> associations when the policy changes. Mad agents also register a callback=
,=0A=
> they cache the permission to send and receive SMPs to avoid another per=
=0A=
> packet call to the LSM.=0A=
>=0A=
> Because frequent accesses to the same PKey's SID is expected a cache is=
=0A=
> implemented which is very similar to the netport cache.=0A=
>=0A=
> In order to properly enforce security when changes to the PKey table or=
=0A=
> security policy or enforcement occur ib_core must track which QPs are=0A=
> using which port, pkey index, and alternate path for every IB device.=0A=
> This makes operations that used to be atomic transactional.=0A=
>=0A=
> When modifying a QP, ib_core must associate it with the PKey index, port,=
=0A=
> and alternate path specified. If the QP was already associated with=0A=
> different settings, the QP is added to the new list prior to the=0A=
> modification. If the modify succeeds then the old listing is removed. If=
=0A=
> the modify fails the new listing is removed and the old listing remains=
=0A=
> unchanged.=0A=
>=0A=
> When destroying a QP the ib_qp structure is freed by the decive specific=
=0A=
> driver (i.e. mlx4_ib) if the 'destroy' is successful. This requires stori=
ng=0A=
> security related information in a separate structure. When a 'destroy'=0A=
> request is in process the ib_qp structure is in an undefined state so if=
=0A=
> there are changes to the security policy or PKey table, the security chec=
ks=0A=
> cannot reset the QP if it doesn't have permission for the new setting. If=
=0A=
> the 'destroy' fails, security for that QP must be enforced again and its=
=0A=
> status in the list is restored. If the 'destroy' succeeds the security in=
fo=0A=
> can be cleaned up and freed.=0A=
>=0A=
> There are a number of locks required to protect the QP security structure=
=0A=
> and the QP to device/port/pkey index lists. If multiple locks are require=
d,=0A=
> the safe locking order is: QP security structure mutex first, followed by=
=0A=
> any list locks needed, which are sorted first by port followed by pkey=0A=
> index.=0A=
>=0A=
> ---=0A=
> v2:=0A=
> - Use void* blobs in the LSM hooks. Paul Moore=0A=
> - Make the policy change callback generic. Yuval Shaia, Paul Moore=0A=
> - Squash LSM changes into the patches where the calls are added. Paul Moo=
re=0A=
> - Don't add new initial SIDs. Stephen Smalley=0A=
> - Squash MAD agent PKey and SMI patches and move logic to IB security.=0A=
>   Dan Jurgens=0A=
> - Changed ib_end_port to ib_port. Paul Moore=0A=
> - Changed ib_port access vector from smp to manage_subnet. Paul Moore=0A=
> - Added pkey and ib_port details to the audit log. Paul Moore=0A=
> - See individual patches for more detail.=0A=
>=0A=
> v3:=0A=
> - ib_port -> ib_endport. Paul Moore=0A=
> - use notifier chains for LSM notifications. Paul Moore=0A=
> - reorder parameters in hooks to put security blob first. Paul Moore=0A=
> - Don't treat device name as untrusted string in audit log. Paul Moore=0A=
>=0A=
> v4:=0A=
> - Added separate AVC callback for LSM notifier. Paul Moore=0A=
> - Removed unneeded braces in ocontext_read. Paul Moore=0A=
>=0A=
> v5:=0A=
> - Fix link error when CONFIG_SECURITY is not set. Build Robot=0A=
> - Strip issue and Gerrit-Id: Leon Romanovsky=0A=
>=0A=
> v6:=0A=
> - Whitespace and bracket cleanup. James Morris=0A=
> - Cleanup error flow in sel_pkey_sid_slow. James Morris=0A=
>=0A=
> v7:=0A=
> - Rebased, minor conflicts in drivers/infiniband/core/cache.c and uverbs.=
c=0A=
> - Synchronized ocontext naming with userspace.=0A=
> - Exclude IB_QPT_RESERVED* qp types, in ib_security_modify_qp they are=0A=
>   special QPs like GSI and SMI, and only used by the kernel.=0A=
>=0A=
> Daniel Jurgens (9):=0A=
>   IB/core: IB cache enhancements to support Infiniband security=0A=
>   IB/core: Enforce PKey security on QPs=0A=
>   selinux lsm IB/core: Implement LSM notification system=0A=
>   IB/core: Enforce security on management datagrams=0A=
>   selinux: Create policydb version for Infiniband support=0A=
>   selinux: Allocate and free infiniband security hooks=0A=
>   selinux: Implement Infiniband PKey "Access" access vector=0A=
>   selinux: Add IB Port SMP access vector=0A=
>   selinux: Add a cache for quicker retreival of PKey SIDs=0A=
>=0A=
>  drivers/infiniband/core/Makefile     |   3 +-=0A=
>  drivers/infiniband/core/cache.c      |  43 ++-=0A=
>  drivers/infiniband/core/core_priv.h  | 115 ++++++=0A=
>  drivers/infiniband/core/device.c     |  86 +++++=0A=
>  drivers/infiniband/core/mad.c        |  52 ++-=0A=
>  drivers/infiniband/core/security.c   | 710 +++++++++++++++++++++++++++++=
++++++=0A=
>  drivers/infiniband/core/uverbs_cmd.c |  15 +-=0A=
>  drivers/infiniband/core/verbs.c      |  27 +-=0A=
>  include/linux/lsm_audit.h            |  15 +=0A=
>  include/linux/lsm_hooks.h            |  35 ++=0A=
>  include/linux/security.h             |  50 +++=0A=
>  include/rdma/ib_mad.h                |   4 +=0A=
>  include/rdma/ib_verbs.h              |  49 +++=0A=
>  security/Kconfig                     |   9 +=0A=
>  security/lsm_audit.c                 |  16 +=0A=
>  security/security.c                  | 413 ++++++++++++++++++++=0A=
>  security/selinux/Makefile            |   2 +-=0A=
>  security/selinux/hooks.c             |  86 ++++-=0A=
>  security/selinux/ibpkey.c            | 245 ++++++++++++=0A=
>  security/selinux/include/classmap.h  |   4 +=0A=
>  security/selinux/include/ibpkey.h    |  31 ++=0A=
>  security/selinux/include/objsec.h    |  11 +=0A=
>  security/selinux/include/security.h  |   7 +-=0A=
>  security/selinux/selinuxfs.c         |   2 +=0A=
>  security/selinux/ss/policydb.c       | 112 +++++-=0A=
>  security/selinux/ss/policydb.h       |  27 +-=0A=
>  security/selinux/ss/services.c       |  81 ++++=0A=
>  27 files changed, 2207 insertions(+), 43 deletions(-)=0A=
>  create mode 100644 drivers/infiniband/core/security.c=0A=
>  create mode 100644 security/selinux/ibpkey.c=0A=
>  create mode 100644 security/selinux/include/ibpkey.h=0A=
>=0A=
=0A=
