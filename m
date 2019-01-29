From: Joel Nider <joeln@il.ibm.com>
Subject: [PATCH 1/5] mm: add get_user_pages_remote_longterm function
Date: Tue, 29 Jan 2019 15:26:22 +0200
Message-ID: <1548768386-28289-2-git-send-email-joeln@il.ibm.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Joel Nider <joeln@il.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In order to support the RDMA reg_remote_mr function, we must have the
ability to get memory pages for an indeterminate amount of time from
a remote process. In this case, 'remote' simply means a process that is
different from the caller. Functions for getting longterm pages
(get_user_pages_longterm) and remote pages (get_user_pages_remote)
already exist - this new function combines the functionality of both
of them.

Signed-off-by: Joel Nider <joeln@il.ibm.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
---
 include/linux/mm.h | 28 +++++++++++++++++++++++++---
 mm/gup.c           | 15 ++++++++++-----
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80bb640..1f5c72472 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1537,9 +1537,21 @@ long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 #ifdef CONFIG_FS_DAX
-long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
-			    unsigned int gup_flags, struct page **pages,
-			    struct vm_area_struct **vmas);
+long get_user_pages_remote_longterm(struct task_struct *tsk,
+			    struct mm_struct *mm, unsigned long start,
+			    unsigned long nr_pages, unsigned int gup_flags,
+			    struct page **pages, struct vm_area_struct **vmas);
+
+static inline long get_user_pages_longterm(unsigned long start,
+					   unsigned long nr_pages,
+					   unsigned int gup_flags,
+					   struct page **pages,
+					   struct vm_area_struct **vmas)
+{
+	return get_user_pages_remote_longterm(current, current->mm, start,
+					      nr_pages, gup_flags, pages,
+					      vmas);
+}
 #else
 static inline long get_user_pages_longterm(unsigned long start,
 		unsigned long nr_pages, unsigned int gup_flags,
@@ -1547,6 +1559,16 @@ static inline long get_user_pages_longterm(unsigned long start,
 {
 	return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
 }
+
+static inline long get_user_pages_remote_longterm(struct task_struct *tsk,
+		struct mm_struct *mm, unsigned long start,
+		unsigned long nr_pages, unsigned int gup_flags,
+		struct page **pages, struct vm_area_struct **vmas)
+{
+	return get_user_pages_remote(tsk, mm, start, nr_pages,
+		gup_flags, pages, vmas);
+}
+
 #endif /* CONFIG_FS_DAX */
 
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
diff --git a/mm/gup.c b/mm/gup.c
index 05acd7e..bcfe5a6 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1139,9 +1139,11 @@ EXPORT_SYMBOL(get_user_pages);
  * "longterm" == userspace controlled elevated page count lifetime.
  * Contrast this to iov_iter_get_pages() usages which are transient.
  */
-long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas_arg)
+long get_user_pages_remote_longterm(struct task_struct *tsk,
+			    struct mm_struct *mm, unsigned long start,
+			    unsigned long nr_pages, unsigned int gup_flags,
+			    struct page **pages,
+			    struct vm_area_struct **vmas_arg)
 {
 	struct vm_area_struct **vmas = vmas_arg;
 	struct vm_area_struct *vma_prev = NULL;
@@ -1157,7 +1159,9 @@ long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
 			return -ENOMEM;
 	}
 
-	rc = get_user_pages(start, nr_pages, gup_flags, pages, vmas);
+	rc = __get_user_pages_locked(tsk, mm, start, nr_pages,
+				     pages, vmas, NULL,
+				     gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 
 	for (i = 0; i < rc; i++) {
 		struct vm_area_struct *vma = vmas[i];
@@ -1187,7 +1191,8 @@ long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
 		kfree(vmas);
 	return rc;
 }
-EXPORT_SYMBOL(get_user_pages_longterm);
+EXPORT_SYMBOL(get_user_pages_remote_longterm);
+
 #endif /* CONFIG_FS_DAX */
 
 /**
-- 
2.7.4
