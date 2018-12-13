From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 3/3] mm/mmu_notifier: contextual information for event
 triggering invalidation v2
Date: Thu, 13 Dec 2018 09:21:12 -0800
Message-ID: <CAPcyv4i=Vq9VQphMhyuuBpS5j9MeuaXF9URyR=a4kN+ios5Gyg@mail.gmail.com>
References: <20181213171330.8489-1-jglisse@redhat.com> <20181213171330.8489-4-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213171330.8489-4-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, zwisler@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Michal Hocko <mhocko@kernel.org>, "Koenig, Christian" <christian.koenig@amd.com>, rcampbell@nvidia.com, John Hubbard <jhubbard@nvidia.com>, KVM list <kvm@vger.kernel.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 13, 2018 at 9:14 AM <jglisse@redhat.com> wrote:
>
> From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
>
> CPU page table update can happens for many reasons, not only as a result
> of a syscall (munmap(), mprotect(), mremap(), madvise(), ...) but also
> as a result of kernel activities (memory compression, reclaim, migration,
> ...).
>
> Users of mmu notifier API track changes to the CPU page table and take
> specific action for them. While current API only provide range of virtual
> address affected by the change, not why the changes is happening.
>
> This patchset adds event information so that users of mmu notifier can
> differentiate among broad category:
>     - UNMAP: munmap() or mremap()
>     - CLEAR: page table is cleared (migration, compaction, reclaim, ...)
>     - PROTECTION_VMA: change in access protections for the range
>     - PROTECTION_PAGE: change in access protections for page in the range
>     - SOFT_DIRTY: soft dirtyness tracking
>
> Being able to identify munmap() and mremap() from other reasons why the
> page table is cleared is important to allow user of mmu notifier to
> update their own internal tracking structure accordingly (on munmap or
> mremap it is not longer needed to track range of virtual address as it
> becomes invalid).

Who consumes these new enum values? The consumer of the new
infrastructure should be included in the patchset that adds the new
functionality. So a NAK from me until the consumer is clarified /
included.
