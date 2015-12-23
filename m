From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V3 00/11] Add RoCE v2 support
Date: Wed, 23 Dec 2015 15:25:22 +0200
Message-ID: <CAAKD3BC1Qj0CeUe0HM24DDXaHqGPP2XB=HvW42ycz06mVhsAgQ@mail.gmail.com>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450875417-19262-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 2:56 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi Doug,
>
> This series adds the support for RoCE v2. In order to support RoCE v2,
> we add gid_type attribute to every GID. When the RoCE GID management
> populates the GID table, it duplicates each GID with all supported types.
> This gives the user the ability to communicate over each supported
> type.
>
> Patch 0001, 0002 and 0003 add support for multiple GID types to the
> cache and related APIs. The third patch exposes the GID attributes
> information is sysfs.
>
> Patch 0004 adds the RoCE v2 GID type and the capabilities required
> from the vendor in order to implement RoCE v2. These capabilities
> are grouped together as RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP.
>
> RoCE v2 could work at IPv4 and IPv6 networks. When receiving ib_wc, this
> information should come from the vendor's driver. In case the vendor
> doesn't supply this information, we parse the packet headers and resolve
> its network type. Patch 0005 adds this information and required utilities.
>
> Patches 0006 and 0007 adds route validation. This is mandatory to ensure
> that we send packets using GIDS which corresponds to a net-device that
> can be routed to the destination.
>
> Patches 0008 and 0009 add configfs support (and the required
> infrastructure) for CMA. The administrator should be able to set the
> default RoCE type. This is done through a new per-port
> default_roce_mode configfs file.
>
> Patch 0010 formats a QP1 packet in order to support RoCE v2 CM
> packets. This is required for vendors which implement their
> QP1 as a Raw QP.
>
> Patch 0011 adds support for IPv4 multicast as an IPv4 network
> requires IGMP to be sent in order to join multicast groups.
>
> Vendors code aren't part of this patch-set. Soft-Roce will be
> sent soon and depends on these patches. Other vendors, like
> mlx4, ocrdma and mlx5 will follow.
>
> This patch is applied on the "Change per-entry locks in GID cache to
> table lock" series which was sent to the mailing list.
>
> Thanks,
> Matan
>
> Changes from V2:
>  - Rebase over Doug's k.o/for-4.5
>  - Make INFINIBAND_ADDR_TRANS_CONFIGFS depends on CONFIGFS
>
> Changes from V1:
>  - Rebased against Linux 4.4-rc2 master branch.
>  - Add route validation
>  - ConfigFS - avoid compiling INFINIBAND=y and CONFIGFS_FS=m
>  - Add documentation for configfs and sysfs ABI
>  - Remove ifindex and gid_type from mcmember
>
> Changes from V0:
>  - Rebased patches against Doug's latest k.o/for-4.4 tree.
>  - Fixed a bug in configfs (rmdir caused an incorrect free).
>
> Matan Barak (8):
>   IB/core: Add gid_type to gid attribute
>   IB/cm: Use the source GID index type
>   IB/core: Add gid attributes to sysfs
>   IB/core: Add ROCE_UDP_ENCAP (RoCE V2) type
>   IB/core: Move rdma_is_upper_dev_rcu to header file
>   IB/core: Validate route in ib_init_ah_from_wc and
>     ib_init_ah_from_path
>   IB/rdma_cm: Add wrapper for cma reference count
>   IB/cma: Add configfs for rdma_cm
>
> Moni Shoua (2):
>   IB/core: Initialize UD header structure with IP and UDP headers
>   IB/cma: Join and leave multicast groups with IGMP
>
> Somnath Kotur (1):
>   IB/core: Add rdma_network_type to wc
>
>  Documentation/ABI/testing/configfs-rdma_cm       |   22 ++
>  Documentation/ABI/testing/sysfs-class-infiniband |   16 +
>  drivers/infiniband/Kconfig                       |    9 +
>  drivers/infiniband/core/Makefile                 |    2 +
>  drivers/infiniband/core/addr.c                   |  185 +++++++++----
>  drivers/infiniband/core/cache.c                  |  169 ++++++++---
>  drivers/infiniband/core/cm.c                     |   31 ++-
>  drivers/infiniband/core/cma.c                    |  259 ++++++++++++++++--
>  drivers/infiniband/core/cma_configfs.c           |  322 ++++++++++++++++++++++
>  drivers/infiniband/core/core_priv.h              |   45 +++
>  drivers/infiniband/core/device.c                 |    9 +-
>  drivers/infiniband/core/multicast.c              |   17 +-
>  drivers/infiniband/core/roce_gid_mgmt.c          |   81 ++++--
>  drivers/infiniband/core/sa_query.c               |   76 +++++-
>  drivers/infiniband/core/sysfs.c                  |  184 ++++++++++++-
>  drivers/infiniband/core/ud_header.c              |  155 ++++++++++-
>  drivers/infiniband/core/uverbs_marshall.c        |    1 +
>  drivers/infiniband/core/verbs.c                  |  170 ++++++++++--
>  drivers/infiniband/hw/mlx4/qp.c                  |    7 +-
>  drivers/infiniband/hw/mthca/mthca_qp.c           |    2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c         |    2 +-
>  include/rdma/ib_addr.h                           |   11 +-
>  include/rdma/ib_cache.h                          |    4 +
>  include/rdma/ib_pack.h                           |   45 +++-
>  include/rdma/ib_sa.h                             |    3 +
>  include/rdma/ib_verbs.h                          |   78 +++++-
>  26 files changed, 1703 insertions(+), 202 deletions(-)
>  create mode 100644 Documentation/ABI/testing/configfs-rdma_cm
>  create mode 100644 Documentation/ABI/testing/sysfs-class-infiniband
>  create mode 100644 drivers/infiniband/core/cma_configfs.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

If you've merged the previous version (v2), please add the following fixups:

commit 72bc2f5b46a4d0c194b66f6f90ce4a879363983d
Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Dec 14 14:24:14 2015 +0200

    fixup! IB/cma: Add configfs for rdma_cm

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index f5312da..018685f 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -56,7 +56,7 @@ config INFINIBAND_ADDR_TRANS

 config INFINIBAND_ADDR_TRANS_CONFIGFS
        bool
-       depends on INFINIBAND_ADDR_TRANS && !(INFINIBAND=y && CONFIGFS_FS=m)
+       depends on INFINIBAND_ADDR_TRANS && CONFIGFS_FS &&
!(INFINIBAND=y && CONFIGFS_FS=m)
        default y
        ---help---
          ConfigFS support for RDMA communication manager (CM).


Author: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Dec 10 19:34:32 2015 +0200

    fixup! IB/core: Validate route in ib_init_ah_from_wc and
ib_init_ah_from_path

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 57eda11..0b5f245 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -326,7 +326,7 @@ static int addr_resolve_neigh(struct dst_entry *dst,
                return ret;
        }

-       /* If the device does ARP internally */
+       /* If the device doesn't do ARP internally */
        if (!(dst->dev->flags & IFF_NOARP)) {
                const struct sockaddr_in *dst_in4 =
                        (const struct sockaddr_in *)dst_in;
@@ -494,7 +494,7 @@ int rdma_resolve_ip_route(struct sockaddr *src_addr,
                          const struct sockaddr *dst_addr,
                          struct rdma_dev_addr *addr)
 {
-       struct sockaddr_storage ssrc_addr;
+       struct sockaddr_storage ssrc_addr = {};
        struct sockaddr *src_in = (struct sockaddr *)&ssrc_addr;

        if (src_addr->sa_family != dst_addr->sa_family)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
