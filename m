From: john.hubbard@gmail.com
Subject: [PATCH 0/1] RDMA/umem: minor bug fix and cleanup in error handling paths
Date: Fri,  1 Mar 2019 19:27:25 -0800
Message-ID: <20190302032726.11769-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Hi,

Ira Weiny alerted me to a couple of places where I'd missed a change from
put_page() to put_user_page(), in my pending patchsets. But when I
attempted to dive more deeply into that code, I ran into things that I
*think* should be fixed up a bit.

I hope I didn't completely miss something. I am not set up to test this
(no Infiniband hardware) so I'm not even sure I should send this out, but
it seems like the best way to ask "is this code really working the way I
think it does"?

This applies to the latest linux.git tree.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-mm@kvack.org

John Hubbard (1):
  RDMA/umem: minor bug fix and cleanup in error handling paths

 drivers/infiniband/core/umem_odp.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

-- 
2.21.0
