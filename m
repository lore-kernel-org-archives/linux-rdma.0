From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core: pvrdma init issue
Date: Thu, 19 Jan 2017 08:27:45 -0800
Message-ID: <963cb92f-97fd-86bb-cb0c-d31bba4001b2@vmware.com>
References: <b13a0a91-f93a-1072-0e5a-e9841660cf00@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b13a0a91-f93a-1072-0e5a-e9841660cf00-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yishai,

On Thu, Jan 19, 2017 at 4:05:36PM +0200, Yishai Hadas wrote:
> Hi Adit,
> 
> Working with latest rdma-core stuff that includes the pvrdma provider, 
> encountered below issue, would appreciate your input on.
> 
> While libibverbs loads the drivers there are few "annoying" warnings 
> that are printed from pvrdma per uverbs sysfs entry coming from 
> 'pvrdma_driver_init_shared'.
> 
> "pvrdma: ABI version 4 of /sys/class/infiniband_verbs/uverbs0 is not 
> supported (supported 3)
> pvrdma: ABI version 1 of /sys/class/infiniband_verbs/uverbs1 is not 
> supported (supported 3)
> ...
> "

We have a fix that addresses this internally. We will have to check for
the device and vendor id before the ABI check. I will send that out shortly.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
