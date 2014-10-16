From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Thu, 16 Oct 2014 07:31:34 +0200
Message-ID: <CAJ3xEMgQ_spota-K5XiMQm1Gwk19a7=xFvGJ_JM+DfvpOQ_Nzw@mail.gmail.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
	<543CD5D6.1020506@mellanox.com>
	<44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
	<CAJ3xEMjXWuZomt98YJiLfUw=rwZ5A+MUbsxEZnGMj8hP7gu0Og@mail.gmail.com>
	<b7d2d454-8db1-467d-8088-bd52fac9b612@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b7d2d454-8db1-467d-8088-bd52fac9b612-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 16, 2014 at 1:41 AM, Minh Duc Tran <MinhDuc.Tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> With the HW and fw profile we are running with the ocrdma currently, it's 8k per CQ.  This number could change if we run on different  hw or fw profile.

OK. So CQEs per CQ wise, there's nothing in the ocrdma (sw/fw/fw)
which is extremely different. The more major difference is the
relatively small numbers
of CQs per device you can support on your driver.

Sorry for being a bit short and not explaining everything, I'm on LPC
2014 so a bit busy... but AFAI-See-This,
here's the list of TODO items here:

1. change the the number of CQs to be min(num_cpus, 1/2 of what the
device can support)
2. add the # of SCSI commands per session and y/s immediate data is
supported for this session to ep_connect_with_params

Sagi, agree?

#1 is pretty easy and we actually have it ready for 3.19

#2 should be easy too, Max, please add it to your TODO for the ep
connect changes

Also please use TEXT based replies applied in bottom posting manner [1].

Or.

[1] http://en.wikipedia.org/wiki/Posting_style#Bottom-posting

>
> -----Original Message-----
> From: Or Gerlitz [mailto:gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, October 15, 2014 3:32 PM
> To: Minh Duc Tran
> Cc: Or Gerlitz; Jay Kallickal; michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jayamohan Kallickal
> Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
>
> How many CQEs per CQ does the ocrdma driver supports?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
