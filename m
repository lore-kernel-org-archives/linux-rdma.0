From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Sun, 19 Oct 2014 18:50:29 +0300
Message-ID: <5443DDC5.6020805@dev.mellanox.co.il>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>	<543CD5D6.1020506@mellanox.com>	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>	<CAJ3xEMjXWuZomt98YJiLfUw=rwZ5A+MUbsxEZnGMj8hP7gu0Og@mail.gmail.com>	<b7d2d454-8db1-467d-8088-bd52fac9b612@CMEXHTCAS2.ad.emulex.com> <CAJ3xEMgQ_spota-K5XiMQm1Gwk19a7=xFvGJ_JM+DfvpOQ_Nzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgQ_spota-K5XiMQm1Gwk19a7=xFvGJ_JM+DfvpOQ_Nzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/16/2014 8:31 AM, Or Gerlitz wrote:
> On Thu, Oct 16, 2014 at 1:41 AM, Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>> With the HW and fw profile we are running with the ocrdma currently, it's 8k per CQ.  This number could change if we run on different  hw or fw profile.
>
> OK. So CQEs per CQ wise, there's nothing in the ocrdma (sw/fw/fw)
> which is extremely different. The more major difference is the
> relatively small numbers
> of CQs per device you can support on your driver.
>
> Sorry for being a bit short and not explaining everything, I'm on LPC
> 2014 so a bit busy... but AFAI-See-This,
> here's the list of TODO items here:
>
> 1. change the the number of CQs to be min(num_cpus, 1/2 of what the
> device can support)
> 2. add the # of SCSI commands per session and y/s immediate data is
> supported for this session to ep_connect_with_params
>
> Sagi, agree?
>
> #1 is pretty easy and we actually have it ready for 3.19

Maybe even 3.18?

>
> #2 should be easy too, Max, please add it to your TODO for the ep
> connect changes
>

I don't think we need it in ep_connect.
We can create CQs/QPs with min(desired, device_support) and just keep
the sizes and adjust session cmds_max at session creation time, and max
QPs per CQ.

What I am concerned about is that we don't enforce max QPs per
CQ. we have never seen this overrun - but no reason why it wouldn't
happen. I have it on my todo list, but we need to take care of it soon.
This issue would be somewhat relaxed if we got rid of the artificial
ISER_MAX_CQ.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
