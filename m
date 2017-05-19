From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v7 0/9] SELinux support for Infiniband RDMA
Date: Fri, 19 May 2017 15:35:11 -0400
Message-ID: <CAHC9VhQtw4fFrCdKcznHrLDkAJVDhi=y9dYMxtOP23XVKq+rCw@mail.gmail.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <VI1PR05MB1678F822760B7C5F8E263573C4E50@VI1PR05MB1678.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <VI1PR05MB1678F822760B7C5F8E263573C4E50@VI1PR05MB1678.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 19, 2017 at 12:47 PM, Daniel Jurgens <danielj@mellanox.com> wrote:
> On 5/19/2017 7:49 AM, Dan Jurgens wrote:
>> From: Daniel Jurgens <danielj@mellanox.com>
>>
>> Note on v7, it applies cleanly on Paul Moores' tree.  'git am' fails to
>> apply patch 0002* to Dougs' tree, but 'patch' applies it without rejects.
>> There's a new file that needs to be added before resolving the git am,
>> drivers/infiniband/core/security.c
>
> There's actually a trivial merge conflict in drivers/infiniband/core/uverbs.c that doesn't cause patch to create a reject file, in the function create_qp a my patch adds a "goto err_destroy;".  In Dougs' tree it needs to be changed to "goto err_cb".

Thanks for the rebase Daniel.  Aside from the small problems with LSM
hook init code that I already mentioned it looks good to me.

Considering that we got an ACK from the IB folks on v6 of your
patchset I went ahead and merged it into the selinux/next tree.  I do
reserve the right to yank it out before the next merge window if we
discover any problems with the userspace, policy, or tests, but I
think those are moving along nicely at the moment.

Doug, and other IB folks, can I get an explicit ACK on this rebased
patchset from Daniel?  I don't like sending cross-subsystem changes
this large upstream without the associated ACKs.

-- 
paul moore
www.paul-moore.com
