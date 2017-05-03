From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Wed, 3 May 2017 19:45:33 +0000
Message-ID: <VI1PR05MB167880A4D79F8FC3F8C740A9C4160@VI1PR05MB1678.eurprd05.prod.outlook.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhSB6AORJf_8cBGt-AynMsEh3snKU5SpsmNXoy9hDSrGaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 5/3/2017 9:41 AM, Paul Moore wrote:=0A=
> On Wed, Nov 23, 2016 at 9:17 AM, Dan Jurgens <danielj@mellanox.com> wrote=
:=0A=
>> From: Daniel Jurgens <danielj@mellanox.com>=0A=
>>=0A=
>> Infiniband applications access HW from user-space -- traffic is generate=
d=0A=
>> directly by HW, bypassing the kernel. Consequently, Infiniband Partition=
s,=0A=
>> which are associated directly with HW transport endpoints, are a natural=
=0A=
>> choice for enforcing granular mandatory access control for Infiniband. Q=
Ps may=0A=
>> only send or receives packets tagged with the corresponding partition ke=
y=0A=
>> (PKey). The PKey is not a cryptographic key; it's a 16 bit number identi=
fying=0A=
>> the partition.=0A=
>>=0A=
>> Every Infiniband fabric is controlled by a central Subnet Manager (SM). =
The SM=0A=
>> provisions the partitions by assigning each port with the partitions it =
can=0A=
>> access. In addition, the SM tags each port with a subnet prefix, which=
=0A=
>> identifies the subnet. Determining which users are allowed to access whi=
ch=0A=
>> partition keys on a given subnet forms an effective policy for isolating=
 users=0A=
>> on the fabric. Any application that attempts to send traffic on a given =
subnet=0A=
>> is automatically subject to the policy, regardless of which device and p=
ort it=0A=
>> uses. SM software configures the subnet through a privileged Subnet Mana=
gement=0A=
>> Interface (SMI), which is presented by each Infiniband port. Thus, the S=
MI must=0A=
>> also be controlled to prevent unauthorized changes to fabric configurati=
on and=0A=
>> partitioning.=0A=
>>=0A=
>> To support access control for IB partitions and subnet management, secur=
ity=0A=
>> contexts must be provided for two new types of objects - PKeys and IB po=
rts.=0A=
>>=0A=
>> A PKey label consists of a subnet prefix and a range of PKey values and =
is=0A=
>> similar to the labeling mechanism for netports. Each Infiniband port can=
 reside=0A=
>> on a different subnet. So labeling the PKey values for specific subnet p=
refixes=0A=
>> provides the user maximum flexibility, as PKey values may be determined=
=0A=
>> independently for different subnets. There is a single access vector for=
 PKeys=0A=
>> called "access".=0A=
>>=0A=
>> An Infiniband port is labeled by device name and port number. There is a=
 single=0A=
>> access vector for IB ports called "manage_subnet".=0A=
>>=0A=
>> Because RDMA allows kernel bypass, enforcement must be done during conne=
ction=0A=
>> setup. Communication over RDMA requires a send and receive queue, collec=
tively=0A=
>> known as a Queue Pair (QP). A QP must be initialized by privileged syste=
m calls=0A=
>> before it can be used to send or receive data. During initialization the=
 user=0A=
>> must provide the PKey and port the QP will use; at this time access cont=
rol can=0A=
>> be enforced.=0A=
>>=0A=
>> Because there is a possibility that the enforcement settings or security=
=0A=
>> policy can change, a means of notifying the ib_core module of such chang=
es=0A=
>> is required. To facilitate this a generic notification callback mechanis=
m=0A=
>> is added to the LSM. One callback is registered for checking the QP PKey=
=0A=
>> associations when the policy changes. Mad agents also register a callbac=
k,=0A=
>> they cache the permission to send and receive SMPs to avoid another per=
=0A=
>> packet call to the LSM.=0A=
>>=0A=
>> Because frequent accesses to the same PKey's SID is expected a cache is=
=0A=
>> implemented which is very similar to the netport cache.=0A=
>>=0A=
>> In order to properly enforce security when changes to the PKey table or=
=0A=
>> security policy or enforcement occur ib_core must track which QPs are=0A=
>> using which port, pkey index, and alternate path for every IB device.=0A=
>> This makes operations that used to be atomic transactional.=0A=
>>=0A=
>> When modifying a QP, ib_core must associate it with the PKey index, port=
,=0A=
>> and alternate path specified. If the QP was already associated with=0A=
>> different settings, the QP is added to the new list prior to the=0A=
>> modification. If the modify succeeds then the old listing is removed. If=
=0A=
>> the modify fails the new listing is removed and the old listing remains=
=0A=
>> unchanged.=0A=
>>=0A=
>> When destroying a QP the ib_qp structure is freed by the decive specific=
=0A=
>> driver (i.e. mlx4_ib) if the 'destroy' is successful. This requires stor=
ing=0A=
>> security related information in a separate structure. When a 'destroy'=
=0A=
>> request is in process the ib_qp structure is in an undefined state so if=
=0A=
>> there are changes to the security policy or PKey table, the security che=
cks=0A=
>> cannot reset the QP if it doesn't have permission for the new setting. I=
f=0A=
>> the 'destroy' fails, security for that QP must be enforced again and its=
=0A=
>> status in the list is restored. If the 'destroy' succeeds the security i=
nfo=0A=
>> can be cleaned up and freed.=0A=
>>=0A=
>> There are a number of locks required to protect the QP security structur=
e=0A=
>> and the QP to device/port/pkey index lists. If multiple locks are requir=
ed,=0A=
>> the safe locking order is: QP security structure mutex first, followed b=
y=0A=
>> any list locks needed, which are sorted first by port followed by pkey=
=0A=
>> index.=0A=
> Hi Dan,=0A=
>=0A=
> I haven't heard anything from you in a while, where do things stand=0A=
> with this effort?  Unless I missed them, I believe we are still=0A=
> waiting on the userspace, SELinux reference policy, and=0A=
> selinux-testsuite patches.=0A=
>=0A=
Hi Paul,=0A=
=0A=
    I got distracted for a while.  I've just rebased the kernel and userspa=
ce.  I'll do some testing and submit the userspace code in the next couple =
days.  I still have to write the selinux-testsuite tests, I'll work on thos=
e concurrently with the userspace review cycle.=0A=
=0A=
