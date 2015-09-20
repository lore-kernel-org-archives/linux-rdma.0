From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] xprtrdma: Remove ib_get_dma_mr calls
Date: Sun, 20 Sep 2015 13:12:50 +0300
Message-ID: <55FE86A2.4010604@dev.mellanox.co.il>
References: <1442742767-8755-1-git-send-email-sagig@mellanox.com>
 <1442742767-8755-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442742767-8755-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/20/2015 12:52 PM, Sagi Grimberg wrote:
> since commit 96249d70dd70 ("IB/core:
> Guarantee that a local_dma_lkey is available") The PD now
> has a local_dma_lkey member which completely replaces
> ib_get_dma_mr, use it instead.
>
> In FRWR memreg mode, we assumed that the device local_dma_lkey
> is available.

Chuck,

I just noticed that this is (almost) identical to your 02/18 RFC patch.
Would you mind if I send v1 with your patch to 4.3-rc (given xprtrdma
would break over mlx5 without it)?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
