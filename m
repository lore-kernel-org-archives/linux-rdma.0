From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 27/62] infiniband/ipath: convert to idr_alloc()
Date: Mon, 4 Feb 2013 08:18:29 -0800
Message-ID: <20130204161829.GA27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-28-git-send-email-tj@kernel.org>
 <32E1700B9017364D9B60AED9960492BC0D58DDB2@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D58DDB2-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org" <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org" <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

On Mon, Feb 04, 2013 at 04:15:52PM +0000, Marciniszyn, Mike wrote:
> I tried the branch you indicated in the initial patch cover.
> 
> When run with a qib driver, and ipoib ping of another system produces:
...
> Looks like this is tripping during the arp/neighbour path resolution:
> 
> void idr_preload(gfp_t gfp_mask)
> {
>     /*
>      * Consuming preload buffer from non-process context breaks preload
>      * allocation guarantee.  Disallow usage from those contexts.
>      */
>     WARN_ON_ONCE(in_interrupt()); <------------------------
> 
> Any ideas Roland?

Yeah, firewire had the same problem.  It needs to conditionalize
preload() if !__GFP_WAIT (no point anyway).  Will send update patches
soon.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
