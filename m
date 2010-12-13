From: Roland Dreier <rdreier@cisco.com>
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 13 Dec 2010 13:53:36 -0800
Message-ID: <ada4oahibkv.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Just a one thing here: a fix for a user-triggerable integer overflow
as a well as a leak of a few bytes of kernel memory.  The severity is
not too high here as actually hitting this requires a system with real
RDMA hardware, and the user must be granted direct access to that hardware.

Dan Carpenter (1):
      IB/uverbs: Handle large number of entries in poll CQ

 drivers/infiniband/core/uverbs_cmd.c |  101 +++++++++++++++++++---------------
 1 files changed, 57 insertions(+), 44 deletions(-)
