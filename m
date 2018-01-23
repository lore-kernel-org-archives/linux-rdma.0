From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Tue, 23 Jan 2018 12:54:59 -0800
Message-ID: <20180123205459.432-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, roland@purestorage.com, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

mthca_map_user_db() has two problems regarding the call to
get_user_pages():

(i) It is not done under mmap_sem.

(ii) It is done under the db_table mutex, which protects all
database related operations. Should any of these be called
under mmap_sem, we get an ABBA deadlock. In addition, gup can
be performance intensive, which could contend other mapping/
unmapping ops.

To fix this, we can drop the mutex while doing a gup_fast(),
once done, recheck to see the page was mapped while we didn't
hold the mutex, and exit out with the corresponding housekeeping.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---

- Compile tested only.

- Should I be wrong about no callers already holding mmap_sem,
  I still think calling gup without the mutex makes sense for
  improved paralellism. Now, if callers can hold the mmap_sem,
  it's wrong to do copy_from_user right before calling mthca_map_user_db.


 drivers/infiniband/hw/mthca/mthca_memfree.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index c6fe89d79248..046871878a02 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -472,9 +472,27 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		goto out;
 	}
 
-	ret = get_user_pages(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages, NULL);
+	mutex_unlock(&db_tab->mutex);
+
+	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages);
 	if (ret < 0)
+		return ret;
+
+	mutex_lock(&db_tab->mutex);
+
+	if (db_tab->page[i].refcount >= MTHCA_DB_REC_PER_PAGE ||
+	    (db_tab->page[i].uvirt && db_tab->page[i].uvirt != uaddr)) {
+		put_page(pages[0]);
+		ret = -EINVAL;
 		goto out;
+	}
+
+	/* page was already mapped by another task while we were doing gup */
+	if (db_tab->page[i].refcount) {
+		put_page(pages[0]);
+		++db_tab->page[i].refcount;
+		goto out;
+	}
 
 	sg_set_page(&db_tab->page[i].mem, pages[0], MTHCA_ICM_PAGE_SIZE,
 			uaddr & ~PAGE_MASK);
-- 
2.13.6
