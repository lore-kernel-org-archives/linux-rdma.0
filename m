From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-3.2] IBoE fixes
Date: Wed, 26 Oct 2011 09:04:00 +0200
Message-ID: <4EA7B0E0.6070400@mellanox.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101047420.10901-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marcel Apfelbaum <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2011 10:51 AM, Or Gerlitz wrote:
> This is a batch of IBoE related fixes plus addition of extended PMA counters.

Hi Roland,

With the merge window opening around yesterday, just checking if we're 
on track
for merging this patch set into 3.2 (I sent V1 for patch #3 as you asked).

Also, for the FDR set, Marcel has sent a fix to the "[... v2 3/5] 
ib/mlx4: Add extended
port capabilities support" patch along the lines you were suggesting, so 
we'll be
happy to know if you're fine with this patch and also the fourth patch 
which depends
on it, thanks!

Or.

>
>
>
> Or Gerlitz (5):
>        ib/mlx4: enable 4K MTU for IBoE
>        ib/mlx4: remove setting of vlan in IBoE WQEs control segment
>        net/mlx4_core: remove module param controlling the vlan table size
>        ib/core: add support for extended performance counters in sysfs
>        ib/mlx4: add support for extended PMA counters under IBoE
>
>   drivers/infiniband/core/sysfs.c   |  100 ++++++++++++++++++++++++++++++++++++-
>   drivers/infiniband/hw/mlx4/mad.c  |   49 +++++++++++++++---
>   drivers/infiniband/hw/mlx4/main.c |    2 +-
>   drivers/infiniband/hw/mlx4/qp.c   |   11 +---
>   drivers/net/mlx4/main.c           |   12 +---
>   include/rdma/ib_pma.h             |    1 +
>   6 files changed, 148 insertions(+), 27 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
