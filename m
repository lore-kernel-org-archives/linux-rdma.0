From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Fixes for cbuild and travis
Date: Mon, 15 Jan 2018 14:13:44 -0700
Message-ID: <20180115211347.5651-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix the unconditional travis failures with the latest suse tumbleweed docker
images

Fix perplexing travis failures with no output from sparse.

Use clang 5.0

This is a PR:

https://github.com/linux-rdma/rdma-core/pull/283

Jason Gunthorpe (3):
  cbuild: Support distros that only ship python3
  travis: Do not loose ninja output if ninja fails during sparse
  travis: Use clang-5.0

 .travis.yml           |  6 +++---
 buildlib/cbuild       | 16 ++++++++++------
 buildlib/travis-build | 10 +++++-----
 3 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
