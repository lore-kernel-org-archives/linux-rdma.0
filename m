From: Paul Moore <pmoore@redhat.com>
Subject: Re: [PATCH 01/12] security: Add LSM hooks for Infiniband security
Date: Thu, 30 Jun 2016 17:27:12 -0400
Message-ID: <CAGH-Kgv_2AoKvXVG1BCVehnETw2bGS8nxyj4PGqCJSXy1hGJUg@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-2-git-send-email-danielj@mellanox.com> <CAGH-KgtVpX-y+r+pA0_0Hg-Yqx6YWpuc6ud-rk_pHQCtOEFGag@mail.gmail.com>
 <AM4PR0501MB2257D88B4440B8992081B521C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <AM4PR0501MB2257D88B4440B8992081B521C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 5:09 PM, Daniel Jurgens <danielj@mellanox.com> wrote:
> On 6/30/2016 3:28 PM, Paul Moore wrote:
>> On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj@mellanox.com> wrote:
>>> From: Daniel Jurgens <danielj@mellanox.com>
>>>
>>> Add nine new hooks
>>>  1. Allocate security contexts for Infiniband QPs.
>>>  2. Free security contexts for Infiniband QPs.
>>>  3. Allocate security contexts for Infiniband MAD agents.
>>>  4. Free security contexts for Infiniband MAD agents.
>>>  5. Enforce QP access to Pkeys
>>>  6. Enforce MAD agent access to Pkeys
>>>  7. Enforce MAD agent access to Infiniband End Ports for sending Subnet
>>>     Management Packets (SMP)
>>>  8. A hook to register a callback to receive notifications of
>>>     security policy or enforcement changes.  Restricting a QPs access to
>>>     a pkey will be done during setup and not on a per packet basis
>>>     access must be enforced again.
>>>  9. A hook to unregister the callback.
>>>
>>> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
>>> Reviewed-by: Eli Cohen <eli@mellanox.com>
>>> ---
>>>  include/linux/lsm_hooks.h | 71 ++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/security.h  | 63 +++++++++++++++++++++++++++++++++++
>>>  include/rdma/ib_verbs.h   |  4 +++
>>>  security/Kconfig          |  9 +++++
>>>  security/security.c       | 83 +++++++++++++++++++++++++++++++++++++++++++++++
>>>  5 files changed, 230 insertions(+)
>> I'd recommend putting the IB hook calls into this patch as well, it
>> helps make the hooks a bit more concrete as you can see where, and how
>> they are called.
>
> Do you mean add them with SELinux hook implementations?  Or with the the IB/Core code where they are called?

I mean the IB changes.  That way a single patch has both the hook
declarations and their calling locations; it helps make the hooks a
bit less abstract.

The SELinux hook implementations should be kept separate.

> I tried as best as I could to avoid mingling LSM, IB/Core, and SELinux changes.  Hoping to minimize the burden of a single patch needing acceptance from multiple maintainers and synchronization problems that could create.  I could split this up and add the hooks where they are actually used if you don't think that's problem though.

Ultimately the entire patchset needs to get acceptance from the IB and
SELinux folks, with no objections from any of the other LSM
maintainers.  My guess is, I'll probably be the one who ends up
merging this as it's more SELinux than anything else, but I'll want a
thumbs-up/ACK from the IB folks before I do that.

-- 
paul moore
security @ redhat
