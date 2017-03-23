From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] fix udma_to_device_barrier on aarch64
Date: Thu, 23 Mar 2017 11:00:44 -0600
Message-ID: <20170323170044.GF29811@obsidianresearch.com>
References: <20170323021224.35722-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323021224.35722-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 22, 2017 at 10:12:24PM -0400, Jarod Wilson wrote:
> The definition for udma_to_device_barrier on aarch64 is missing. Looks
> like an oversight in the commit that removed the old barrier macros and
> added this one.
> 
> Fixes: 85a5529dead5 ("Remove the old barrier macros")
> CC: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  util/udma_barrier.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/util/udma_barrier.h b/util/udma_barrier.h
> index 86578af5..9932a687 100644
> +++ b/util/udma_barrier.h
> @@ -93,7 +93,7 @@
>  #elif defined(__sparc_v9__)
>  #define udma_to_device_barrier() asm volatile("membar #StoreStore" ::: "memory")
>  #elif defined(__aarch64__)
> -#define wmb() asm volatile("dsb st" ::: "memory");
> +#define udma_to_device_barrier() asm volatile("dsb st" ::: "memory");
>  #elif defined(__sparc__) || defined(__s390x__)
>  #define udma_to_device_barrier() asm volatile("" ::: "memory")
>  #else

Doh, yep my bad.

https://github.com/linux-rdma/rdma-core/pull/106

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
