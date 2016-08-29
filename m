From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Mon, 29 Aug 2016 17:40:35 -0400
Message-ID: <CAHC9VhS1Tg3qr2Nncd_eq_eUXrf-wMickoeoF978Q7L+gN7J1g@mail.gmail.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 29, 2016 at 9:53 AM, Dan Jurgens <danielj@mellanox.com> wrote:
> From: Daniel Jurgens <danielj@mellanox.com>

...

> Daniel Jurgens (9):
>   IB/core: IB cache enhancements to support Infiniband security
>   IB/core: Enforce PKey security on QPs
>   selinux lsm IB/core: Implement LSM notification system
>   IB/core: Enforce security on management datagrams
>   selinux: Create policydb version for Infiniband support
>   selinux: Allocate and free infiniband security hooks
>   selinux: Implement Infiniband PKey "Access" access vector
>   selinux: Add IB Port SMP access vector
>   selinux: Add a cache for quicker retreival of PKey SIDs

Hi Daniel,

My apologies for such a long delay in responding to this latest
patchset; conferences, travel, and vacation have made for a very busy
August.  After you posted the v2 patchset we had an off-list
discussion regarding testing the SELinux/IB integration; unfortunately
we realized that IB hardware would be needed to test this (no IB
loopback device), but we agreed that having tests would be beneficial.

Have you done any work yet towards adding SELinux/IB tests to the
selinux-testsuite project?

* https://github.com/SELinuxProject/selinux-testsuite

-- 
paul moore
www.paul-moore.com
