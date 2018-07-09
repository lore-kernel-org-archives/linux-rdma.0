From: john.hubbard@gmail.com
Subject: [PATCH 2/2] goldfish_pipe/mm: convert to the new put_user_page() call
Date: Mon,  9 Jul 2018 01:05:54 -0700
Message-ID: <20180709080554.21931-3-jhubbard@nvidia.com>
References: <20180709080554.21931-1-jhubbard@nvidia.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709080554.21931-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

For code that retains pages via get_user_pages*(),
release those pages via the new put_user_page(),
instead of put_page().

Also: rename release_user_pages(), to avoid a naming
conflict with the new external function of the same name.

CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/platform/goldfish/goldfish_pipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index 3e32a4c14d5f..3ab871c22a88 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -331,7 +331,7 @@ static int pin_user_pages(unsigned long first_page, unsigned long last_page,
 
 }
 
-static void release_user_pages(struct page **pages, int pages_count,
+static void __release_user_pages(struct page **pages, int pages_count,
 	int is_write, s32 consumed_size)
 {
 	int i;
@@ -339,7 +339,7 @@ static void release_user_pages(struct page **pages, int pages_count,
 	for (i = 0; i < pages_count; i++) {
 		if (!is_write && consumed_size > 0)
 			set_page_dirty(pages[i]);
-		put_page(pages[i]);
+		put_user_page(pages[i]);
 	}
 }
 
@@ -409,7 +409,7 @@ static int transfer_max_buffers(struct goldfish_pipe *pipe,
 
 	*consumed_size = pipe->command_buffer->rw_params.consumed_size;
 
-	release_user_pages(pages, pages_count, is_write, *consumed_size);
+	__release_user_pages(pages, pages_count, is_write, *consumed_size);
 
 	mutex_unlock(&pipe->lock);
 
-- 
2.18.0
