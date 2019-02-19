From: jglisse@redhat.com
Subject: [PATCH v5 1/9] mm/mmu_notifier: helper to test if a range invalidation is blockable
Date: Tue, 19 Feb 2019 15:04:22 -0500
Message-ID: <20190219200430.11130-2-jglisse@redhat.com>
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

Simple helpers to test if range invalidation is blockable. Latter
patches use cocinnelle to convert all direct dereference of range->
blockable to use this function instead so that we can convert the
blockable field to an unsigned for more flags.

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
Cc: linux-fsdevel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/mmu_notifier.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 4050ec1c3b45..e630def131ce 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -226,6 +226,12 @@ extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r,
 extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 				  unsigned long start, unsigned long end);
 
+static inline bool
+mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
+{
+	return range->blockable;
+}
+
 static inline void mmu_notifier_release(struct mm_struct *mm)
 {
 	if (mm_has_notifiers(mm))
@@ -455,6 +461,11 @@ static inline void _mmu_notifier_range_init(struct mmu_notifier_range *range,
 #define mmu_notifier_range_init(range, mm, start, end) \
 	_mmu_notifier_range_init(range, start, end)
 
+static inline bool
+mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
+{
+	return true;
+}
 
 static inline int mm_has_notifiers(struct mm_struct *mm)
 {
-- 
2.17.2
