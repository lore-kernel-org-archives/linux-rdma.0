Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712781;
	b=trEFPwF8JcomnEwW3Am7Y+Uz0Z8nQl7gXBoTerpcvFMxyDFj7ApaWIzxDkdLzPO1/Rau
	 knnAeJpfZrYY6Rd7q6gGv6dFEwl/aEAblNSfoDSWLLh5atVqsJgd0Y/TI64ugPQgDzp5Z
	 yCB2NuPVGpyv/bwokcbCS44PqIrZN2rAfb/F+Nog/tXYS7RWeJa4O+PZJejtEuDOd4jLG
	 BY246Z2rAwTrJZ8Pd28akvm2poIgYOEVfPZ2508UJy9v+KVVlFk6RsPHm1cpNt1EjitE9
	 XQu9yHEJGddqm7syTurN0VmWYbu7yBEKIEgP9gt2KL6EfD5RcfHZCLwkOIt/ird203g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712781;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=z66IJvRsxHOgUIzPPCi2BqeXwiNJpMUq53kMmMzM7i0=;
	b=ea30Eypbzb+ECKWAlZoxo0zUbvejsl0fwIck1wXgjFyHMFIJQweKkkPfmTngOXoYm4bH
	 1niqS/HQbmIbkNWET/Qww6yysnyAwaGRTSQX7Lp0arDjCPW2IVltIGpUHEhDrRNxX4OJE
	 tpeSiNLtvGrz9khQeBv1XGR5aBgNC1EVtJnJWdwSodIsbVtmIGfPQeOfhmFq8rXsBhuTk
	 kGIROvJTHZqVUuC32/ultiRzs+xsssmQifxh8kV+r9E6nTHz5i3+fM0ke3O1PWGqtybfU
	 p1lu6/flgKsaWjcGxt/U9iGmmUpoXCb1ZRnAbvKlopg4TYVUVTGxbU53dUQpQZTdRvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Nt/lkrxN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734B7606A32E;
	Tue,  3 Nov 2026 13:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nt/lkrxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15E1F00A25;
	Tue,  3 Nov 2026 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712781;
	bh=z66IJvRsxHOgUIzPPCi2BqeXwiNJpMUq53kMmMzM7i0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nt/lkrxNhGcb+EDFbGugnOKZjb0SLIRgQ1B8QtgrJ41MAx1rZ/Z0ZUdQBep+W3APx
	 SyR2j3I051Va5lIZ46oRbA9JAZZn45Zz0UQpcYcKuelmdOLA0Lnqtqg3XO8Z/0FTkK
	 ArFerxTRLwBhJhy2CKA0yTmlEJdCbJTt6UIaQ6xWzTF4gNym9Lkc0NPfJ9Xx99qenr
	 gF/lVBgpWt/15j/prwkQ8lBu7unWDVXIuDhKcuLYLV3UvCDL1/v20kuph1MO3e5Ihc
	 eDjAjU25T3/z+ur7QrnngZjgaDfAHkoFYi4BNVbUcrJn/gWzG72Bm/VOV/ZDuukHAI
	 qJKwnANsLlBmA==
Date: Tue, 3 Nov 2026 14:20:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yuqiang Sun <izaiahsun@gmail.com>
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
	guoqing.jiang@linux.dev, gi-oh.kim@ionos.com,
	aleksei.marov@ionos.com, lgs201920130244@gmail.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] RDMA/rtrs-srv: Do not free the path on path file
 creation failure
Message-ID: <20261103122024.GG264423@unreal>
References: <20261029042719.75868-1-izaiahsun@gmail.com>
 <20261029042719.75868-2-izaiahsun@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029042719.75868-2-izaiahsun@gmail.com>

