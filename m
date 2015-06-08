From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Mon, 8 Jun 2015 16:39:23 +0300
Message-ID: <55759B0B.8050805@mellanox.com>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <20150608132254.GA14773@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150608132254.GA14773-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/8/2015 4:22 PM, Christoph Hellwig wrote:
> On Mon, Jun 08, 2015 at 04:15:34PM +0300, Sagi Grimberg wrote:
>> There are couple of possible (sub-optimal) solutions to handle this limitation:
>
> There is another one:  Set the block level SG_GAPS flags to ensure
> the block layer never generates these SG lists.
>

Hi Christoph,

I have learned about QUEUE_FLAG_SG_GAPS from your recent comments on
the list. Won't setting this flag interfere with bio merges? Ideally
I wouldn't want to restrict merges if my device supports this feature.

> Right now drivers tat set these would always fail SG_IO ioctls using
> iovecs, but that can be fixed much more easily by doing high level
> bounce buffering compared to these horrible workarounds deep down in the
> stack.
>

My tests have shown significant cpu savings with this against SW bounce
buffering, especially for large transfers. I've seen applications that
a significant part of their IO workload consists of this type of memory
layout.

I must say that I've always considered SW bounce buffering as a
work-around for an RDMA driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
