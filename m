From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v8 2/9] IB/core: Enforce PKey security on QPs
Date: Tue, 23 May 2017 12:34:20 -0400
Message-ID: <CAHC9VhTvPrsu4c_cY2HFW4DcktrPJUO_t0Ur-Ve2MidqCe8m-g@mail.gmail.com>
References: <1495537022-111952-1-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495537022-111952-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Dan Jurgens <danielj@mellanox.com>
Cc: dledford@redhat.com, James Morris <jmorris@namei.org>, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Tue, May 23, 2017 at 6:57 AM, Dan Jurgens <danielj@mellanox.com> wrote:
> From: Daniel Jurgens <danielj@mellanox.com>
>
> Add new LSM hooks to allocate and free security contexts and check for
> permission to access a PKey.
>
> Allocate and free a security context when creating and destroying a QP.
> This context is used for controlling access to PKeys.
>
> When a request is made to modify a QP that changes the port, PKey index,
> or alternate path, check that the QP has permission for the PKey in the
> PKey table index on the subnet prefix of the port. If the QP is shared
> make sure all handles to the QP also have access.
>
> Store which port and PKey index a QP is using. After the reset to init
> transition the user can modify the port, PKey index and alternate path
> independently. So port and PKey settings changes can be a merge of the
> previous settings and the new ones.
>
> In order to maintain access control if there are PKey table or subnet
> prefix change keep a list of all QPs are using each PKey index on
> each port. If a change occurs all QPs using that device and port must
> have access enforced for the new cache settings.
>
> These changes add a transaction to the QP modify process. Association
> with the old port and PKey index must be maintained if the modify fails,
> and must be removed if it succeeds. Association with the new port and
> PKey index must be established prior to the modify and removed if the
> modify fails.
>
> 1. When a QP is modified to a particular Port, PKey index or alternate
>    path insert that QP into the appropriate lists.
>
> 2. Check permission to access the new settings.
>
> 3. If step 2 grants access attempt to modify the QP.
>
> 4a. If steps 2 and 3 succeed remove any prior associations.
>
> 4b. If ether fails remove the new setting associations.
>
> If a PKey table or subnet prefix changes walk the list of QPs and
> check that they have permission. If not send the QP to the error state
> and raise a fatal error event. If it's a shared QP make sure all the
> QPs that share the real_qp have permission as well. If the QP that
> owns a security structure is denied access the security structure is
> marked as such and the QP is added to an error_list. Once the moving
> the QP to error is complete the security structure mark is cleared.
>
> Maintaining the lists correctly turns QP destroy into a transaction.
> The hardware driver for the device frees the ib_qp structure, so while
> the destroy is in progress the ib_qp pointer in the ib_qp_security
> struct is undefined. When the destroy process begins the ib_qp_security
> structure is marked as destroying. This prevents any action from being
> taken on the QP pointer. After the QP is destroyed successfully it
> could still listed on an error_list wait for it to be processed by that
> flow before cleaning up the structure.
>
> If the destroy fails the QPs port and PKey settings are reinserted into
> the appropriate lists, the destroying flag is cleared, and access control
> is enforced, in case there were any cache changes during the destroy
> flow.
>
> To keep the security changes isolated a new file is used to hold security
> related functionality.
>
> Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
>
> ---
>
> v2:
> - Squashed LSM hook additions. Paul Moore
> - Changed security blobs to void*. Paul Moore
>
> v3:
> - Change parameter order of pkey_access hook. Paul Moore
>
> v7:
> - Exclude IB_QPT_RESERVED* types from enforcement, they are special like
>   SMI and GSI.
> - Use kcalloc vs kzalloc for port_pkey_list allocation. Parav Pandit
>
> v8:
> - Remove LSM security hook initialization merge mistake. Paul Moore
> - Cleanup unneccesary gotos in drivers/infiniband/core/security.c. James
> Morris
> ---
>  drivers/infiniband/core/Makefile     |   3 +-
>  drivers/infiniband/core/cache.c      |  21 +-
>  drivers/infiniband/core/core_priv.h  |  77 +++++
>  drivers/infiniband/core/device.c     |  33 ++
>  drivers/infiniband/core/security.c   | 613 +++++++++++++++++++++++++++++++++++
>  drivers/infiniband/core/uverbs_cmd.c |  15 +-
>  drivers/infiniband/core/verbs.c      |  27 +-
>  include/linux/lsm_hooks.h            |  27 ++
>  include/linux/security.h             |  21 ++
>  include/rdma/ib_verbs.h              |  48 +++
>  security/Kconfig                     |   9 +
>  security/security.c                  |  22 ++
>  12 files changed, 907 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/infiniband/core/security.c

Replaced the existing 2/9 patch with this one, thanks.

I've also rebased selinux/next on top of the latest
linux-security/next branch which is based on 4.12-rc2 and should
resolve the problems that were found by the linux-next folks.

-- 
paul moore
www.paul-moore.com
