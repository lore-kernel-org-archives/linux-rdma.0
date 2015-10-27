From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 1/2] mlx4: Expose correct max_sge_rd limit
Date: Tue, 27 Oct 2015 17:37:20 +0000
Message-ID: <HE1PR05MB135565029C0B64E22BDE1C0FC5220@HE1PR05MB1355.eurprd05.prod.outlook.com>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
 <1445938846-9240-2-git-send-email-sagig@mellanox.com>
 <562FA544.4040508@sandisk.com> <562FA6E8.4040005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562FA6E8.4040005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just discussed the issue with Sagi. Sagi will follow up with a small correction.

-----Original Message-----
From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: Tuesday, October 27, 2015 11:32 AM
To: Bart Van Assche; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise; Nicholas A. Bellinger; Or Gerlitz; Doug Ledford; Eli Cohen
Subject: Re: [PATCH 1/2] mlx4: Expose correct max_sge_rd limit

> Hello Sagi,
>
> Is this the same issue as what has been discussed in 
> http://www.spinics.net/lists/linux-rdma/msg21799.html ?

Looks like it.

I think this patch addresses this issue, but lets CC Eli to comment if I'm missing something.

Thanks for digging this up...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
