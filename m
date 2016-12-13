From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Tue, 13 Dec 2016 17:17:49 -0500
Message-ID: <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <a56c4be8-f908-4774-dd1c-c6bbab5c1b03@tycho.nsa.gov> <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 13, 2016 at 11:25 AM, Daniel Jurgens <danielj@mellanox.com> wrote:
> On 12/13/2016 9:01 AM, Stephen Smalley wrote:
>> For the LSM/SELinux bits,
>> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
>>
>> Note that there will be a merge conflict on classmap.h due to commits in
>> the selinux next branch, but that should be easy to resolve.
>>
>> We'll need the patches for the selinux userspace and refpolicy.
>
> Thanks Stephen, I need to rebase the user space and do some patch breakup.  I'll start on that soon.

Sorry, I haven't had a chance to look at v6, but considering all our
discussions on the previous versions I don't expect any issues from
me.  I was hoping for some more generic hooks/controls, but that
doesn't look to be possible given the nature of RDMA.  I also want to
mention again the need for tests; we've talked about this in the past
and while it isn't possible to run the tests without IB hardware, I
would like to see us merge tests into the selinux-testsuite so that
those who do have the required h/w available could run the tests.

Assuming we can sort out the SELinux userspace and and tests by the
end of January, I see no reason why this couldn't go in for v4.11.

-- 
paul moore
www.paul-moore.com
