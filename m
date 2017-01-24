From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Tue, 24 Jan 2017 22:40:39 +0000
Message-ID: <VI1PR0501MB242933AC0EC458EAD2792560C4750@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <a56c4be8-f908-4774-dd1c-c6bbab5c1b03@tycho.nsa.gov>
 <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
 <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
 <1485294015.43764.91.camel@redhat.com> <1485294335.43764.94.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "eparis@parisplace.org" <eparis@parisplace.org>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>
List-Id: linux-rdma@vger.kernel.org

On 1/24/2017 3:45 PM, Doug Ledford wrote:=0A=
> On Tue, 2017-01-24 at 16:40 -0500, Doug Ledford wrote:=0A=
>> On Tue, 2016-12-13 at 17:17 -0500, Paul Moore wrote:=0A=
>>> On Tue, Dec 13, 2016 at 11:25 AM, Daniel Jurgens <danielj@mellanox.=0A=
>>> co=0A=
>>> m> wrote:=0A=
>>>>=0A=
>>>> On 12/13/2016 9:01 AM, Stephen Smalley wrote:=0A=
>>>>>=0A=
>>>>> For the LSM/SELinux bits,=0A=
>>>>> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>=0A=
>>>>>=0A=
>>>>> Note that there will be a merge conflict on classmap.h due to=0A=
>>>>> commits in=0A=
>>>>> the selinux next branch, but that should be easy to resolve.=0A=
>>>>>=0A=
>>>>> We'll need the patches for the selinux userspace and refpolicy.=0A=
>>>> Thanks Stephen, I need to rebase the user space and do some patch=0A=
>>>> breakup.  I'll start on that soon.=0A=
>>> Sorry, I haven't had a chance to look at v6, but considering all=0A=
>>> our=0A=
>>> discussions on the previous versions I don't expect any issues from=0A=
>>> me.  I was hoping for some more generic hooks/controls, but that=0A=
>>> doesn't look to be possible given the nature of RDMA.  I also want=0A=
>>> to=0A=
>>> mention again the need for tests; we've talked about this in the=0A=
>>> past=0A=
>>> and while it isn't possible to run the tests without IB hardware, I=0A=
>>> would like to see us merge tests into the selinux-testsuite so that=0A=
>>> those who do have the required h/w available could run the tests.=0A=
>>>=0A=
>>> Assuming we can sort out the SELinux userspace and and tests by the=0A=
>>> end of January, I see no reason why this couldn't go in for v4.11.=0A=
>> Daniel, can you work with people on the userspace and tests?  I'll=0A=
>> pull=0A=
>> this into a branch (I assume by Paul's and Stephen's comments that=0A=
>> they=0A=
>> expect it to go through my tree) ready to go, but hold actually=0A=
>> submitting it in the merge window until I've heard more from you all=0A=
>> that userspace is ready.=0A=
> Although it would also be helpful if you could rebase on a current tree=
=0A=
> (preferably my k.o/for-4.11 branch).=0A=
>=0A=
Doug, I'm working on the user space patches, hope to be ready to submit in =
the next 1-2 weeks.  Do you want me to rebase now or wait until those are s=
ubmitted?=0A=
=0A=
