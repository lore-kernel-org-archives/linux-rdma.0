From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Tue, 7 Jun 2016 13:56:18 +0000
Message-ID: <VI1PR05MB139117391D79A98E36833FF1D25D0@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
 <VI1PR05MB1391BC017005F864E1DAE3C0D25D0@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <14b30d87-6f70-a7bb-14ea-e5152ce545bf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14b30d87-6f70-a7bb-14ea-e5152ce545bf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, June 07, 2016 4:46 PM
> To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky
> <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
> 
> Nope, you're right.  It's fixed now though.  with num_counters + 2 and
> kzalloc, the final NULL terminator is in place.

Cool, thank you,

Mark


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
