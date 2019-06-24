From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v18 09/15] drm/amdgpu: untag user pointers
Date: Mon, 24 Jun 2019 08:00:57 -0700
Message-ID: <201906240800.5677E3CF@keescook>
References: <cover.1561386715.git.andreyknvl@google.com>
 <1d036fc5bec4be059ee7f4f42bf7417dc44651dd.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1d036fc5bec4be059ee7f4f42bf7417dc44651dd.1561386715.git.andreyknvl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 04:32:54PM +0200, Andrey Konovalov wrote:
> This patch is a part of a series that extends kernel ABI to allow to pass
> tagged user pointers (with the top byte set to something else other than
> 0x00) as syscall arguments.
> 
> In amdgpu_gem_userptr_ioctl() and amdgpu_amdkfd_gpuvm.c/init_user_pages()
> an MMU notifier is set up with a (tagged) userspace pointer. The untagged
> address should be used so that MMU notifiers for the untagged address get
> correctly matched up with the right BO. This patch untag user pointers in
> amdgpu_gem_userptr_ioctl() for the GEM case and in amdgpu_amdkfd_gpuvm_
> alloc_memory_of_gpu() for the KFD case. This also makes sure that an
> untagged pointer is passed to amdgpu_ttm_tt_get_user_pages(), which uses
> it for vma lookups.
> 
> Suggested-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c          | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> index a6e5184d436c..5d476e9bbc43 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> @@ -1108,7 +1108,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
>  		alloc_flags = 0;
>  		if (!offset || !*offset)
>  			return -EINVAL;
> -		user_addr = *offset;
> +		user_addr = untagged_addr(*offset);
>  	} else if (flags & ALLOC_MEM_FLAGS_DOORBELL) {
>  		domain = AMDGPU_GEM_DOMAIN_GTT;
>  		alloc_domain = AMDGPU_GEM_DOMAIN_CPU;
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> index d4fcf5475464..e91df1407618 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -287,6 +287,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
>  	uint32_t handle;
>  	int r;
>  
> +	args->addr = untagged_addr(args->addr);
> +
>  	if (offset_in_page(args->addr | args->size))
>  		return -EINVAL;
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook
