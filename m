From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Thu, 7 Apr 2016 08:20:12 -0700
Message-ID: <20160407152012.GA10297@infradead.org>
References: <5702A46F.5070109@grimberg.me>
 <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org>
 <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org>
 <570548AB.4090802@grimberg.me>
 <20160406231658.GB11588@infradead.org>
 <570608C9.1070805@grimberg.me>
 <570623B9.8040108@mellanox.com>
 <570679B6.10409@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570679B6.10409-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 07, 2016 at 06:16:06PM +0300, Sagi Grimberg wrote:
> >>segment (which results in an extra page). The patch should fix the
> >>problem, however in this particular sg list I don't see the violation
> >>(counted 127 pages)...
> >
> >I counted 129 pages.
> >I will run some tests in our labs too.
> 
> If you did then that indicates the block layer violates
> its obligation to respect max_segments/max_hw_sectors?

I spent some time looking over the code and remembered an issue I
fixed for NVMf (which might explain why we're not seeing it there).

max_segments just means contiguous segments, not nessecarily 4k
pages.  For that we either need a small enough max_sectors_hw or set
a max_segment_size of 4k, otherwise we might get 128 block segments,
but due to lacking alignment they'll expand to 129 pages.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
