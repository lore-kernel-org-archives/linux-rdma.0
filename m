From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] libibumad: clean up htonll/ntohnll handling
Date: Wed, 24 May 2017 10:33:01 -0600
Message-ID: <20170524163301.GA7054@obsidianresearch.com>
References: <20170522141722.50502-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170522141722.50502-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 22, 2017 at 10:17:22AM -0400, Jarod Wilson wrote:
> Only ntohll was being checked to see if it wasn't defined, and was then
> redefining htonll as well as ntohll. This was causing some problems for
> the compile of the opa-ff package. Simple enough to rearrange this code a
> bit such that htonll and ntohll are handled entirely independent of one
> another.

What problem did this cause?

> +/* Users should use the glibc functions directly, not these wrappers */
>  #ifndef ntohll
> -#undef htonll
>  #undef ntohll
> -/* Users should use the glibc functions directly, not these wrappers */
> -static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
>  static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
> -#define htonll htonll
>  #define ntohll ntohll
>  #endif
> +#ifndef htonll
> +#undef htonll

Both these undefs are not needed anymore.

Seems fine to me, if not weird that something would have a problem
here.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
