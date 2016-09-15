From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 0/2] RoCE V2 support for UD traffic
Date: Thu, 15 Sep 2016 15:51:15 +0300
Message-ID: <1473943877-6049-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Sending V2 to align the map file with the GCC syntax, details below.
No other changes from V1.

This patch-set from Noa enables user application to work
properly with RoCE V2 when UD traffic is used.
The series was tested successfully with mlx5 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git branch: rocev2_v2

It's sent over your master branch, to take it on top of RSS series
you can take it from the 'for-upstream' branch in above GIT.
(solves a conflict in src/libibverbs.map)

No change is required in the application side, all is done transparently
to the application.

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

Changes from V1:
patch #1: Align the map file around IBVERBS_1.3 to match the GCC syntax as described in below wiki:
          https://gcc.gnu.org/wiki/SymbolVersioning.

Changes from V0:
patch #1: Use IBVERBS_1.3 as the symbol label.

Noa Osherovich (2):
  Add ibv_query_gid_type to support RoCE v2 UD traffic
  Add support for UD traffic on RoCE v2

 include/infiniband/driver.h |   7 ++
 src/libibverbs.map          |   5 +
 src/verbs.c                 | 243 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 236 insertions(+), 19 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
