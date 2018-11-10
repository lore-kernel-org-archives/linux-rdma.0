From: john.hubbard@gmail.com
Subject: [PATCH v2 1/6] mm/gup: finish consolidating error handling
Date: Sat, 10 Nov 2018 00:50:36 -0800
Message-ID: <20181110085041.10071-2-jhubbard@nvidia.com>
References: <20181110085041.10071-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181110085041.10071-1-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Keith Busch <keith.busch@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

An upcoming patch wants to be able to operate on each page that
get_user_pages has retrieved. In order to do that, it's best to
have a common exit point from the routine. Most of this has been
taken care of by commit df06b37ffe5a4 ("mm/gup: cache dev_pagemap while
pinning pages"), but there was one case remaining.

Also, there was still an unnecessary shadow declaration (with a
different type) of the "ret" variable, which this commit removes.

Cc: Keith Busch <keith.busch@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index f76e77a2d34b..55a41dee0340 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -696,12 +696,11 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		if (!vma || start >= vma->vm_end) {
 			vma = find_extend_vma(mm, start);
 			if (!vma && in_gate_area(mm, start)) {
-				int ret;
 				ret = get_gate_page(mm, start & PAGE_MASK,
 						gup_flags, &vma,
 						pages ? &pages[i] : NULL);
 				if (ret)
-					return i ? : ret;
+					goto out;
 				ctx.page_mask = 0;
 				goto next_page;
 			}
-- 
2.19.1
