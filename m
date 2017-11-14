From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 4/4] ibacm: Use MONOTONIC time base to avoid timer
 expiration issues
Date: Mon, 13 Nov 2017 20:04:14 -0700
Message-ID: <20171114030414.GP22610@ziepe.ca>
References: <20171113212220.24293.97479.stgit@phlsvslse11.ph.intel.com>
 <20171113212454.24293.68783.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113212454.24293.68783.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 13, 2017 at 04:25:04PM -0500, Michael J. Ruhl wrote:

Sorry, noticed a few more wonky things:

>  #define event_signal(e)	pthread_cond_signal(&(e)->cond)
>  #define ONE_SEC_IN_NSEC  1000000000

That should be 1000000000ULL so math doesn't accidental truncate

> +	clock_gettime(CLOCK_MONOTONIC, &wait);
> +	wait.tv_sec = wait.tv_sec + ((unsigned) timeout) / 1000;
> +	wait.tv_nsec = (wait.tv_nsec + (((unsigned) timeout) % 1000) * 1000000);

Why the odd casts to (unsigned) ? That should be (unsigned int)

> -	return (uint64_t) curtime.tv_sec * 1000000 + (uint64_t) curtime.tv_usec;
> +	struct timespec t;
> +	clock_gettime(CLOCK_MONOTONIC, &t);
> +	return ((uint64_t)t.tv_sec * ONE_SEC_IN_NSEC + (uint64_t)t.tv_nsec) / 1000;

These casts to uint64_t are also wrong, time is technically
signed. The change to ONE_SEC_IN_NSEC should remove the need
for the casting.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
