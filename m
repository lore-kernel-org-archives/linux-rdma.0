From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Leak in rdma_get_cm_event on pthread_cancel?
Date: Mon, 16 Jan 2012 15:35:41 -0700
Message-ID: <20120116223541.GA2892@obsidianresearch.com>
References: <4F101978.6010608@list-group.com>
 <20120113175925.GE6798@obsidianresearch.com>
 <4F13E3ED.3010708@list-group.com>
 <CAJZOPZ+ik7DdXJHbEyr-PKyOQ3yEoWa6H=rhEe4cwc__61DUrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZ+ik7DdXJHbEyr-PKyOQ3yEoWa6H=rhEe4cwc__61DUrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2012 at 12:15:23AM +0200, Or Gerlitz wrote:
> Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org> wrote:
> > what is then the proper way to stop a thread blocked on
> > rdma_get_cm_event() (or on ibv_get_cq_event())?
> 
> Oh, this is simple - don't get there... have your code
> 
> 1. get the FDs associated with IB - which you can retrieve from
> librdmacm and from libibverbs
> 
> 2. make them non blocking
> 
> 3. add them to you select/poll  FD group

4. Use an eventfd or otherwise to break out of the select/poll loop
and then exit your thread.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
