From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Thu, 14 Apr 2016 08:41:35 -0700
Message-ID: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch series removes the write() interface for user access in favor of an
ioctl() based approach. This is in response to the complaint that we had
different handlers for write() and writev() doing different things and expecting
different types of data. See:

http://www.spinics.net/lists/linux-rdma/msg34451.html

In a response to that thread we mentioned some other possible approaches such
as using multiple files, or converting everything to writev(). However after
looking at things more it seemed a cleaner approach to use ioctl(). 

So each command that was being done through write() has been converted to
ioctl() and the write() interface is removed. We still use writev() for the data
path but control is done totally through ioctl().

The plan is to make the same sort of change in qib as well but we want to get
the opinion of the community on the approach first.

As part of this work I also decided to move the eprom functionality to its own
device (last patch) since it really is its own thing. It uses ioctl() as well,
again because it seems to be a more natural interface for this operation.

There is also a driver software version being exported via a sysfs file. This is
needed so that user space applications (psm) can  determine if it needs to do
ioctl() or write().

This patch applies on the latest hfi1 patch set "Fix link and other issues".

Patches can also be viewed on GitHub at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Dennis Dalessandro (7):
      IB/hfi1: Export drivers user sw version via sysfs
      IB/hfi1: Remove unused user command
      IB/hfi1: Add ioctl() interface for user commands
      IB/hfi1: Remove write(), use ioctl() for user cmds
      IB/hfi1: Add trace message in user IOCTL handling
      IB/hfi1: Consolidate IOCTL defines
      IB/hfi1: Move eprom to its own device


 drivers/staging/rdma/hfi1/common.h   |    3 
 drivers/staging/rdma/hfi1/diag.c     |  170 ++++++++++++++++++---------
 drivers/staging/rdma/hfi1/eprom.c    |  121 +------------------
 drivers/staging/rdma/hfi1/eprom.h    |   16 ++-
 drivers/staging/rdma/hfi1/file_ops.c |  213 ++++++++++++++--------------------
 drivers/staging/rdma/hfi1/hfi.h      |   22 +++-
 drivers/staging/rdma/hfi1/sysfs.c    |    8 +
 drivers/staging/rdma/hfi1/trace.c    |    1 
 drivers/staging/rdma/hfi1/trace.h    |    1 
 include/uapi/rdma/hfi/hfi1_user.h    |  106 ++++++++++++++++-
 10 files changed, 350 insertions(+), 311 deletions(-)

-- 
-Denny
