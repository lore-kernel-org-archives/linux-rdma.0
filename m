From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in
 destroy qp flow
Date: Mon, 28 Nov 2016 08:29:55 -0800
Message-ID: <bdd9788e-d393-b23e-876c-ae84774fdccd@sandisk.com>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
 <1480252702-8005-2-git-send-email-leon@kernel.org>
 <BLUPR02MB1683B2E832867815771A4B2C818B0@BLUPR02MB1683.namprd02.prod.outlook.com>
 <20161128083107.GB6380@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161128083107.GB6380-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/28/2016 12:31 AM, Leon Romanovsky wrote:
> I'm extra cautions with stable tags and prefer to finalize my stable
> checker in my submissions scripts first, before adding it manually and
> I have plans to use it next kernel release.

Hello Leon,

Thanks for explaining your workflow. However, the question remains 
whether or not stable tags should be added to the patches in this series?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
