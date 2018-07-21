From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 20 Jul 2018 17:09:02 -0700
Message-ID: <20180720170902.d1137060c23802d55426aa03@linux-foundation.org>
References: <20180716115058.5559-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716115058.5559-1-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Dimitri Sivanich <sivanich@sgi.com>, Boris Ostrovsky <boris.ostrovsky>
List-Id: linux-rdma@vger.kernel.org

On Mon, 16 Jul 2018 13:50:58 +0200 Michal Hocko <mhocko@kernel.org> wrote:

> From: Michal Hocko <mhocko@suse.com>
> 
> There are several blockable mmu notifiers which might sleep in
> mmu_notifier_invalidate_range_start and that is a problem for the
> oom_reaper because it needs to guarantee a forward progress so it cannot
> depend on any sleepable locks.
> 
> ...
>
> @@ -571,7 +565,12 @@ static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	trace_start_task_reaping(tsk->pid);
>  
> -	__oom_reap_task_mm(mm);
> +	/* failed to reap part of the address space. Try again later */
> +	if (!__oom_reap_task_mm(mm)) {
> +		up_read(&mm->mmap_sem);
> +		ret = false;
> +		goto unlock_oom;
> +	}

This function is starting to look a bit screwy.

: static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
: {
: 	if (!down_read_trylock(&mm->mmap_sem)) {
: 		trace_skip_task_reaping(tsk->pid);
: 		return false;
: 	}
: 
: 	/*
: 	 * MMF_OOM_SKIP is set by exit_mmap when the OOM reaper can't
: 	 * work on the mm anymore. The check for MMF_OOM_SKIP must run
: 	 * under mmap_sem for reading because it serializes against the
: 	 * down_write();up_write() cycle in exit_mmap().
: 	 */
: 	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
: 		up_read(&mm->mmap_sem);
: 		trace_skip_task_reaping(tsk->pid);
: 		return true;
: 	}
: 
: 	trace_start_task_reaping(tsk->pid);
: 
: 	/* failed to reap part of the address space. Try again later */
: 	if (!__oom_reap_task_mm(mm)) {
: 		up_read(&mm->mmap_sem);
: 		return true;
: 	}
: 
: 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
: 			task_pid_nr(tsk), tsk->comm,
: 			K(get_mm_counter(mm, MM_ANONPAGES)),
: 			K(get_mm_counter(mm, MM_FILEPAGES)),
: 			K(get_mm_counter(mm, MM_SHMEMPAGES)));
: 	up_read(&mm->mmap_sem);
: 
: 	trace_finish_task_reaping(tsk->pid);
: 	return true;
: }

- Undocumented return value.

- comment "failed to reap part..." is misleading - sounds like it's
  referring to something which happened in the past, is in fact
  referring to something which might happen in the future.

- fails to call trace_finish_task_reaping() in one case

- code duplication.


I'm thinking it wants to be something like this?

: /*
:  * Return true if we successfully acquired (then released) mmap_sem
:  */
: static bool oom_reap_task_mm(struct task_struct *tsk, struct mm_struct *mm)
: {
: 	if (!down_read_trylock(&mm->mmap_sem)) {
: 		trace_skip_task_reaping(tsk->pid);
: 		return false;
: 	}
: 
: 	/*
: 	 * MMF_OOM_SKIP is set by exit_mmap when the OOM reaper can't
: 	 * work on the mm anymore. The check for MMF_OOM_SKIP must run
: 	 * under mmap_sem for reading because it serializes against the
: 	 * down_write();up_write() cycle in exit_mmap().
: 	 */
: 	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
: 		trace_skip_task_reaping(tsk->pid);
: 		goto out;
: 	}
: 
: 	trace_start_task_reaping(tsk->pid);
: 
: 	if (!__oom_reap_task_mm(mm)) {
: 		/* Failed to reap part of the address space. Try again later */
: 		goto finish;
: 	}
: 
: 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
: 			task_pid_nr(tsk), tsk->comm,
: 			K(get_mm_counter(mm, MM_ANONPAGES)),
: 			K(get_mm_counter(mm, MM_FILEPAGES)),
: 			K(get_mm_counter(mm, MM_SHMEMPAGES)));
: finish:
: 	trace_finish_task_reaping(tsk->pid);
: out:
: 	up_read(&mm->mmap_sem);
: 	return true;
: }

- Increases mmap_sem hold time a little by moving
  trace_finish_task_reaping() inside the locked region.  So sue me ;)

- Sharing the finish: path means that the trace event won't
  distinguish between the two sources of finishing.

Please take a look?
