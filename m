From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 4/4] ibacm: Use MONOTONIC time base to avoid timer
 expiration issues
Date: Tue, 14 Nov 2017 16:56:25 -0700
Message-ID: <20171114235625.GF25894@ziepe.ca>
References: <20171114164006.24557.72093.stgit@phlsvslse11.ph.intel.com>
 <20171114164352.24557.86825.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114164352.24557.86825.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 11:44:17AM -0500, Michael J. Ruhl wrote:
>  static inline int event_wait(event_t *e, int timeout)
>  {
> -	struct timeval curtime;
>  	struct timespec wait;
>  	int ret;
>  
> -	gettimeofday(&curtime, NULL);
> -	wait.tv_sec = curtime.tv_sec + ((unsigned) timeout) / 1000;
> -	wait.tv_nsec = (curtime.tv_usec + (((unsigned) timeout) % 1000) * 1000) * 1000;
> +	clock_gettime(CLOCK_MONOTONIC, &wait);
> +	wait.tv_sec = wait.tv_sec + ((unsigned int) timeout) / 1000;
> +	wait.tv_nsec = (wait.tv_nsec + (((unsigned int) timeout) % 1000) * 1000000);

since timeout must be positive just declare it as 'unsigned int' in the
function signature and all the ugly casts go away and the function
argument range is now documented..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
