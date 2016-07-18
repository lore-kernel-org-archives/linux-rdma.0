From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Get rid of transport layer retry count config
 parameter
Date: Mon, 18 Jul 2016 08:20:54 -0700
Message-ID: <12b64608-1d42-ffe6-c11a-58139cbabd3a@sandisk.com>
References: <1466597161-5242-1-git-send-email-sagi@grimberg.me>
 <20160622161559.GA18361@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160622161559.GA18361-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/22/2016 09:15 AM, Christoph Hellwig wrote:
> On Wed, Jun 22, 2016 at 03:05:59PM +0300, Sagi Grimberg wrote:
>> This parameter was added in order to support a proper timeout for
>> error recovery before the spec defined a periodic keep-alive.
>>
>> Now that we have periodic keep-alive, we don't need a user configurable
>> transport layer retry count, the keep-alive timeout is sufficient,
>> transports can retry for as long as they see fit.
>
> Isn't there some IB protocol level rationale for a low retry count
> in various fabric setups?

The IB spec defines an end-to-end credit mechanism for RC connections. 
So if the transport layer is reliable (InfiniBand, RoCE with DCB 
enabled) setting the retry count high enough is only needed to avoid 
connection shutdown due to brief cable disconnect/reconnect events.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
