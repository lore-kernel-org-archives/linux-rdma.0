From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 11 Apr 2012 13:07:22 -0700
Message-ID: <1334174842-13632-1-git-send-email-roland@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Fix regression in the /sys/class/infiniband/.../rate attribute -- old
kernels used to just return something, even if the underlying value was
out-of-bounds, while 3.4-rc1 returned EINVAL to userspace.  This breaks
some applications that check for the error, so go back to the old
behavior.

----------------------------------------------------------------
Or Gerlitz (1):
      IB/mlx4: Don't return an invalid speed when a port is down

Roland Dreier (1):
      IB/core: Don't return EINVAL from sysfs rate attribute for invalid speeds

 drivers/infiniband/core/sysfs.c   |    9 +++++----
 drivers/infiniband/hw/mlx4/main.c |    5 +++++
 2 files changed, 10 insertions(+), 4 deletions(-)
