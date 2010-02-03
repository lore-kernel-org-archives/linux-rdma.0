From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3] opensm/complib/cl_passivelock.h: some casting issues
Date: Wed, 3 Feb 2010 12:51:56 +0200
Message-ID: <20100203105156.GY26338@me>
References: <4B682772.2070304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B682772.2070304-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

On 15:24 Tue 02 Feb     , Yevgeny Kliteynik wrote:
> 
> There are couple of problematic castings in complib/cl_passivelock.h:
> 
> (cl_status_t) pthread_rwlock_*()
> 
> Turns out that compiler doesn't like casting directly from
> int to enum, probably because int can be negative:
> 
> cl_passivelock.h:199: warning: cast from function call of type 'int' to non-matching type 'enum _cl_status'
> cl_passivelock.h:241: warning: cast from function call of type 'int' to non-matching type 'enum _cl_status'
> cl_passivelock.h:274: warning: cast from function call of type 'int' to non-matching type 'enum _cl_status'
> cl_passivelock.h:306: warning: cast from function call of type 'int' to non-matching type 'enum _cl_status'
> 
> Se we need to cast the return value in two stages:
> to unsigned, and then to enum.

Instead of bothering with ugly integer casting (and so ugly
double/triple/etc casting...) would not it be better to just convert
cl_status_t to int?

Something like:

typedef int cl_status_t;

#define CL_SUCCESS 0
#define CL_BLAHBLAH -1
...

Sasha

> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
> 
> Changes from v2: can't do implicit casting from unsigned
>                  to enum, so specifying it explicitly.
> 
>  opensm/include/complib/cl_passivelock.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/opensm/include/complib/cl_passivelock.h b/opensm/include/complib/cl_passivelock.h
> index bafd339..aba4e64 100644
> --- a/opensm/include/complib/cl_passivelock.h
> +++ b/opensm/include/complib/cl_passivelock.h
> @@ -196,7 +196,7 @@ static inline cl_status_t cl_plock_init(IN cl_plock_t * const p_lock)
>  	cl_status_t status;
> 
>  	CL_ASSERT(p_lock);
> -	status = (cl_status_t) pthread_rwlock_init(&p_lock->lock, NULL);
> +	status = (cl_status_t)(unsigned) pthread_rwlock_init(&p_lock->lock, NULL);
>  	if (status)
>  		return CL_ERROR;
>  	p_lock->state = CL_INITIALIZED;
> @@ -238,7 +238,7 @@ static inline void cl_plock_acquire(IN cl_plock_t * const p_lock)
>  	CL_ASSERT(p_lock);
>  	CL_ASSERT(p_lock->state == CL_INITIALIZED);
> 
> -	status = (cl_status_t) pthread_rwlock_rdlock(&p_lock->lock);
> +	status = (cl_status_t)(unsigned) pthread_rwlock_rdlock(&p_lock->lock);
>  	CL_ASSERT(status == 0);
>  }
> 
> @@ -271,7 +271,7 @@ static inline void cl_plock_excl_acquire(IN cl_plock_t * const p_lock)
>  	CL_ASSERT(p_lock);
>  	CL_ASSERT(p_lock->state == CL_INITIALIZED);
> 
> -	status = (cl_status_t) pthread_rwlock_wrlock(&p_lock->lock);
> +	status = (cl_status_t)(unsigned) pthread_rwlock_wrlock(&p_lock->lock);
>  	CL_ASSERT(status == 0);
>  }
> 
> @@ -303,7 +303,7 @@ static inline void cl_plock_release(IN cl_plock_t * const p_lock)
>  	CL_ASSERT(p_lock);
>  	CL_ASSERT(p_lock->state == CL_INITIALIZED);
> 
> -	status = (cl_status_t) pthread_rwlock_unlock(&p_lock->lock);
> +	status = (cl_status_t)(unsigned) pthread_rwlock_unlock(&p_lock->lock);
>  	CL_ASSERT(status == 0);
>  }
> 
> -- 
> 1.5.1.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
