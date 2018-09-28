From: john.hubbard@gmail.com
Subject: [PATCH 4/4] goldfish_pipe/mm: convert to the new release_user_pages() call
Date: Thu, 27 Sep 2018 22:39:49 -0700
Message-ID: <20180928053949.5381-5-jhubbard@nvidia.com>
References: <20180928053949.5381-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928053949.5381-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

For code that retains pages via get_user_pages*(),
release those pages via the new release_user_pages(),
instead of calling put_page().

This prepares for eventually fixing the problem described
in [1], and is following a plan listed in [2].

[1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"

[2] https://lkml.kernel.org/r/20180709080554.21931-1-jhubbard@nvidia.com
    Proposed steps for fixing get_user_pages() + DMA problems.

CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/platform/goldfish/goldfish_pipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index fad0345376e0..1e9455a86698 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -340,8 +340,9 @@ static void __release_user_pages(struct page **pages, int pages_count,
 	for (i = 0; i < pages_count; i++) {
 		if (!is_write && consumed_size > 0)
 			set_page_dirty(pages[i]);
-		put_page(pages[i]);
 	}
+
+	release_user_pages(pages, pages_count);
 }
 
 /* Populate the call parameters, merging adjacent pages together */
-- 
2.19.0
