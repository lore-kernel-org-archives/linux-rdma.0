From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/iSER problems with Linux 3.0
Date: Thu, 19 Jan 2012 14:18:04 +0200
Message-ID: <4F1809FC.2020908@mellanox.com>
References: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg@mail.gmail.com> <4F154CF2.7030504@profitbricks.com> <4F158C0D.7070302@mellanox.com> <4F17FE97.6090708@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F17FE97.6090708-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/19/2012 1:29 PM, Sebastian Riemer wrote:
> just cherry-picking that commit didn't do the job. Therefore, I've 
> backported the whole ib_iser code from 3.2.1 to 3.0.15. Now it works fine

I would suspect one of these

> # git shortlog v3.0..v3.2 drivers/infiniband/ulp/iser
> [...]
> Or Gerlitz (4):
>       IB/iser: Fix wrong mask when sizeof (dma_addr_t) > sizeof 
> (unsigned long)
>       IB/iser: Support iSCSI PDU padding
>       IB/iser: Use separate buffers for the login request/response
>       IB/iser: DMA unmap TX bufs used for iSCSI/iSER headers
> [...]

could you try only the four of them on top of 3.0.15 and then if it 
works okay, find out which one of them does the job?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
