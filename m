From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/5] libbnxt_re: Critical bug fix series
Date: Fri, 12 May 2017 06:24:21 -0400
Message-ID: <1494584666-11064-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These are set of bug fix patches for the libbnxt_re user
space RDMA provider library. This patch series goes
hand-in-hand with recent bnxt_re kernel driver bug fixes.

Devesh Sharma (2):
  libbnxt_re: unmap DB page during uninit ucontext
  libbnxt_re: reset head and tail when moving to RST

Somnath Kotur (3):
  libbnxt_re: sq needs to be augmented by 128B
  libbnxt_re: fix wqe size for the 0-len posting
  libbnxt_re: move rts to rts after a threshold

 providers/bnxt_re/bnxt_re-abi.h |  2 +
 providers/bnxt_re/main.c        |  9 +++++
 providers/bnxt_re/main.h        |  3 ++
 providers/bnxt_re/memory.h      | 10 ++++-
 providers/bnxt_re/verbs.c       | 81 +++++++++++++++++++++++++++++++----------
 5 files changed, 84 insertions(+), 21 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
