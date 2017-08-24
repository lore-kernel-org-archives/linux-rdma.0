From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 24 Aug 2017 17:21:42 -0400
Message-ID: <1503609702.78641.61.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, I thought we were going to be done for this -rc cycle.  I should
have known better than to say so though.

We have 4 additional items that trickled in.

One was a simple mistake on my part.  I took a patch into my for-next
thinking that the issue was less severe than it was.  I was then
notified that it needed to be in my -rc area instead.  So, since I had
already pushed my for-next to k.o and there wasn't going to be a
rebase, I cherry-picked it to my rc area.  I kept the cherry-pick tag,
I don't know if that's how you prefer this be done.  In any case, when
I send you my pull request for the merge window, this one patch will
end up falling out.

The other three were just found late in testing.

Here's the boiler plate:

The following changes since commit
870201f95fcbd19538aef630393fe9d583eff82e:

  IB/uverbs: Fix NULL pointer dereference during device removal (2017-
08-16 12:53:15 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
ec2558796d25e6024071b6bcb8e11392538d57bf:

  IB/mlx5: Always return success for RoCE modify port (2017-08-24
15:33:33 -0400)

----------------------------------------------------------------
Fifth set of -rc fixes for 4.13 cycle

- One core fix accidentally applied first to for-next and then cherry
  picked back because it needed to be in the -rc cycles instead
- Another core fix
- Two mlx5 fixes

----------------------------------------------------------------
Bharat Potnuri (1):
      RDMA/uverbs: Initialize cq_context appropriately

Majd Dibbiny (2):
      IB/mlx5: Fix Raw Packet QP event handler assignment
      IB/mlx5: Always return success for RoCE modify port

Noa Osherovich (1):
      IB/core: Avoid accessing non-allocated memory when inferring port
type

 drivers/infiniband/core/uverbs_cmd.c | 13 ++++++++-----
 drivers/infiniband/core/verbs.c      |  7 ++++++-
 drivers/infiniband/hw/mlx5/main.c    |  6 ++++++
 drivers/infiniband/hw/mlx5/qp.c      |  1 +
 include/rdma/ib_verbs.h              |  1 +
 5 files changed, 22 insertions(+), 6 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
