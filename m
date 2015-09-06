From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Sun, 6 Sep 2015 00:50:24 -0700
Message-ID: <20150906075024.GA7845@infradead.org>
References: <20150906064550.GA30683@infradead.org>
 <CAG53R5VZDZKiuR-jLybS1PhrT9K4GG6xTr8bOG-L0VaQgqEXSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5VZDZKiuR-jLybS1PhrT9K4GG6xTr8bOG-L0VaQgqEXSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 06, 2015 at 01:12:56PM +0530, Parav Pandit wrote:
> Hi Christoph,
> 
> Establishing multiple QP is just one part of it.
> Bigger challenge is how do we distribute the work request among
> multiple QPs

For my case I simply rely on the blk-mq layer to have cpu-local queues,
so that's a somewhat solved issue as long as you are fine with the
usage model.  If your usage is skewed heavily towards certain CPUs
it might be a little suboptimal.

Note that the SRP driver already in tree is a good example for this,
although it doesn't use RDMA/CM and thus already operates on a
per-ib_device level.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
