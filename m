From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 01 Feb 2012 16:13:33 -0500 (EST)
Message-ID: <20120201.161333.2203265702893105548.davem@davemloft.net>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
	<CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 1 Feb 2012 13:04:58 -0800

> Perhaps we could do some RCU-ish thing where we don't actually
> free the ipoib_neigh immediately?

RCU could be used to fix the race, but the difficulty in converting
this code over to dst_lookup_neigh() would remain and the latter is
more important to me than the former right now :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
