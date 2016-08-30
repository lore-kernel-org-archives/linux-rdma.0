From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/2] RoCE V2 support for UD traffic
Date: Tue, 30 Aug 2016 19:51:43 +0300
Message-ID: <1472575905-25471-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch-set from Noa enables user application to work
properly with RoCE V2 when UD traffic is used.

The series was tested successfully with mlx5 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git branch: rocev2_v0

No change is required in the application side, all is done transparently
to the application.

Will send shortly some libmlx5 changes that are required to
work properly in its side.

Yishai

In General:
Currently, UD traffic is not supported over RoCE V2 in libibverbs,
since libibverbs can't differ between V1 and V2 GIDs and can't
select GID index properly.

This series contains two patches targeted to solve this:
- The first one introduces an internal helper function,
  ibv_query_gid_type, to be used by libibverbs and its vendors libs
  in order to select the correct GID index.
 
- The second patch changes init_ah_from_wc to use the first patch and
  set the GID index according to the RoCE version used.

Noa Osherovich (2):
  Add ibv_query_gid_type to support RoCE v2 UD traffic
  Add support for UD traffic on RoCE v2

 include/infiniband/driver.h |   7 ++
 src/libibverbs.map          |   2 +
 src/verbs.c                 | 243 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 233 insertions(+), 19 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
