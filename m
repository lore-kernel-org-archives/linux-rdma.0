From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: NFS/RDMA RoCE with mlx4_en
Date: Wed, 26 Jul 2017 08:54:04 +0300
Message-ID: <20170726085404.00005e29@dev.mellanox.co.il>
References: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5@oracle.com>
        <20170627133306.00003fda@dev.mellanox.co.il>
        <7FB59BD3-CB33-4710-B049-B53C6C042736@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7FB59BD3-CB33-4710-B049-B53C6C042736-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 27 Jun 2017 12:28:43 -0400
Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> In the process of collecting data for you, I noticed that
> the CX3's maximum Ethernet link speed is 40Gbps, and I
> had set the switch port speed to 56Gbps. I've set the
> port speed back to 40Gbps, and now neither the device
> reset nor the cma_alloc failures are reproducing.
> 
> If you'd like to pursue this further, I can switch back to
> the higher speed and try to reproduce to collect this
> information.

Hi Chuck,

Thank you for giving us hand in understanding the root cause.
I apologize for the long delay in replying to your kind offer.

Fortunately, using the information you provided, we succeeded to
reproduce the issue in house, so there is no need for you to do any
extra work on this.

Thanks again!

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
