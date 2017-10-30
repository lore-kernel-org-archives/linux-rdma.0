From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/8] debugfs: per-file removal protection
Date: Tue, 31 Oct 2017 00:15:46 +0100
Message-ID: <20171030231554.6200-1-nicstange@gmail.com>
References: <CAOjnSCazvybpH5ZhHn=iTLm_dVGEdr=W1pUQv6zowRisB1MWTQ@mail.gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOjnSCazvybpH5ZhHn=iTLm_dVGEdr=W1pUQv6zowRisB1MWTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, "Paul E.McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tyler Hall <tylerwhall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

this is v3 of the per-file removal protection with the main change to v2
being that it's sent in non-RFC mode now.

For this, I dropped the questionable former [9/9] ("debugfs: free
debugfs_fsdata instances") for now. Perhaps I'll resend it later on
its own as a RFC again.

The problem this series attempts to address is that any indefinitely
blocking fops blocks _unrelated_ debugfs_remove()ers. This will be resolved
by introducing a per-file removal protection mechanism in place of the
former global debugfs_srcu shared among all debugfs files.

This problem has first been spotted and debugged by Johannes Berg [1]
and Tyler Hall is now facing the same issue again [2].

There's one patch to non-debugfs code,
[5/8] ("IB/hfi1: convert to debugfs_file_get() and -put()"),
which should be taken together with the rest of the series because
it depends on prior patches and later patches depend on it.

Applies to next-20171018.

I reviewed the patches once again and did an allmodconfig as well as an 
allnoconfig build. I did more thorough testing on v2, including whether
the removal protection still works.

Thanks,

Nicolai


Changes to v2:
  [9/9] ("debugfs: free debugfs_fsdata instances")
   - dropped for now.

Changes to v1:
  [2/9] ("debugfs: implement per-file removal protection")
  - In an attempt to resolve the issue reported by the kernel test robot
    for v1, restrict the "extended removal logic" to regular files in
    __debugfs_remove().

  [8/9] ("debugfs: defer debugfs_fsdata allocation to first usage")
  - Following review from Johannes Berg, replace the WARN_ON in
    debugfs_real_fops() by a WARN + 'return NULL'. The return NULL is
    expected to crash current soon and serves as an alternative for a
    BUG_ON here.
  - Mention the change in debugfs_real_fops() in the commit message.

  [9/9] ("debugfs: free debugfs_fsdata instances")
  - Following advice from Paul E. McKenney, make debugfs_file_get()
    release the RCU read section inbetween retry loop iterations.
  - Fix a race in debugfs_file_get()'s path handling a concurrent
    debugfs_file_put(): the former must not "help out resetting ->d_fsdata"
    because this can wipe out another debugfs_file_get()'s achievements.


[1] http://lkml.kernel.org/r/1490280886.2766.4.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org
[2] https://lkml.kernel.org/r/CAOjnSCYGprej+vEEsSXwr=wO+eWLe2d6sHQYTpp-DFpQ3pmguw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

Nicolai Stange (8):
  debugfs: add support for more elaborate ->d_fsdata
  debugfs: implement per-file removal protection
  debugfs: debugfs_real_fops(): drop __must_hold sparse annotation
  debugfs: convert to debugfs_file_get() and -put()
  IB/hfi1: convert to debugfs_file_get() and -put()
  debugfs: purge obsolete SRCU based removal protection
  debugfs: call debugfs_real_fops() only after debugfs_file_get()
  debugfs: defer debugfs_fsdata allocation to first usage

 drivers/infiniband/hw/hfi1/debugfs.c |  20 ++--
 fs/debugfs/file.c                    | 210 +++++++++++++++++++++--------------
 fs/debugfs/inode.c                   |  56 +++++++---
 fs/debugfs/internal.h                |  14 +++
 include/linux/debugfs.h              |  33 +-----
 lib/Kconfig.debug                    |   1 -
 6 files changed, 196 insertions(+), 138 deletions(-)

-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
