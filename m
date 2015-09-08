From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Tue, 8 Sep 2015 06:14:07 -0700
Message-ID: <20150908131407.GB5316@infradead.org>
References: <20150906064550.GA30683@infradead.org>
 <55EED54B.7090608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55EED54B.7090608-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 08, 2015 at 03:32:11PM +0300, Sagi Grimberg wrote:
> The CM is responsible of establishing an RDMA channel. What you are
> referring to is a concept of a session. I'm not entirely sure how we can
> fit a model where the CM establishes a multi-channel session as the
> CM request contains a (single) source QPN. So there is a 1-1
> relationship between a cm_id and a queue-pair. The device handle depends
> on the address resolution to the end-node.
> 
> I assume we can think of some form of an rdma_session which will manage
> multiple cm_id's (that belongs to a single address resolution), call
> the ULP to allocate their corresponding queue-pairs and send a connect
> request for each one. Such an rdma_session can verify the same ib_device
> handle on all the cm_id's. But I'm not sure how such a concept would
> impact on aspects such as event handling etc...

What I'm more interested in is a way to tell the CM that I only
want routes that are using this ib_device that I got from the first
lookup as all others are useless for me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
