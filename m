From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in
 destroy qp flow
Date: Sun, 27 Nov 2016 16:56:19 +0000
Message-ID: <BLUPR02MB1683B2E832867815771A4B2C818B0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
 <1480252702-8005-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/27/16 05:18, Leon Romanovsky wrote:=0A=
> Fixes: 9433c188915c ("IB/mlx4: Invoke UPDATE_QP for proxy QP1 on MAC chan=
ges")=0A=
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=0A=
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>=0A=
=0A=
Hello Leon,=0A=
=0A=
Commit ID 9433c188915c refers to a patch that was merged in kernel =0A=
version v3.15. Shouldn't a "Cc: stable" tag be added to this patch and =0A=
also to the other patches in this series?=0A=
=0A=
Bart.=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
