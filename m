From: ira.weiny@intel.com
Subject: [PATCH 0/3] Add gup fast + longterm and use it in HFI1
Date: Mon, 11 Feb 2019 12:16:40 -0800
Message-ID: <20190211201643.7599-1-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

NOTE: This series depends on my clean up patch to remove the write parameter
from gup_fast_permitted()[1]

HFI1 uses get_user_pages_fast() due to it performance advantages.  Like RDMA,
HFI1 pages can be held for a significant time.  But get_user_pages_fast() does
not protect against mapping of FS DAX pages.

Introduce a get_user_pages_fast_longterm() which retains the performance while
also adding the FS DAX checks.  XDP has also shown interest in using this
functionality.[2]

[1] https://lkml.org/lkml/2019/2/11/237
[2] https://lkml.org/lkml/2019/2/11/1789

Ira Weiny (3):
  mm/gup: Change "write" parameter to flags
  mm/gup: Introduce get_user_pages_fast_longterm()
  IB/HFI1: Use new get_user_pages_fast_longterm()

 drivers/infiniband/hw/hfi1/user_pages.c |   2 +-
 include/linux/mm.h                      |   8 ++
 mm/gup.c                                | 152 ++++++++++++++++--------
 3 files changed, 114 insertions(+), 48 deletions(-)

-- 
2.20.1
