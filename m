From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs V1] Align Flow Steering API to the extension
 verbs scheme
Date: Wed, 11 Jun 2014 13:51:10 +0300
Message-ID: <5398349E.9020205@mellanox.com>
References: <1400159784-24423-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx> <CAL1RGDXZg7Od33OaRdBHc7kxmvnKd1cN2szSpCdEkdpxGw1BTA@mail.gmail.com> <537AFD48.2040302@mellanox.com> <539826FF.2040402@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539826FF.2040402-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/06/2014 12:53, Or Gerlitz wrote:
> On 20/05/2014 09:59, Or Gerlitz wrote:
>> On 20/05/2014 04:05, Roland Dreier wrote:
>>> On Thu, May 15, 2014 at 6:16 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> 
>>> wrote:
>>>> Hi Roland -- this addresses all the comments by Jason who gave a
>>>> ack/reviewed-by note for both the libibverbs and libmlx4 fixes.
>>>>
>>>> So you can move ahead and conduct point releases for both libs.
>>>
>>> OK... so I should do one more libmlx4 release before you take over?
>>
>> YES, please.
>>
>
> Hi Roland,
>
> Can you please go and do this joint/point release of libibverbs 
> (1.1.9) and libmlx4 (1.0.7)
> which fixes the issues with flow steering?!

FWIW, if it helps you, these are the relevant patchwork entries

https://patchwork.kernel.org/patch/4182461/
https://patchwork.kernel.org/patch/4174891/


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
