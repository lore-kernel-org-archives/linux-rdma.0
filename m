From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] bnxt_re: Fix race between the netdev register and
 unregister events
Date: Fri, 22 Sep 2017 13:55:22 -0400
Message-ID: <1506102922.5172.19.camel@redhat.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
         <20170831035735.19595-6-somnath.kotur@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-6-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-31 at 09:27 +0530, Somnath Kotur wrote:
> diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> index b3ad37f..a25f9d2 100644
> --- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> @@ -93,11 +93,13 @@ struct bnxt_re_dev {
>         struct ib_device                ibdev;
>         struct list_head                list;
>         unsigned long                   flags;
> -#define BNXT_RE_FLAG_NETDEV_REGISTERED 0
> -#define BNXT_RE_FLAG_IBDEV_REGISTERED  1
> -#define BNXT_RE_FLAG_GOT_MSIX          2
> -#define BNXT_RE_FLAG_RCFW_CHANNEL_EN   8
> -#define BNXT_RE_FLAG_QOS_WORK_REG      16
> +#define BNXT_RE_FLAG_NETDEV_REGISTERED         0
> +#define BNXT_RE_FLAG_IBDEV_REGISTERED          1
> +#define BNXT_RE_FLAG_GOT_MSIX                  2
> +#define BNXT_RE_FLAG_HAVE_L2_REF               3
> +#define BNXT_RE_FLAG_RCFW_CHANNEL_EN           4
> +#define BNXT_RE_FLAG_QOS_WORK_REG              5
> +#define BNXT_RE_FLAG_TASK_IN_PROG              6
>         struct net_device               *netdev;

So, this is making two changes in once and one of the changes is not
documented.  In particular, it looks like the usage of your flags
elements was originally the actual value of 1 << bit, which is the
wrong thing to pass to the *_bit() operations that want a bit number. 
So you're both adding a new used bit in your flags, but also changing
your flags to be better numbered for use with the *_bit operations.  I
did a quick check and the BNXT_RE_FLAGS* items are never used without
using the bit operations, so this change is safe.  I'm going to update
the commit log when I take this to make that clear.  Generally though,
this should have been two patches.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
