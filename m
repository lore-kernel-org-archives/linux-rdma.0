From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/15] IB/srpt: Fix srpt_close_session()
Date: Wed, 6 Jan 2016 15:34:01 +0100
Message-ID: <568D25D9.3050809@sandisk.com>
References: <568BD0FC.70207@sandisk.com> <568BD231.10205@sandisk.com>
 <568D22F6.4050803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568D22F6.4050803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/06/2016 03:21 PM, Sagi Grimberg wrote:
>> Avoid that srpt_close_session() waits if it doesn't have to wait.
>
> Can you explain when it doesn't have to wait? is it possible that
> srpt_release_channel_work() was already triggered? isn't that a problem?

Hello Sagi,

The target core can decide to shut down an RDMA channel or a channel 
shutdown can be the result of the reception of a DREQ message. It is in 
the latter case that srpt_release_channel_work() can have finished 
before srpt_close_session() is called.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
