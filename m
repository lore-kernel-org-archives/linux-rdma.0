From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/iser: Support up to 8MB data transfer in a
 single command
Date: Thu, 30 Jul 2015 15:23:47 +0300
Message-ID: <55BA1753.7030802@dev.mellanox.co.il>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-21-git-send-email-sagig@mellanox.com>
 <CAJ3xEMjjzrezJ6UEH3rGD5Qu7DPLQM4Lw-JnOFrEvhLGd90spA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjjzrezJ6UEH3rGD5Qu7DPLQM4Lw-JnOFrEvhLGd90spA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/30/2015 1:22 PM, Or Gerlitz wrote:
> On Thu, Jul 30, 2015 at 11:06 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> iser support up to 512KB data transfer in a single scsi
>> command. In order to support up to 8MB, iser needs to pre-allocate
>> larger memory regions and larger page vectors.
>
>
> We should be doing things for a reason, and we are following that
> practice, it's missing.
>
> I believe we have nice motivation to put here for why we want to do
> that. Please add it.

Sure.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
