From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v7 4/9] IB/core: Enforce security on management datagrams
Date: Fri, 19 May 2017 15:21:40 -0400
Message-ID: <CAHC9VhSqarh9TepvumkQxcS51bvtm_bH+gWpSeiR-XG83JbT-w@mail.gmail.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <1495198139-69993-5-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-5-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Fri, May 19, 2017 at 8:48 AM, Dan Jurgens <danielj@mellanox.com> wrote:
> From: Daniel Jurgens <danielj@mellanox.com>
>
> Allocate and free a security context when creating and destroying a MAD
> agent.  This context is used for controlling access to PKeys and sending
> and receiving SMPs.
>
> When sending or receiving a MAD check that the agent has permission to
> access the PKey for the Subnet Prefix of the port.
>
> During MAD and snoop agent registration for SMI QPs check that the
> calling process has permission to access the manage the subnet  and
> register a callback with the LSM to be notified of policy changes. When
> notificaiton of a policy change occurs recheck permission and set a flag
> indicating sending and receiving SMPs is allowed.
>
> When sending and receiving MADs check that the agent has access to the
> SMI if it's on an SMI QP.  Because security policy can change it's
> possible permission was allowed when creating the agent, but no longer
> is.
>
> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
>
> ---
> v2:
> - Squashed LSM hook additions. Paul Moore
> - Changed security blobs to void*. Paul Moore
> - Shorten end_port to port. Paul Moore
> - Change "smp" to "manage_subnet". Paul Moore
> - Use the LSM policy change notification and a flag to track permission
>   instead of calling the LSM hook for every SMP. Dan Jurgens
> - Squashed PKey and SMP enforcement into the same patch and moved the
>   logic into security.c. Dan Jurgens
>
> v3:
> - ib_port -> ib_endport. Paul Moore
> - Use notifier chains for LSM notification. Paul Moore
> - Reorder LSM hook parameters to put sec first. Paul Moore
>
>  drivers/infiniband/core/core_priv.h | 35 ++++++++++++++
>  drivers/infiniband/core/mad.c       | 52 +++++++++++++++++----
>  drivers/infiniband/core/security.c  | 92 +++++++++++++++++++++++++++++++++++++
>  include/linux/lsm_hooks.h           |  8 ++++
>  include/linux/security.h            |  6 +++
>  include/rdma/ib_mad.h               |  4 ++
>  security/security.c                 |  8 ++++
>  7 files changed, 197 insertions(+), 8 deletions(-)

...

> diff --git a/security/security.c b/security/security.c
> index 6eef315..b69fe6f 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1540,6 +1540,12 @@ int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey)
>  }
>  EXPORT_SYMBOL(security_ib_pkey_access);
>
> +int security_ib_endport_manage_subnet(void *sec, const char *dev_name, u8 port_num)
> +{
> +       return call_int_hook(ib_endport_manage_subnet, 0, sec, dev_name, port_num);
> +}
> +EXPORT_SYMBOL(security_ib_endport_manage_subnet);
> +
>  int security_ib_alloc_security(void **sec)
>  {
>         return call_int_hook(ib_alloc_security, 0, sec);
> @@ -2014,6 +2020,8 @@ struct security_hook_heads security_hook_heads __lsm_ro_after_init = {
>
>  #ifdef CONFIG_SECURITY_INFINIBAND
>         .ib_pkey_access = LIST_HEAD_INIT(security_hook_heads.ib_pkey_access),
> +       .ib_endport_manage_subnet =
> +               LIST_HEAD_INIT(security_hook_heads.ib_endport_manage_subnet),
>         .ib_alloc_security =
>                 LIST_HEAD_INIT(security_hook_heads.ib_alloc_security),
>         .ib_free_security =

The same problem as 2/9 regarding the LSM hook code.  I'll also drop
this block, but update your patch in case you need to respin.

-- 
paul moore
www.paul-moore.com
