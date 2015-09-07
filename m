From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Sun, 6 Sep 2015 22:08:42 -0700
Message-ID: <20150907050842.GA30020@infradead.org>
References: <20150906064550.GA30683@infradead.org>
 <CAG53R5VZDZKiuR-jLybS1PhrT9K4GG6xTr8bOG-L0VaQgqEXSA@mail.gmail.com>
 <20150906075024.GA7845@infradead.org>
 <CAG53R5UsH3aEmRf2EgNYydJ=cMZCFG19ZQjHcLn=NjQxsnwf-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5UsH3aEmRf2EgNYydJ=cMZCFG19ZQjHcLn=NjQxsnwf-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 06, 2015 at 01:24:52PM +0530, Parav Pandit wrote:
> Yes. SRP is good example. The point I am trying to make is, SRP
> implements failover and request spreading where one QP fails it
> delivers to other QP.

But SRP doesn't implement that.  There are no fail over capabilities
in a single SRP session even with multiple QPs, and the spreading
is implemented by a higher layer, namely blk-mq, which is common code
for all block drivers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
