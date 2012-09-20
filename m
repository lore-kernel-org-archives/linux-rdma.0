From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 0/8] add raw packet QP, resource limitations, fixes/cleanups
Date: Thu, 20 Sep 2012 23:30:59 +0300
Message-ID: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

This batch of libmlx4 patch contains the patch to support raw
packet QP, two patches from Sagi that relate to resource 
limitations, and few simple fixes/cleanups from Dotan.

The first three were submitted pretty long while ago, for this 
re-submission I made some changes in the change-logs and cleaned
some checkpatch comments.

Or.

Dotan Barak (5):
  Replace sscanf() to strtol()
  Allow to use the whole BF buffer
  Use BlueFlame for RDMA_WRITE/WITH_IMM without data
  Change enumeration names for masked atomic opcodes
  When calling ibv_modify_qp() return right value

Or Gerlitz (1):
  Add raw packet QP support

Sagi Grimberg (2):
  Report correct QP/CQ related resource limits
  Limit qp resources accepted for ibv_create_qp()

 src/mlx4.c  |   17 +++++++++++++++--
 src/mlx4.h  |   21 +++++++++++++++++++--
 src/qp.c    |   14 +++++++++++---
 src/verbs.c |   24 +++++++++++++++++-------
 4 files changed, 62 insertions(+), 14 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
