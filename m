From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Sun, 28 Nov 2010 15:50:14 +0200
Message-ID: <AANLkTikWrQRcA62bkM=1zWQuyH6nABSvqnbAeaAjfgcP@mail.gmail.com>
References: <20101115140829.GA20355@mtldesk30>
	<ada62vxl046.fsf@cisco.com>
	<20101116180732.GB29132@mtldesk30>
	<ada1v6klwil.fsf@cisco.com>
	<20101117090134.GA20369@mtldesk30>
	<adasjyzkfyw.fsf@cisco.com>
	<20101118065142.GB20369@mtldesk30>
	<AANLkTinN43YgQW3ftbng-4f2NiNe9_oXPVCX5LPzh7uG@mail.gmail.com>
	<4CEE200B.70106@Voltaire.com>
	<1290675387.4050.51.camel@alst60.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290675387.4050.51.camel-uOVkuFIEnOODI2cvxHXf6UEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello, Roland.

I afraid that you  overloaded with dozen of e-mails and missed this
question, so I'd ask you again. Is there any reason why this
members_count patch cannot be applied?

On Thu, Nov 25, 2010 at 10:56 AM, Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> On Thu, 2010-11-25 at 10:36 +0200, Or Gerlitz wrote:
>> Aleksey Senin wrote:
>> > RAW_ETH patches cannot be applied without it, so we really need this masking.
>>
>> So Maybe it would be easier to review and merge if you add this patch to the raw qp patch set
>> you mentioned
>>
>> Or.
>
> I don't think that RAW_ETH patches should contain fixes for Mellanox
> driver implementation and make it working according to Mellanox PRM.
> In any case, Eli sent patch that easy to review and merge.
> In addition, even if I include this change to my series, there is a
> chance that from the whole set, will be accepted only this one, and the
> rest will be accepted later ;-)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
