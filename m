From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libmlx5 V1 0/2] Add cross-channel support
Date: Sat, 16 Jan 2016 17:55:56 +0200
Message-ID: <1452959758-29611-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patchset adds libmlx5 part of cross-channel support [1].

These patches were added on top of "Completion timestamping" [2].

[1] http://comments.gmane.org/gmane.linux.drivers.rdma/31715
[2] http://www.spinics.net/lists/linux-rdma/msg30940.html

Changes from v0:
  * Enrich cover message and commit messages.
  * Add mlx5_post_send() implementation related to cross-channel
    work request opcodes.

Leon Romanovsky (2):
  Add CQ ignore overrun creation flag
  Add cross-channel work request opcodes

 src/mlx5-abi.h |  14 ++++++++
 src/mlx5.h     |   9 ++++++
 src/qp.c       | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 src/verbs.c    |  71 +++++++++++++++++++++++++++++++---------
 src/wqe.h      |   5 +++
 5 files changed, 178 insertions(+), 21 deletions(-)

-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
