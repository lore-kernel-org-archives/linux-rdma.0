From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Fri, 15 Dec 2017 09:36:28 +0800
Message-ID: <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
References: <20171214110241.4701-1-honli@redhat.com>
 <1513263572.2986.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513263572.2986.2.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 14, 2017 at 02:59:34PM +0000, Bart Van Assche wrote:
> On Thu, 2017-12-14 at 19:02 +0800, Honggang LI wrote:
> > fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
> > default signal handler will be used when it receives signal SIGINT.
> > ibsrpdm will exit with non-zero exit code as default signal handler
> > killed it.
> 
> Can you explain why you think that ibsrpdm needs a signal handler?

main
  ibsrpdm
    alloc_res
      pthread_create(&res->res.async_ev_thread [1]
    ....
    free_res
      if (res->async_ev_thread) { pthread_kill(res->async_ev_thread, SIGINT); [2]


The ibsrpdm program create a thread in [1], and send a SIGINT in [2].
The default behavior of SIGINT is to terminate the process.

According to the man page of pthread_kill:
 Signal dispositions are process-wide: if a signal handler is installed,
 the handler will be invoked in the thread _thread_, but if the disposition 
 of the signal is "stop", "continue", or "terminate", this action will 
 affect the whole process.

If we did not install a signal handler for ibsrpdm, ibsrpdm will be
terminated in [2], when it free the resource. ibsrpdm expected to return
to the main program after it free the resource. However, it failed as it
killed by default signal handler.

> 
> > ibsrpdm should return with exit code zero, if no error emerged.
> 
> That's correct, but if it was interrupted by a signal handler an error
> code should be returned.
> 
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
