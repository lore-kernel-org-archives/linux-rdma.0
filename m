From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Wed, 6 Apr 2016 16:16:58 -0700
Message-ID: <20160406231658.GB11588@infradead.org>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me>
 <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org>
 <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org>
 <570548AB.4090802@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570548AB.4090802-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 06, 2016 at 08:34:35PM +0300, sagig wrote:
> So this scatterlist seems perfectly fine (no gaps). The only thing I
> can think of is that we don't have enough space reserved, but I counted
> 127 pages in the scatterlist when iser reserves 128 (by default).
> 
> Just in case I mis-counted, can you (or Max) try with the below
> patch:

This works fine for me, but I wonder if the miscounting is in the
block layer?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
