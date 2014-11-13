From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH fixes for-3.18 0/6] iSER initiator 3.18-rc fixes
Date: Thu, 13 Nov 2014 07:55:00 +0200
Message-ID: <546447B4.40804@mellanox.com>
References: <1414489753-29199-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414489753-29199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/28/2014 11:49 AM, Or Gerlitz wrote:
> Hi Roland,
>
> This is a small batch of iser rc fixes for 3.18.

Hi Roland,

Upstreaming this for 3.18? @ least one of the patches fixes a deadly bug 
(SQ overflow) which must get into 3.18 this way (rc fixes) or another 
(-stable),  but practically weneed them all.

Or.



>
> The patch from Emulex folks allows to run iser over their HW and ocrdma
> drivers, which is nice addition to the support matrix for iser.
>
> Sagi and Or.
>
> Ariel Nahum (1):
>    IB/iser: Collapse cleanup and disconnect handlers
>
> Max Gurtovoy (1):
>    IB/iser: Fix possible SQ overflow
>
> Minh Tran (1):
>    IB/iser: Re-adjust CQ and QP send ring sizes to HW limits
>
> Sagi Grimberg (3):
>    IB/iser: Fix catas error flow hang
>    IB/iser: Decrement CQ's active QPs accounting when QP creation fails
>    IB/iser: Fix sparse warnings
>
>   drivers/infiniband/ulp/iser/iscsi_iser.c     |   10 +++-
>   drivers/infiniband/ulp/iser/iscsi_iser.h     |    9 ++++
>   drivers/infiniband/ulp/iser/iser_initiator.c |    6 +-
>   drivers/infiniband/ulp/iser/iser_memory.c    |    1 -
>   drivers/infiniband/ulp/iser/iser_verbs.c     |   67 ++++++++++++++++++--------
>   5 files changed, 65 insertions(+), 28 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
