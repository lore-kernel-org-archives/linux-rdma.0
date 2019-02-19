From: jglisse@redhat.com
Subject: [PATCH v5 3/9] mm/mmu_notifier: convert mmu_notifier_range->blockable to a flags
Date: Tue, 19 Feb 2019 15:04:24 -0500
Message-ID: <20190219200430.11130-4-jglisse@redhat.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219200430.11130-1-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Peter Xu <peterx@redhat.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

Use an unsigned field for flags other than blockable and convert
the blockable field to be one of those flags.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kvm@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/mmu_notifier.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index e630def131ce..c8672c366f67 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -25,11 +25,13 @@ struct mmu_notifier_mm {
 	spinlock_t lock;
 };
 
+#define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
+
 struct mmu_notifier_range {
 	struct mm_struct *mm;
 	unsigned long start;
 	unsigned long end;
-	bool blockable;
+	unsigned flags;
 };
 
 struct mmu_notifier_ops {
@@ -229,7 +231,7 @@ extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 static inline bool
 mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
 {
-	return range->blockable;
+	return (range->flags & MMU_NOTIFIER_RANGE_BLOCKABLE);
 }
 
 static inline void mmu_notifier_release(struct mm_struct *mm)
@@ -275,7 +277,7 @@ static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
 	if (mm_has_notifiers(range->mm)) {
-		range->blockable = true;
+		range->flags |= MMU_NOTIFIER_RANGE_BLOCKABLE;
 		__mmu_notifier_invalidate_range_start(range);
 	}
 }
@@ -284,7 +286,7 @@ static inline int
 mmu_notifier_invalidate_range_start_nonblock(struct mmu_notifier_range *range)
 {
 	if (mm_has_notifiers(range->mm)) {
-		range->blockable = false;
+		range->flags &= ~MMU_NOTIFIER_RANGE_BLOCKABLE;
 		return __mmu_notifier_invalidate_range_start(range);
 	}
 	return 0;
@@ -331,6 +333,7 @@ static inline void mmu_notifier_range_init(struct mmu_notifier_range *range,
 	range->mm = mm;
 	range->start = start;
 	range->end = end;
+	range->flags = 0;
 }
 
 #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
-- 
2.17.2
