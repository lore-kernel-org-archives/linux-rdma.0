From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] RXE: A Soft RoCE back-end for the RVT
Date: Thu, 7 Jan 2016 17:44:48 +0200
Message-ID: <568E87F0.4030506@dev.mellanox.co.il>
References: <1452106579-4081-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452106579-4081-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This patch introduces an implementation of a back-end that works with
> RVT to make RoCE Verbs transport over any Ethernet network device.
>
> Example:
>
> After loading ib_rxe_net.ko
> 	echo eth1 > /sys/module/ib_rxe_net/parameters/add
> will create rvt0 IB device in RVT with Ethernet link layer
> ---
>   drivers/infiniband/Kconfig            |    1 +
>   drivers/infiniband/sw/Makefile        |    1 +
>   drivers/infiniband/sw/rxe/Kconfig     |   23 ++
>   drivers/infiniband/sw/rxe/Makefile    |    5 +
>   drivers/infiniband/sw/rxe/rxe_net.c   |  580 +++++++++++++++++++++++++++++++++
>   drivers/infiniband/sw/rxe/rxe_net.h   |   89 +++++
>   drivers/infiniband/sw/rxe/rxe_sysfs.c |  167 ++++++++++
>   7 files changed, 866 insertions(+), 0 deletions(-)

836 LOC SoftRoCE driver, impressive...

> +module_param_call(add, rxe_param_set_add, NULL, NULL, 0200);
> +module_param_call(remove, rxe_param_set_remove, NULL, NULL, 0200);

The standard way of doing this is with class and device structures and
not module_param_call...

You can look at srp for example on how to get it right...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
