From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nvme-rdma: don't complete requests before a
        send work request has completed
Date: Mon, 20 Nov 2017 09:41:02 +0100
Message-ID: <20171120084102.GA28456@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-3-sagi@grimberg.me> <20171109092110.GB16966@lst.de> <0f368bc9-2e9f-4008-316c-46b85661a274@grimberg.me> <20171120083130.GC27552@lst.de> <384d8a51-aa2f-5954-c9fd-a0c88d7e5364@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <384d8a51-aa2f-5954-c9fd-a0c88d7e5364-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 10:37:54AM +0200, Sagi Grimberg wrote:
>
>> Both send and recv completed only ever go from not set to set on a live
>> requests, so that's easy.  need_inval only goes from set to cleared
>> so I'm not too worried about it either, but due to the lack of atomic
>> bitops there it will need better memory barries, or just a switch
>> to bitops..
>>
>> But looking at this in a little more detail I wonder if we just want
>> a recount on the nvme_rdma_request, untested patch below.
>
> I'll give it a shot.

Btw, in our brave new world that should probably be a refcnt_t instead
of an atomic_t, but that's a trivial search and replace.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
