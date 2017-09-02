From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 00/13] mmu_notifier kill invalidate_page callback v2
Date: Sat, 2 Sep 2017 15:28:31 +0200
Message-ID: <20170902132831.GA26026@redhat.com>
References: <20170831211738.17922-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170831211738.17922-1-jglisse@redhat.com>
Sender: owner-linux-mm@kvack.org
To: jglisse@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Joerg Roedel <jroedel@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Dimitri Sivanich <sivanich@sgi.com>, Jack Steiner <steiner@sgi.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 31, 2017 at 05:17:25PM -0400, Jerome Glisse wrote:
> Jérôme Glisse (13):
>   dax: update to new mmu_notifier semantic
>   mm/rmap: update to new mmu_notifier semantic
>   powerpc/powernv: update to new mmu_notifier semantic
>   drm/amdgpu: update to new mmu_notifier semantic
>   IB/umem: update to new mmu_notifier semantic
>   IB/hfi1: update to new mmu_notifier semantic
>   iommu/amd: update to new mmu_notifier semantic
>   iommu/intel: update to new mmu_notifier semantic
>   misc/mic/scif: update to new mmu_notifier semantic
>   sgi-gru: update to new mmu_notifier semantic
>   xen/gntdev: update to new mmu_notifier semantic
>   KVM: update to new mmu_notifier semantic
>   mm/mmu_notifier: kill invalidate_page

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