On Thu, Oct 29, 2026 at 12:27:17PM +0800, Yuqiang Sun wrote:
> When rtrs_srv_create_path_files() fails after kobject_init_and_add() of
> srv_path->kobj, its error path ends with kobject_put(&srv_path->kobj),
> and the release, rtrs_srv_release(), frees srv_path.  The caller does
> not expect that: process_info_req() goes on to free its tx IU through
> srv_path->s.dev, and rtrs_srv_info_req_done() then closes the path,
> whose close work tears down the connections, puts the session and
> finally frees srv_path again in free_path().
> 
> Commit 5b7437339011 ("RDMA/rtrs: Fix use-after-free in path file
> creation cleanup") reordered the cleanup inside
> rtrs_srv_create_path_files() so that the helper runs before the put, but
> the final put still frees srv_path under the caller.  The same pattern
> exists one level down: rtrs_srv_create_stats_files() puts
> srv_path->stats->kobj_stats on failure, whose release frees
> srv_path->stats, which free_path() frees again.
> 
> With one allocation failure injected into kobject_init_and_add() of the
> path kobject (failslab restricted to rtrs_srv_create_path_files), KASAN
> reports while a client connects:
> 
>   BUG: KASAN: slab-use-after-free in rtrs_srv_info_req_done+0xe43/0x1740
>   Read of size 8 by task kworker/0:1H/84
>   Call Trace:
>    rtrs_srv_info_req_done
>    __ib_process_cq
>    ib_cq_poll_work
>   Freed by task 84:
>    kfree
>    kobject_put
>    rtrs_srv_create_path_files
>    rtrs_srv_info_req_done
> 
> These paths run in the server's completion worker when a client sends
> its info request, and are reached when allocating or creating the sysfs
> entries for the new path fails.
> 
> Keep srv_path and its stats owned by the caller on failure: the error
> paths only delete what they added, and free_path(), which runs in every
> case, drops the kobjects that were initialized but never made it into
> sysfs, so their releases free the structures; otherwise it frees them
> as before.  This keeps the kobject names from leaking, which is what the
> puts in the error paths were added for.
> 
> The problem was found with kbound, a static analysis prototype that
> checks whether callers rely on an object after a callee returns a value
> for which the callee may have released it, on v7.2.12; it is present in
> the rdma for-next branch.
> 
> Build-tested with x86_64 and arm64 allmodconfig (W=1, sparse): no new
> warnings.  Run-tested under KVM (KASAN, lockdep, kmemleak), failing the
> path or the stats kobject allocation with failslab during a client's
> connection: before this series KASAN reports use-after-free in
> rtrs_srv_info_req_done() and rtrs_srv_close_work() and a general
> protection fault follows; with this series nothing is reported, also
> with CONFIG_DEBUG_KOBJECT_RELEASE.  Failures of the two
> sysfs_create_group() calls were not injected.  With this patch alone,
> the close work still uses the session freed as described in the next
> patch.  Not tested on RDMA hardware.

Interesting claim. How did you trigger the KASAN warning in the RDMA ULP?

Thanks

> 
> Fixes: 424774c9f3fa ("RDMA/rtrs: Call kobject_put in the failure path")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5-5 kbound
> Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 16 +++++++---------
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 14 +++++++++++++-
>  2 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
> index 9dd9141c86a5..45ee07a98ca8 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
> @@ -238,25 +238,24 @@ static int rtrs_srv_create_stats_files(struct rtrs_srv_path *srv_path)
>  				   &srv_path->kobj, "stats");
>  	if (err) {
>  		rtrs_err(s, "kobject_init_and_add(): %pe\n", ERR_PTR(err));
> -		kobject_put(&srv_path->stats->kobj_stats);
>  		return err;
>  	}
>  	err = sysfs_create_group(&srv_path->stats->kobj_stats,
>  				 &rtrs_srv_stats_attr_group);
>  	if (err) {
>  		rtrs_err(s, "sysfs_create_group(): %pe\n", ERR_PTR(err));
> -		goto err;
> +		kobject_del(&srv_path->stats->kobj_stats);
> +		return err;
>  	}
>  
>  	return 0;
> -
> -err:
> -	kobject_del(&srv_path->stats->kobj_stats);
> -	kobject_put(&srv_path->stats->kobj_stats);
> -
> -	return err;
>  }
>  
> +/*
> + * On failure, the caller still owns srv_path and frees it in free_path(),
> + * which also drops the kobjects initialized here.  Do not put them here:
> + * their releases free srv_path and srv_path->stats.
> + */
>  int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
>  {
>  	struct rtrs_srv_sess *srv = srv_path->srv;
> @@ -296,7 +295,6 @@ int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
>  	kobject_del(&srv_path->kobj);
>  destroy_root:
>  	rtrs_srv_destroy_once_sysfs_root_folders(srv_path);
> -	kobject_put(&srv_path->kobj);
>  
>  	return err;
>  }
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> index 5314599d29fe..641a7bf5e02c 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
> @@ -1584,11 +1584,23 @@ static void free_path(struct rtrs_srv_path *srv_path)
>  	if (srv_path->kobj.state_in_sysfs) {
>  		kobject_del(&srv_path->kobj);
>  		kobject_put(&srv_path->kobj);
> +		return;
> +	}
> +
> +	/*
> +	 * rtrs_srv_create_path_files() may have failed after initializing
> +	 * these kobjects; then their releases free the structures.
> +	 */
> +	if (srv_path->stats->kobj_stats.state_initialized) {
> +		kobject_put(&srv_path->stats->kobj_stats);
>  	} else {
>  		free_percpu(srv_path->stats->rdma_stats);
>  		kfree(srv_path->stats);
> -		kfree(srv_path);
>  	}
> +	if (srv_path->kobj.state_initialized)
> +		kobject_put(&srv_path->kobj);
> +	else
> +		kfree(srv_path);
>  }
>  
>  static void rtrs_srv_close_work(struct work_struct *work)
> 
> base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
> -- 
> 2.53.0
> 
