From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Leak in rdma_get_cm_event on pthread_cancel?
Date: Fri, 13 Jan 2012 10:59:25 -0700
Message-ID: <20120113175925.GE6798@obsidianresearch.com>
References: <4F101978.6010608@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F101978.6010608-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 13, 2012 at 12:46:00PM +0100, Flavio Baronti wrote:
> When I want to stop the thread reading rdma events, I kill it with a
> pthread_cancel(), since it is blocked in a rdma_get_cm_event(). This
> causes a leak of the evt variable in the rdma_get_cm_event()
> function. Not a big deal, of course, but a couple of
> pthread_cleanup_push(free, evt) and pthread_cleanup_pop() should
> solve it.

None of the IB libraries have been audited for posix async cancellation
safety.

To do this work someone would have to review every call to determine
if it is a cancelation point, and document this as part of the API.

Then review if any of the internal cancelation points in the
cancelable functions require a resource clean up, and add it.

IHMO, cancelation should not be used with threads that call into the
ib libraries.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
