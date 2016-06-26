From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 0/2] Get rid of transport layer retry count config
 parameter
Date: Sun, 26 Jun 2016 18:48:26 +0300
Message-ID: <576FF94A.3040705@grimberg.me>
References: <1466597161-5242-1-git-send-email-sagi@grimberg.me>
 <20160622161559.GA18361@infradead.org>
 <20160622203110.GA20838@obsidianresearch.com> <576B8B30.8080402@grimberg.me>
 <20160624071336.GE4252@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160624071336.GE4252-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Completely agree Jason. Lowering the retry_count is very useful
>> for APM (Automatic Path Migration).
>
> Does this mean you're retracting the patches?

I'm not, were not using APM anywhere in nvme-rdma. multipathing
is done at a higher level than the transport.

Do you see a reason to keep this? I'm not too enthusiast with leaving
configs that aren't absolutely needed. As mentioned this config was
added to add a fast-fail functionality before we defined the periodic 
keep-alive...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
