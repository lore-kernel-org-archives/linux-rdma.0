From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Mon, 29 Aug 2016 21:48:00 +0000
Message-ID: <VI1PR0501MB24297FF784A085DC0AAE2C1EC4E10@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhS1Tg3qr2Nncd_eq_eUXrf-wMickoeoF978Q7L+gN7J1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 8/29/2016 4:40 PM, Paul Moore wrote:=0A=
> On Fri, Jul 29, 2016 at 9:53 AM, Dan Jurgens <danielj@mellanox.com> wrote=
:=0A=
>> From: Daniel Jurgens <danielj@mellanox.com>=0A=
> ...=0A=
>=0A=
>> Daniel Jurgens (9):=0A=
>>   IB/core: IB cache enhancements to support Infiniband security=0A=
>>   IB/core: Enforce PKey security on QPs=0A=
>>   selinux lsm IB/core: Implement LSM notification system=0A=
>>   IB/core: Enforce security on management datagrams=0A=
>>   selinux: Create policydb version for Infiniband support=0A=
>>   selinux: Allocate and free infiniband security hooks=0A=
>>   selinux: Implement Infiniband PKey "Access" access vector=0A=
>>   selinux: Add IB Port SMP access vector=0A=
>>   selinux: Add a cache for quicker retreival of PKey SIDs=0A=
> Hi Daniel,=0A=
>=0A=
> My apologies for such a long delay in responding to this latest=0A=
> patchset; conferences, travel, and vacation have made for a very busy=0A=
> August.  After you posted the v2 patchset we had an off-list=0A=
> discussion regarding testing the SELinux/IB integration; unfortunately=0A=
> we realized that IB hardware would be needed to test this (no IB=0A=
> loopback device), but we agreed that having tests would be beneficial.=0A=
>=0A=
> Have you done any work yet towards adding SELinux/IB tests to the=0A=
> selinux-testsuite project?=0A=
>=0A=
> * https://github.com/SELinuxProject/selinux-testsuite=0A=
>=0A=
Hi Paul, I've not started doing that yet.  I've been waiting for feedback o=
f any kind from the RDMA list.  I thought the test updates would be more ap=
propriate around the time I'm submitting the changes to the user space util=
ities to allow labeling the new types.=0A=
=0A=
