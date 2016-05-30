From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH V4 for-next 08/10] IB/core: Extend create QP to get
 indirection table
Date: Mon, 30 May 2016 09:43:07 +0300
Message-ID: <574BE0FB.60205@grimberg.me>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-9-git-send-email-yishaih@mellanox.com>
 <574AEA8D.2010909@grimberg.me>
 <d34f7f40-5e05-2eb9-4b81-649b2cb11174@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d34f7f40-5e05-2eb9-4b81-649b2cb11174-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> Thanks Sagi for your reviewing the series.

Sure, I think its an important series.

> When a receive WQ indirection table is supplied as an input any other
> receive side parameters are not playing/valid as they were already set
> when the internal WQ(s) were created. Those checks on max_recv[wr|sge]
> are coming to ensure that input is valid, same as done for srq and recv_cq.

OK, makes sense.

> Re QP type checking, the supported QP types are going to be part of RSS
> capabilities and may be changed between vendors. Each vendor upon
> creation may condition on. Please see cover letter as well.

Yea, I guess that raw eth qps are not supported by all the vendors...

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
