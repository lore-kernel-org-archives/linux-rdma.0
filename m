From: jglisse@redhat.com
Subject: [PATCH v5 8/9] mm/mmu_notifier: mmu_notifier_range_update_to_read_only() helper
Date: Tue, 19 Feb 2019 15:04:29 -0500
Message-ID: <20190219200430.11130-9-jglisse@redhat.com>
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

Helper to test if a range is updated to read only (it is still valid
to read from the range). This is useful for device driver or anyone
who wish to optimize out update when they know that they already have
the range map read only.

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
 include/linux/mmu_notifier.h |  4 ++++
 mm/mmu_notifier.c            | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 0379956fff23..b6c004bd9f6a 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -259,6 +259,8 @@ extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r,
 				  bool only_end);
 extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
+extern bool
+mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *range);
 
 static inline bool
 mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
@@ -568,6 +570,8 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 {
 }
 
+#define mmu_notifier_range_update_to_read_only(r) false
+
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index abd88c466eb2..ee36068077b6 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -395,3 +395,13 @@ void mmu_notifier_unregister_no_release(struct mmu_notifier *mn,
 	mmdrop(mm);
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_unregister_no_release);
+
+bool
+mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *range)
+{
+	if (!range->vma || range->event != MMU_NOTIFY_PROTECTION_VMA)
+		return false;
+	/* Return true if the vma still have the read flag set. */
+	return range->vma->vm_flags & VM_READ;
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_range_update_to_read_only);
-- 
2.17.2
