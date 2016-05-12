From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 12 May 2016 10:18:27 -0700
Message-ID: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
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

There is also a driver software version being exported via a sysfs file. This is
needed so that user space applications (psm) can  determine if it needs to do
ioctl() or write().

This patch series applies on Doug's k.o/for-4.7 branch.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.7

Changes since v1:
-----------------
* Dropped the last two patches in the series which created an eprom device and
consolidated ioctls.

* Handle conflict resolution, which removes the changes Jason did in
hfi1_file_write(), because it removes the function.

This does not add anything for compat_ioctl() as it is my understanding that
32 bit applications that attempt to call the ioctl() will just fail. Which is
the intended behavior. There is also a question of if we need to set 
kobj.parent [1], I'm not sure this is the case since the cdev in question lives
in /dev, not /dev/infiniband. If I'm incorrect in either of these aspects I can
spin another revision.

Other issues [1] raised by Jason are addressed in patches that follow this
series as they are comments on code which is not the subject of this patch
set.

[1] https://www.spinics.net/lists/linux-rdma/msg35319.html

---

Dennis Dalessandro (5):
      IB/hfi1: Export drivers user sw version via sysfs
      IB/hfi1: Remove unused user command
      IB/hfi1: Add ioctl() interface for user commands
      IB/hfi1: Remove write(), use ioctl() for user cmds
      IB/hfi1: Add trace message in user IOCTL handling


 drivers/staging/rdma/hfi1/common.h   |    6 +
 drivers/staging/rdma/hfi1/diag.c     |   13 --
 drivers/staging/rdma/hfi1/file_ops.c |  232 +++++++++++++++-------------------
 drivers/staging/rdma/hfi1/hfi.h      |   14 ++
 drivers/staging/rdma/hfi1/sysfs.c    |    8 +
 drivers/staging/rdma/hfi1/trace.c    |    1 
 drivers/staging/rdma/hfi1/trace.h    |    1 
 include/uapi/rdma/hfi/hfi1_user.h    |   51 +++++++
 8 files changed, 184 insertions(+), 142 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
