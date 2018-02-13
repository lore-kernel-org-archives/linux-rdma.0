From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 12/15] IB/uverbs: Tidy lockdep_check
Date: Tue, 13 Feb 2018 12:10:35 -0500
Message-ID: <1120b3ff-8cb4-d661-60b1-e1f7656840fd@intel.com>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-13-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-13-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This is really being used as an asssert that the expected usecnt
> is being held and implicitly that the usecnt is valid. Rename it to
> assert_uverbs_usecnt and tighten the checks to only accept valid
> values of usecnt (eg 0 and < -1 are invalid).
> 
> Fixes: 3832125624b7 ("IB/core: Add support for idr types")
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>   drivers/infiniband/core/rdma_core.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> index 3ec5c7926f1c..7aee1c0b9884 100644
> --- a/drivers/infiniband/core/rdma_core.c
> +++ b/drivers/infiniband/core/rdma_core.c
> @@ -412,13 +412,13 @@ static int __must_check remove_commit_fd_uobject(struct ib_uobject *uobj,
>   	return ret;
>   }
>   
> -static void lockdep_check(struct ib_uobject *uobj, bool exclusive)
> +static void assert_uverbs_usecnt(struct ib_uobject *uobj, bool exclusive)
>   {
>   #ifdef CONFIG_LOCKDEP
>   	if (exclusive)
> -		WARN_ON(atomic_read(&uobj->usecnt) > 0);
> +		WARN_ON(atomic_read(&uobj->usecnt) != -1);
>   	else
> -		WARN_ON(atomic_read(&uobj->usecnt) == -1);
> +		WARN_ON(atomic_read(&uobj->usecnt) <= 0);
>   #endif
>   }
>   
> @@ -457,7 +457,7 @@ int __must_check rdma_remove_commit_uobject(struct ib_uobject *uobj)
>   		WARN(true, "ib_uverbs: Cleanup is running while removing an uobject\n");
>   		return 0;
>   	}
> -	lockdep_check(uobj, true);
> +	assert_uverbs_usecnt(uobj, true);
>   	ret = _rdma_remove_commit_uobject(uobj, RDMA_REMOVE_DESTROY);
>   
>   	up_read(&ucontext->cleanup_rwsem);
> @@ -487,7 +487,7 @@ int rdma_explicit_destroy(struct ib_uobject *uobject)
>   		WARN(true, "ib_uverbs: Cleanup is running while removing an uobject\n");
>   		return 0;
>   	}
> -	lockdep_check(uobject, true);
> +	assert_uverbs_usecnt(uobject, true);
>   	ret = uobject->type->type_class->remove_commit(uobject,
>   						       RDMA_REMOVE_DESTROY);
>   	if (ret)
> @@ -541,7 +541,7 @@ int rdma_alloc_commit_uobject(struct ib_uobject *uobj)
>   	}
>   
>   	/* matches atomic_set(-1) in alloc_uobj */
> -	lockdep_check(uobj, true);
> +	assert_uverbs_usecnt(uobj, true);
>   	atomic_set(&uobj->usecnt, 0);
>   
>   	uobj->type->type_class->alloc_commit(uobj);
> @@ -578,7 +578,7 @@ static void lookup_put_fd_uobject(struct ib_uobject *uobj, bool exclusive)
>   
>   void rdma_lookup_put_uobject(struct ib_uobject *uobj, bool exclusive)
>   {
> -	lockdep_check(uobj, exclusive);
> +	assert_uverbs_usecnt(uobj, exclusive);
>   	uobj->type->type_class->lookup_put(uobj, exclusive);
>   	/*
>   	 * In order to unlock an object, either decrease its usecnt for
> 

-rc material?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
