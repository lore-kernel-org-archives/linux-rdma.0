From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Tue, 20 Oct 2015 16:08:54 +0300
Message-ID: <56263CE6.5010005@dev.mellanox.co.il>
References: <1444633078-27166-1-git-send-email-hch@lst.de>
 <561B7CAE.3040505@dev.mellanox.co.il> <20151012144212.GB24770@lst.de>
 <56262CF9.1040509@dev.mellanox.co.il>
 <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I think this is very useful to have and I'd love having it in 4.4,
>> does anyone have any other comments on this patch?
>
> Were we ever presented with performance gains achieved using the patch?

Hi Or,

Can you explain what you mean by performance gains? My understanding is
that this patch is not performance critical. It just replaces each and
every ULP device attributes caching.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
