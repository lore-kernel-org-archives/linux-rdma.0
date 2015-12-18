From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 3/7] IB/ulps: Avoid calling ib_query_device
Date: Fri, 18 Dec 2015 15:10:15 +0100
Message-ID: <567413C7.5040907@sandisk.com>
References: <1450429190-5898-1-git-send-email-ogerlitz@mellanox.com>
 <1450429190-5898-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450429190-5898-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/18/2015 09:59 AM, Or Gerlitz wrote:
> Instead, use the cached copy of the attributes present on the device.
>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_cm.c      | 19 ++++-------
>   drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 14 +++------
>   drivers/infiniband/ulp/ipoib/ipoib_main.c    | 21 +------------
>   drivers/infiniband/ulp/iser/iscsi_iser.c     |  4 +--
>   drivers/infiniband/ulp/iser/iscsi_iser.h     |  2 --
>   drivers/infiniband/ulp/iser/iser_memory.c    |  9 +++---
>   drivers/infiniband/ulp/iser/iser_verbs.c     | 38 ++++++++++------------
>   drivers/infiniband/ulp/isert/ib_isert.c      | 47 +++++++++-------------------
>   drivers/infiniband/ulp/isert/ib_isert.h      |  1 -
>   drivers/infiniband/ulp/srp/ib_srp.c          | 32 ++++++-------------
>   drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ++++-----
>   drivers/infiniband/ulp/srpt/ib_srpt.h        |  3 --
>   12 files changed, 63 insertions(+), 142 deletions(-)

Shouldn't this patch be split per ULP driver to make review easier ?

If you have a look at the MAINTAINERS file then you will see that you 
forgot to CC the SRP initiator maintainer.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
