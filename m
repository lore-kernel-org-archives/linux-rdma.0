From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/qib: Add new qib driver for QLogic PCIe
 InfiniBand adapters
Date: Wed, 25 Oct 2017 11:59:30 +0300
Message-ID: <20171025085930.3qonlrgfgr3xtsta@mwanda>
References: <20171025084219.osbhmfytsoevzh7f@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171025084219.osbhmfytsoevzh7f@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is really old so Ralph's email bounces.  Anyway over half the
qib_handle_urcv() callers use ~0U.

regards,
dan carpenter

On Wed, Oct 25, 2017 at 11:42:19AM +0300, Dan Carpenter wrote:
> Hello Ralph Campbell,
> 
> The patch f931551bafe1: "IB/qib: Add new qib driver for QLogic PCIe
> InfiniBand adapters" from May 23, 2010, leads to the following static
> checker warning:
> 
> 	drivers/infiniband/hw/qib/qib_iba6120.c:1108 handle_6120_errors()
> 	warn: was expecting a 64 bit value instead of '0'
> 
> drivers/infiniband/hw/qib/qib_iba6120.c
>   1100          /*
>   1101           * If there were hdrq or egrfull errors, wake up any processes
>   1102           * waiting in poll.  We used to try to check which contexts had
>   1103           * the overflow, but given the cost of that and the chip reads
>   1104           * to support it, it's better to just wake everybody up if we
>   1105           * get an overflow; waiters can poll again if it's not them.
>   1106           */
>   1107          if (errs & (ERR_MASK(RcvEgrFullErr) | ERR_MASK(RcvHdrFullErr))) {
>   1108                  qib_handle_urcv(dd, ~0U);
>                                             ^^^
> qib_handle_urcv() takes a u64 so we would sort of expect that we want
> to pass U64_MAX here instead of U32_MAX.  If it's intentional, then it's
> pretty subtle.
> 
>   1109                  if (errs & ERR_MASK(RcvEgrFullErr))
>   1110                          qib_stats.sps_buffull++;
>   1111                  else
>   1112                          qib_stats.sps_hdrfull++;
>   1113          }
>   1114  done:
>   1115          return;
> 
> 
> regards,
> dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
