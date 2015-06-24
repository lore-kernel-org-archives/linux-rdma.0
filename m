From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH 33/36] IB/odp/hmm: add core infiniband structure and helper
 for ODP with HMM.
Date: Wed, 24 Jun 2015 16:59:56 +0300
Message-ID: <558AB7DC.20703@mellanox.com>
References: <1432236705-4209-1-git-send-email-j.glisse@gmail.com>
 <1432239792-5002-1-git-send-email-jglisse@redhat.com>
 <1432239792-5002-14-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1432239792-5002-14-git-send-email-jglisse@redhat.com>
Sender: owner-linux-mm@kvack.org
To: jglisse@redhat.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>, joro@8bytes.org, Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Johannes
 Weiner <jweiner@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Rik van
 Riel <riel@redhat.com>, Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron
 Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Shachar Raindel <raindel@mellanox.com>, Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@p>
List-Id: linux-rdma@vger.kernel.org

On 21/05/2015 23:23, jglisse@redhat.com wrote:
> +int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
> +{
> +	struct mm_struct *mm = get_task_mm(current);
> +	struct ib_device *ib_device = context->device;
> +	struct ib_mirror *ib_mirror;
> +	struct pid *our_pid;
> +	int ret;
> +
> +	if (!mm || !ib_device->hmm_ready)
> +		return -EINVAL;
> +
> +	/* FIXME can this really happen ? */
No, following Yann Droneaud's patch 8abaae62f3fd ("IB/core: disallow
registering 0-sized memory region") ib_umem_get() checks against zero
sized umems.

> +	if (unlikely(ib_umem_start(umem) == ib_umem_end(umem)))
> +		return -EINVAL;
> +
> +	/* Prevent creating ODP MRs in child processes */
> +	rcu_read_lock();
> +	our_pid = get_task_pid(current->group_leader, PIDTYPE_PID);
> +	rcu_read_unlock();
> +	put_pid(our_pid);
> +	if (context->tgid != our_pid) {
> +		mmput(mm);
> +		return -EINVAL;
> +	}
> +
> +	umem->hugetlb = 0;
> +	umem->odp_data = kmalloc(sizeof(*umem->odp_data), GFP_KERNEL);
> +	if (umem->odp_data == NULL) {
> +		mmput(mm);
> +		return -ENOMEM;
> +	}
> +	umem->odp_data->private = NULL;
> +	umem->odp_data->umem = umem;
> +
> +	mutex_lock(&ib_device->hmm_mutex);
> +	/* Is there an existing mirror for this process mm ? */
> +	ib_mirror = ib_mirror_ref(context->ib_mirror);
> +	if (!ib_mirror)
> +		list_for_each_entry(ib_mirror, &ib_device->ib_mirrors, list) {
> +			if (ib_mirror->base.hmm->mm != mm)
> +				continue;
> +			ib_mirror = ib_mirror_ref(ib_mirror);
> +			break;
> +		}
> +
> +	if (ib_mirror == NULL ||
> +	    ib_mirror == list_first_entry(&ib_device->ib_mirrors,
> +					  struct ib_mirror, list)) {
Is the second check an attempt to check if the list_for_each_entry above
passed through all the entries and didn't break? Maybe I missing
something, but I think that would cause the ib_mirror to hold a pointer
such that ib_mirror->list == ib_mirrors (point to the list head), and
not to the first entry.

In any case, I think it would be more clear if you add another ib_mirror
variable for iterating the ib_mirrors list.

> +		/* We need to create a new mirror. */
> +		ib_mirror = kmalloc(sizeof(*ib_mirror), GFP_KERNEL);
> +		if (ib_mirror == NULL) {
> +			mutex_unlock(&ib_device->hmm_mutex);
> +			mmput(mm);
> +			return -ENOMEM;
> +		}
> +		kref_init(&ib_mirror->kref);
> +		init_rwsem(&ib_mirror->hmm_mr_rwsem);
> +		ib_mirror->umem_tree = RB_ROOT;
> +		ib_mirror->ib_device = ib_device;
> +
> +		ib_mirror->base.device = &ib_device->hmm_dev;
> +		ret = hmm_mirror_register(&ib_mirror->base);
> +		if (ret) {
> +			mutex_unlock(&ib_device->hmm_mutex);
> +			kfree(ib_mirror);
> +			mmput(mm);
> +			return ret;
> +		}
> +
> +		list_add(&ib_mirror->list, &ib_device->ib_mirrors);
> +		context->ib_mirror = ib_mirror_ref(ib_mirror);
> +	}
> +	mutex_unlock(&ib_device->hmm_mutex);
> +	umem->odp_data.ib_mirror = ib_mirror;
> +
> +	down_write(&ib_mirror->umem_rwsem);
> +	rbt_ib_umem_insert(&umem->odp_data->interval_tree, &mirror->umem_tree);
> +	up_write(&ib_mirror->umem_rwsem);
> +
> +	mmput(mm);
> +	return 0;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
