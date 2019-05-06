From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v14 11/17] drm/amdgpu, arm64: untag user pointers
Date: Mon, 6 May 2019 15:50:25 +0200
Message-ID: <CAAeHK+zDScw-aYpQFVG=JKartDqCF+ZWnq3-6PuaYgMiBphcJA@mail.gmail.com>
References: <cover.1556630205.git.andreyknvl@google.com> <2e827b5c484be14044933049fec180cd6acb054b.1556630205.git.andreyknvl@google.com>
 <3108d33e-8e18-a73e-5e1a-f0db64f02ab3@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3108d33e-8e18-a73e-5e1a-f0db64f02ab3@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kuehling, Felix" <Felix.Kuehling@amd.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2019 at 8:03 PM Kuehling, Felix <Felix.Kuehling@amd.com> wrote:
>
> On 2019-04-30 9:25 a.m., Andrey Konovalov wrote:
> > [CAUTION: External Email]
> >
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > amdgpu_ttm_tt_get_user_pages() uses provided user pointers for vma
> > lookups, which can only by done with untagged pointers. This patch
> > untag user pointers when they are being set in
> > amdgpu_ttm_tt_set_userptr().
> >
> > In amdgpu_gem_userptr_ioctl() and amdgpu_amdkfd_gpuvm.c/init_user_pages()
> > an MMU notifier is set up with a (tagged) userspace pointer. The untagged
> > address should be used so that MMU notifiers for the untagged address get
> > correctly matched up with the right BO. This patch untag user pointers in
> > amdgpu_gem_userptr_ioctl() for the GEM case and in
> > amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu() for the KFD case.
> >
> > Suggested-by: Kuehling, Felix <Felix.Kuehling@amd.com>
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >   drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
> >   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c          | 2 ++
> >   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c          | 2 +-
> >   3 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> > index 1921dec3df7a..20cac44ed449 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> > @@ -1121,7 +1121,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
> >                  alloc_flags = 0;
> >                  if (!offset || !*offset)
> >                          return -EINVAL;
> > -               user_addr = *offset;
> > +               user_addr = untagged_addr(*offset);
> >          } else if (flags & ALLOC_MEM_FLAGS_DOORBELL) {
> >                  domain = AMDGPU_GEM_DOMAIN_GTT;
> >                  alloc_domain = AMDGPU_GEM_DOMAIN_CPU;
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> > index d21dd2f369da..985cb82b2aa6 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> > @@ -286,6 +286,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
> >          uint32_t handle;
> >          int r;
> >
> > +       args->addr = untagged_addr(args->addr);
> > +
> >          if (offset_in_page(args->addr | args->size))
> >                  return -EINVAL;
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> > index 73e71e61dc99..1d30e97ac2c4 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> > @@ -1248,7 +1248,7 @@ int amdgpu_ttm_tt_set_userptr(struct ttm_tt *ttm, uint64_t addr,
> >          if (gtt == NULL)
> >                  return -EINVAL;
> >
> > -       gtt->userptr = addr;
> > +       gtt->userptr = untagged_addr(addr);
>
> Doing this here seems unnecessary. You already untagged the address in
> both callers of this function. Untagging in the two callers ensures that
> the userptr and MMU notifier are in sync, using the same untagged
> address. Doing it again here is redundant.

 Will fix in v15, thanks!

>
> Regards,
>    Felix
>
>
> >          gtt->userflags = flags;
> >
> >          if (gtt->usertask)
> > --
> > 2.21.0.593.g511ec345e18-goog
> >
