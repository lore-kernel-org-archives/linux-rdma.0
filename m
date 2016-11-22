From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v5 2/9] IB/core: Enforce PKey security on QPs
Date: Wed, 23 Nov 2016 09:26:02 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1611230923240.3895@namei.org>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com> <1479843638-67136-3-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1479843638-67136-3-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Nov 2016, Dan Jurgens wrote:

> From: Daniel Jurgens <danielj@mellanox.com>
> 
> Add new LSM hooks to allocate and free security contexts and check for
> permission to access a PKey.

I guess Doug's is best tree for these patches?

> ---
> v2:
> - Squashed LSM hook additions. Paul Moore
> - Changed security blobs to void*. Paul Moore
> 
> v3:
> - Change parameter order of pkey_access hook. Paul Moore
> ---
>  drivers/infiniband/core/Makefile     |   3 +-
>  drivers/infiniband/core/cache.c      |  21 +-
>  drivers/infiniband/core/core_priv.h  |  77 +++++
>  drivers/infiniband/core/device.c     |  33 ++
>  drivers/infiniband/core/security.c   | 617 +++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/uverbs_cmd.c |  20 +-
>  drivers/infiniband/core/verbs.c      |  27 +-
>  include/linux/lsm_hooks.h            |  27 ++
>  include/linux/security.h             |  21 ++
>  include/rdma/ib_verbs.h              |  48 +++
>  security/Kconfig                     |   9 +
>  security/security.c                  |  31 ++
>  12 files changed, 925 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/infiniband/core/security.c


Acked-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<jmorris@namei.org>

