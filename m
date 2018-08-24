From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 19:54:19 +0900
Message-ID: <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
References: <20180716115058.5559-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716115058.5559-1-mhocko@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Dimitri Sivanich <sivanich@sgi.com>, Boris Ostrovsky <boris.ostrovsky@oracle.c>
List-Id: linux-rdma@vger.kernel.org

Two more worries for this patch.



> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
> @@ -178,12 +178,18 @@ void amdgpu_mn_unlock(struct amdgpu_mn *mn)
>   *
>   * @amn: our notifier
>   */
> -static void amdgpu_mn_read_lock(struct amdgpu_mn *amn)
> +static int amdgpu_mn_read_lock(struct amdgpu_mn *amn, bool blockable)
>  {
> -       mutex_lock(&amn->read_lock);
> +       if (blockable)
> +               mutex_lock(&amn->read_lock);
> +       else if (!mutex_trylock(&amn->read_lock))
> +               return -EAGAIN;
> +
>         if (atomic_inc_return(&amn->recursion) == 1)
>                 down_read_non_owner(&amn->lock);

Why don't we need to use trylock here if blockable == false ?
Want comment why it is safe to use blocking lock here.

>         mutex_unlock(&amn->read_lock);
> +
> +       return 0;
>  }
> 
>  /**



> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -177,16 +177,19 @@ static void hmm_release(struct mmu_notifier *mn, struct mm_struct *mm)
>         up_write(&hmm->mirrors_sem);
>  }
> 
> -static void hmm_invalidate_range_start(struct mmu_notifier *mn,
> +static int hmm_invalidate_range_start(struct mmu_notifier *mn,
>                                        struct mm_struct *mm,
>                                        unsigned long start,
> -                                      unsigned long end)
> +                                      unsigned long end,
> +                                      bool blockable)
>  {
>         struct hmm *hmm = mm->hmm;
> 
>         VM_BUG_ON(!hmm);
> 
>         atomic_inc(&hmm->sequence);
> +
> +       return 0;
>  }
> 
>  static void hmm_invalidate_range_end(struct mmu_notifier *mn,

This assumes that hmm_invalidate_range_end() does not have memory
allocation dependency. But hmm_invalidate_range() from
hmm_invalidate_range_end() involves

        down_read(&hmm->mirrors_sem);
        list_for_each_entry(mirror, &hmm->mirrors, list)
                mirror->ops->sync_cpu_device_pagetables(mirror, action,
                                                        start, end);
        up_read(&hmm->mirrors_sem);

sequence. What is surprising is that there is no in-tree user who assigns
sync_cpu_device_pagetables field.

  $ grep -Fr sync_cpu_device_pagetables *
  Documentation/vm/hmm.rst:     /* sync_cpu_device_pagetables() - synchronize page tables
  include/linux/hmm.h: * will get callbacks through sync_cpu_device_pagetables() operation (see
  include/linux/hmm.h:    /* sync_cpu_device_pagetables() - synchronize page tables
  include/linux/hmm.h:    void (*sync_cpu_device_pagetables)(struct hmm_mirror *mirror,
  include/linux/hmm.h: * hmm_mirror_ops.sync_cpu_device_pagetables() callback, so that CPU page
  mm/hmm.c:               mirror->ops->sync_cpu_device_pagetables(mirror, action,

That is, this API seems to be currently used by only out-of-tree users. Since
we can't check that nobody has memory allocation dependency, I think that
hmm_invalidate_range_start() should return -EAGAIN if blockable == false for now.
