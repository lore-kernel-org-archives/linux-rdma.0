From: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 14/26] RDS/IW: Convert to new memory registration API
Date: Thu, 24 Sep 2015 10:43:11 -0700
Message-ID: <5604362F.6020009@oracle.com>
References: <1443116118-10730-1-git-send-email-sagig@mellanox.com>
 <1443116118-10730-15-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443116118-10730-15-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/24/15 10:35 AM, Sagi Grimberg wrote:
> Get rid of fast_reg page list and its construction.
> Instead, just pass the RDS sg list to ib_map_mr_sg
> and post the new ib_reg_wr.
>
> This is done both for server IW RDMA_READ registration
> and the client remote key registration.
>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   net/rds/iw.h      |   5 +--
>   net/rds/iw_rdma.c | 128 +++++++++++++++++++-----------------------------------
>   net/rds/iw_send.c |  57 ++++++++++++------------
>   3 files changed, 75 insertions(+), 115 deletions(-)
>
Acked-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
