From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Remove duplicate sync_res shutdown
Date: Tue, 19 Dec 2017 14:28:18 -0700
Message-ID: <20171219212818.GG14800@mellanox.com>
References: <20171219211601.GA27412@ziepe.ca>
 <1513718464.2535.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513718464.2535.16.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 09:21:05PM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-19 at 14:16 -0700, Jason Gunthorpe wrote:
> > The very first thing free_res does is the same lock/signal/unlock
> > sequence, so there is no reason to open code it before calling
> > free_res.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  srp_daemon/srp_daemon.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > Noticed while looking at honli's patch.. Didn't make a PR.
> > 
> > diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> > index cec36db2e0f12e..a1798558373490 100644
> > +++ b/srp_daemon/srp_daemon.c
> > @@ -2074,10 +2074,6 @@ static int ibsrpdm(int argc, char *argv[])
> >  		pr_err("Querying SRP targets failed\n");
> >  
> >  	assert(res->sync_res);
> > -	pthread_mutex_lock(&res->sync_res->retry_mutex);
> > -	res->sync_res->stop_threads = 1;
> > -	pthread_cond_signal(&res->sync_res->retry_cond);
> > -	pthread_mutex_unlock(&res->sync_res->retry_mutex);
> 
> Hello Jason,
> 
> Since this patch removes all code that dereferences res->sync_res from
> the ibsrpdm() function, have you considered to remove assert(res->sync_res)
> too?

Well, that would be a behavior change.. free_res works OK if sync_res
is NULL, so I'm guessing that the assert had some meaning to show that
the reconnect_thread was always started for ibsrpd?

Or maybe we shouldn't care about that?

Happy to drop it if you think it makes sense.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
