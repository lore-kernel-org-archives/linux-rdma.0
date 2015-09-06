From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Sun, 6 Sep 2015 13:24:52 +0530
Message-ID: <CAG53R5UsH3aEmRf2EgNYydJ=cMZCFG19ZQjHcLn=NjQxsnwf-g@mail.gmail.com>
References: <20150906064550.GA30683@infradead.org>
	<CAG53R5VZDZKiuR-jLybS1PhrT9K4GG6xTr8bOG-L0VaQgqEXSA@mail.gmail.com>
	<20150906075024.GA7845@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150906075024.GA7845-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 6, 2015 at 1:20 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Sun, Sep 06, 2015 at 01:12:56PM +0530, Parav Pandit wrote:
>> Hi Christoph,
>>
>> Establishing multiple QP is just one part of it.
>> Bigger challenge is how do we distribute the work request among
>> multiple QPs
>
> For my case I simply rely on the blk-mq layer to have cpu-local queues,
> so that's a somewhat solved issue as long as you are fine with the
> usage model.  If your usage is skewed heavily towards certain CPUs
> it might be a little suboptimal.
>
> Note that the SRP driver already in tree is a good example for this,
> although it doesn't use RDMA/CM and thus already operates on a
> per-ib_device level.

Yes. SRP is good example. The point I am trying to make is, SRP
implements failover and request spreading where one QP fails it
delivers to other QP.
So one Session spans across multiple transport QP connections.
Similarly we every ULP needs to implement such functionalities.
Instead there could be single such transport mid layer who should do it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
