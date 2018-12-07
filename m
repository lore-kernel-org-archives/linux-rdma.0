From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 1/3] mm/mmu_notifier: use structure for
 invalidate_range_start/end callback
Date: Thu, 6 Dec 2018 20:30:27 -0700
Message-ID: <20181207033027.GA20236@ziepe.ca>
References: <20181205053628.3210-1-jglisse@redhat.com>
 <20181205053628.3210-2-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181205053628.3210-2-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jglisse@redhat.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <zwisler@kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christian Koenig <christian.koenig@amd.com>, Felix Kuehling <felix.kuehling@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 05, 2018 at 12:36:26AM -0500, jglisse@redhat.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> To avoid having to change many callback definition everytime we want
> to add a parameter use a structure to group all parameters for the
> mmu_notifier invalidate_range_start/end callback. No functional changes
> with this patch.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Felix Kuehling <felix.kuehling@amd.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: kvm@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c  | 43 +++++++++++--------------
>  drivers/gpu/drm/i915/i915_gem_userptr.c | 14 ++++----
>  drivers/gpu/drm/radeon/radeon_mn.c      | 16 ++++-----
>  drivers/infiniband/core/umem_odp.c      | 20 +++++-------
>  drivers/infiniband/hw/hfi1/mmu_rb.c     | 13 +++-----
>  drivers/misc/mic/scif/scif_dma.c        | 11 ++-----
>  drivers/misc/sgi-gru/grutlbpurge.c      | 14 ++++----
>  drivers/xen/gntdev.c                    | 12 +++----
>  include/linux/mmu_notifier.h            | 14 +++++---
>  mm/hmm.c                                | 23 ++++++-------
>  mm/mmu_notifier.c                       | 21 ++++++++++--
>  virt/kvm/kvm_main.c                     | 14 +++-----
>  12 files changed, 102 insertions(+), 113 deletions(-)

The changes to drivers/infiniband look mechanical and fine to me.

It even looks like this avoids merge conflicts with the other changes
to these files :)

For infiniband:

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

I assume this will go through the mm tree?

Jason
