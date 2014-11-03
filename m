From: Chris Moore <Chris.Moore-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/isert: Adjust CQ size to HW limits
Date: Mon, 3 Nov 2014 16:22:42 +0000
Message-ID: <462EF229174FDB4D92ACE4656EA5610051E3F6C4@CMEXMB1.ad.emulex.com>
References: <462EF229174FDB4D92ACE4656EA5610051E3C4E6@CMEXMB1.ad.emulex.com>
 <54562583.9080700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54562583.9080700-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Sunday, November 02, 2014 4:37 AM
> To: Chris Moore; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Nicholas A. Bellinger
> Subject: Re: [PATCH] IB/isert: Adjust CQ size to HW limits
> 
> On 10/31/2014 9:50 PM, Chris Moore wrote:
> >
> > This is the isert version of the patch that Minh Tran submitted for iser.
> > isert has the same issue of trying to create a CQ with more CQEs than
> > are supported by the hardware.
> >
> 
> ib_isert is maintained in target-devel. Can you resend it there?
> 
> Thanks!
> 
> Sagi.

Yep, no problem, I'll do that.

There was another issue in ib_isert.c that Nic  proposed a fix for in an email back on 10/22.
This was the issue with attr.cap.max_send_sge being set to (device->dev_attr.max_sge - 2)
instead of just device->dev_attr.max_sge.

Should I post that issue to target-devel as well?

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
