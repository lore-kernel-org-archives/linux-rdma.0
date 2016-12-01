From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Optimize RoCE address handle creation for userspace
Date: Thu,  1 Dec 2016 16:25:51 +0200
Message-ID: <1480602353-8600-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Moni is the supplementary part of the kernel series that
was lastly sent upstream.

Creating a UD address handler when link layer is Ethernet requires resolving
the remote L3 address (GID) to a L2 address (MAC/VLAN).

Until now the way to resolve GID (which is the remote IP or a function of it)
to a MAC was with an interface supplied by libnl. The implementation of this
interface is heavy and fails on large load of requests to create an address
handle.

This series of patches enables user drivers that care for it to optimize the
resolution of L3 to L2 addresses with uverbs interface.

The series was tested successfully with CX4 in both kernel which doesn't have
this support and with a kernel which includes the above support.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/42

Yishai

Moni Shoua (2):
  ibverbs: Allow vendor data response in create_ah command
  mlx5: Create and destroy address handle with kernel assistance

 libibverbs/cmd.c                | 11 ++++++-----
 libibverbs/driver.h             |  4 +++-
 providers/hfi1verbs/verbs.c     |  4 +++-
 providers/ipathverbs/verbs.c    |  4 +++-
 providers/mlx5/mlx5-abi.h       |  7 +++++++
 providers/mlx5/mlx5.h           |  2 ++
 providers/mlx5/verbs.c          | 28 +++++++++++++++++++++++-----
 providers/ocrdma/ocrdma_verbs.c |  4 +++-
 providers/rxe/rxe.c             |  4 +++-
 9 files changed, 53 insertions(+), 15 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
