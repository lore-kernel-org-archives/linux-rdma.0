From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Thu, 4 May 2017 11:51:37 -0400
Message-ID: <CAHC9VhRE+bkPAnFgqOOQQQZwA8U0tSWHdeM5+LiadXfN63kS=g@mail.gmail.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhSB6AORJf_8cBGt-AynMsEh3snKU5SpsmNXoy9hDSrGaA@mail.gmail.com> <VI1PR05MB167880A4D79F8FC3F8C740A9C4160@VI1PR05MB1678.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <VI1PR05MB167880A4D79F8FC3F8C740A9C4160@VI1PR05MB1678.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 3, 2017 at 3:45 PM, Daniel Jurgens <danielj@mellanox.com> wrote=
:
> On 5/3/2017 9:41 AM, Paul Moore wrote:
>> On Wed, Nov 23, 2016 at 9:17 AM, Dan Jurgens <danielj@mellanox.com> wrot=
e:
>>> From: Daniel Jurgens <danielj@mellanox.com>
>>>
>>> Infiniband applications access HW from user-space -- traffic is generat=
ed
>>> directly by HW, bypassing the kernel. Consequently, Infiniband Partitio=
ns,
>>> which are associated directly with HW transport endpoints, are a natura=
l
>>> choice for enforcing granular mandatory access control for Infiniband. =
QPs may
>>> only send or receives packets tagged with the corresponding partition k=
ey
>>> (PKey). The PKey is not a cryptographic key; it's a 16 bit number ident=
ifying
>>> the partition ...
>>>
>> Hi Dan,
>>
>> I haven't heard anything from you in a while, where do things stand
>> with this effort?  Unless I missed them, I believe we are still
>> waiting on the userspace, SELinux reference policy, and
>> selinux-testsuite patches.
>>
> Hi Paul,
>
>     I got distracted for a while.  I've just rebased the kernel and users=
pace.  I'll do some testing and submit the userspace code in the next coupl=
e days.  I still have to write the selinux-testsuite tests, I'll work on th=
ose concurrently with the userspace review cycle.

Great, thanks for the update.  We'll look forward to the patches.

--=20
paul moore
www.paul-moore.com
