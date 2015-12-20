From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libmlx5 0/2] Add cross-channel support
Date: Sun, 20 Dec 2015 13:23:08 +0200
Message-ID: <1450610590-17361-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patchset adds libmlx5 part of cross-channel support.

These patches were added on top of "Completion timestamping" [2].

[1] http://thread.gmane.org/gmane.linux.drivers.rdma/31715
[2] http://www.spinics.net/lists/linux-rdma/msg30940.html

Leon Romanovsky (2):
  libmlx5: Add cross-channel primitives
  libmlx5: Add CQ ignore overrun creation flag

 src/mlx5-abi.h | 14 +++++++++++++
 src/mlx5.h     |  4 ++++
 src/verbs.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 66 insertions(+), 14 deletions(-)

-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
