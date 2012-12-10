From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] [RFC] osm_log printing incorrectly assumes that
 pthread_t is not opaque type
Date: Sun, 9 Dec 2012 23:10:21 -0700
Message-ID: <20121210061021.GB30472@obsidianresearch.com>
References: <alpine.BSF.2.00.1212090125590.64779@toaster.local>
 <75EE638CB68A864F90627D3D06A189A859350715@MTRDAG01.mtl.com>
 <CAGH67wQ=-Mn3_HMy7=VOT2am99qbjrXcOpC6+_PCSW6xuyVvRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGH67wQ=-Mn3_HMy7=VOT2am99qbjrXcOpC6+_PCSW6xuyVvRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 09, 2012 at 11:56:55AM -0800, Garrett Cooper wrote:

> > One reason to use "sort of thread id" would be to determine specific flows,
> > when looking through the log. Why it's important to use async-safe functions
> > in that case?
> 
> Seems reasonable (and that was my guess, but I wanted to check :)..).

There is no such thing as a 'thread id integer' in posix land. If you
want to number your threads then you need to use a thread local
variable to do it. That is probably alot cheaper than calling gettid
anyhow..

On Linux there is some value to using tid's for your ids because you
can strace that tid individually if you want, but I can't think of
many other uses..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
