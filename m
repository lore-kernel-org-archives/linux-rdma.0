From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 22/22] IB/iser: Chain all iser transaction send work
 requests
Date: Thu, 30 Jul 2015 15:36:34 +0300
Message-ID: <55BA1A52.5090906@dev.mellanox.co.il>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-23-git-send-email-sagig@mellanox.com>
 <CAJ3xEMhtEuf4y0=1XyC7qNRLWHSb2Bke46cZTB-QTgOhjxg-Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhtEuf4y0=1XyC7qNRLWHSb2Bke46cZTB-QTgOhjxg-Ow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/30/2015 1:27 PM, Or Gerlitz wrote:
> On Thu, Jul 30, 2015 at 11:06 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Concatination of send work requests benefits performance
>> by reducing the send queue lock contention (acquired in
>> ib_post_send) and saves us HW doorbells which is posted
>> only once.
>
> s/Concatination/Concatenation/
>
> AFAIK,  do we today! isn't that the case? if partially, please specify
> in the change-logs
> what flows were not fully optimized in that respect and are such after
> the patch.

I'll add which current work requests are not chained.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
