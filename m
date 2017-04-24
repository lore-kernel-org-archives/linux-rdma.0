From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: iwpm_register_pid: Unable to send a nlmsg (client = 2) observed
 on 4.11.0-rc7 during configure NVMe over iWARP RDMA
Date: Mon, 24 Apr 2017 12:07:19 -0400 (EDT)
Message-ID: <1387499651.389985.1493050039361.JavaMail.zimbra@redhat.com>
References: <1613368219.36836.1492847910707.JavaMail.zimbra@redhat.com> <770183667.36997.1492848597368.JavaMail.zimbra@redhat.com> <09c501d2bd13$a8d58700$fa809500$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <09c501d2bd13$a8d58700$fa809500$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve

Here is another issue I filed that using iw_cxgb4. 
http://lists.infradead.org/pipermail/linux-nvme/2017-April/009458.html

Best Regards,
  Yi Zhang


----- Original Message -----
From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
To: "Yi Zhang" <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Monday, April 24, 2017 11:58:48 PM
Subject: RE: iwpm_register_pid: Unable to send a nlmsg (client = 2) observed on 4.11.0-rc7 during configure NVMe over iWARP RDMA

> Subject: iwpm_register_pid: Unable to send a nlmsg (client = 2) observed on 4.11.0-
> rc7 during configure NVMe over iWARP RDMA
> 
> Hello experts
> 
> I found below pid_query_error, could anyone help check it? I have attached all the
> dmesg log. Thanks
> 
> [  152.372481] nvmet: adding nsid 1 to subsystem testnqn
> [  152.398705] iwpm_register_pid: Unable to send a nlmsg (client = 2)
> [  152.430011] nvmet_rdma: enabling port 2 (172.31.52.12:4420)
> 
> 
> Best Regards,
>   Yi Zhang
>

Hey Yi, 

This is the iWARP port mapping kernel service logging that no iwarp port mapper daemon is running on the system.  This is benign in the context of nvme/fabrics.  Are you having other problems with using iw_cxgb4?

Steve.
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
