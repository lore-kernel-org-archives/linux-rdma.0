From: Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>
Subject: Re: [PATCH 0/2] Get rid of transport layer retry count config
 parameter
Date: Wed, 22 Jun 2016 19:31:59 +0300
Message-ID: <576ABD7F.1030204@grimberg.me>
References: <1466597161-5242-1-git-send-email-sagi@grimberg.me>
 <20160622161559.GA18361@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160622161559.GA18361-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> This parameter was added in order to support a proper timeout for
>> error recovery before the spec defined a periodic keep-alive.
>>
>> Now that we have periodic keep-alive, we don't need a user configurable
>> transport layer retry count, the keep-alive timeout is sufficient,
>> transports can retry for as long as they see fit.
>
> Isn't there some IB protocol level rationale for a low retry count
> in various fabric setups?

None that I know of... The QP retry count determines the time it would
take to fail a send/read/write.. The retry_count value is multiplied
with the packet timeout (which is a result of an IB specific
computation - managed by the CM).

It's useful when one needs to limit the time until a send fails in order
to kick error recovery (useful for srp which doesn't implement periodic
keep-alive), but since nvme does, I don't see the reason why RDMA or any
other transport should expose this configuration as the keep-alive
timeout exists for that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
