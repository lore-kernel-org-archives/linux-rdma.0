From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 7/6] Documentation/infiniband: update from locked to pinned_vm
Date: Wed, 6 Feb 2019 17:31:55 -0800
Message-ID: <20190207013155.lq5diwqc2svyt3t3@linux-r8p5>
References: <20190206175920.31082-1-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190206175920.31082-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca, akpm@linux-foundation.org
Cc: dledford@redhat.com, jgg@mellanox.com, jack@suse.cz, willy@infradead.org, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We are really talking about pinned_vm here.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 Documentation/infiniband/user_verbs.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/infiniband/user_verbs.txt
index df049b9f5b6e..47ebf2f80b2b 100644
--- a/Documentation/infiniband/user_verbs.txt
+++ b/Documentation/infiniband/user_verbs.txt
@@ -46,11 +46,11 @@ Memory pinning
   I/O targets be kept resident at the same physical address.  The
   ib_uverbs module manages pinning and unpinning memory regions via
   get_user_pages() and put_page() calls.  It also accounts for the
-  amount of memory pinned in the process's locked_vm, and checks that
+  amount of memory pinned in the process's pinned_vm, and checks that
   unprivileged processes do not exceed their RLIMIT_MEMLOCK limit.
 
   Pages that are pinned multiple times are counted each time they are
-  pinned, so the value of locked_vm may be an overestimate of the
+  pinned, so the value of pinned_vm may be an overestimate of the
   number of pages pinned by a process.
 
 /dev files
-- 
2.16.4
