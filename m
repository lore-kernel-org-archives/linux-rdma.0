From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH 0/2] mm: unexport __get_user_pages_unlocked()
Date: Thu, 27 Oct 2016 10:51:39 +0100
Message-ID: <20161027095141.2569-1-lstoakes@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch series continues the cleanup of get_user_pages*() functions taking
advantage of the fact we can now pass gup_flags as we please.

It firstly adds an additional 'locked' parameter to get_user_pages_remote() to
allow for its callers to utilise VM_FAULT_RETRY functionality. This is necessary
as the invocation of __get_user_pages_unlocked() in process_vm_rw_single_vec()
makes use of this and no other existing higher level function would allow it to
do so.

Secondly existing callers of __get_user_pages_unlocked() are replaced with the
appropriate higher-level replacement - get_user_pages_unlocked() if the current
task and memory descriptor are referenced, or get_user_pages_remote() if other
task/memory descriptors are referenced (having acquiring mmap_sem.)

Lorenzo Stoakes (2):
  mm: add locked parameter to get_user_pages_remote()
  mm: unexport __get_user_pages_unlocked()

 drivers/gpu/drm/etnaviv/etnaviv_gem.c   |  2 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c |  2 +-
 drivers/infiniband/core/umem_odp.c      |  2 +-
 fs/exec.c                               |  2 +-
 include/linux/mm.h                      |  5 +----
 kernel/events/uprobes.c                 |  4 ++--
 mm/gup.c                                | 20 ++++++++++++--------
 mm/memory.c                             |  2 +-
 mm/nommu.c                              |  7 +++----
 mm/process_vm_access.c                  | 12 ++++++++----
 security/tomoyo/domain.c                |  2 +-
 virt/kvm/async_pf.c                     | 10 +++++++---
 virt/kvm/kvm_main.c                     |  5 ++---
 13 files changed, 41 insertions(+), 34 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
