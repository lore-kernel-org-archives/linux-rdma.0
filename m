From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 02/10] IB/core: Introduce Work Queue object
 and its verbs
Date: Sun, 29 May 2016 16:30:37 +0300
Message-ID: <7747beea-5c96-6c17-a87e-a16a45252487@dev.mellanox.co.il>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-3-git-send-email-yishaih@mellanox.com>
 <574AE5C4.5010707@grimberg.me> <574AE710.3070901@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574AE710.3070901-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/29/2016 3:56 PM, Sagi Grimberg wrote:
>
>> Looks good,
>>
>> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>
> Wait, I have a question first,
>
> Can you explain why a wq takes a reference on a CQ?
> I don't really see why we enforce this association. I cannot
> destroy the CQ before I destroy the wq?
>
> Look at SRQs which I find quite similar (the normal one, not the XRC
> one), it does not reference the CQ.

This association WQ->CQ is same as with QP->CQ where reference is taken 
on the CQ. When creating a normal SRQ there is no input CQ, only when 
working with XRC one, in that case a reference is really taken.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
