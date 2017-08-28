From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 11/11] IB/rxe: Handle NETDEV_CHANGE events
Date: Mon, 28 Aug 2017 16:50:41 +0300
Message-ID: <20170828135040.GE4609@yuvallap>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-12-git-send-email-andrew.boyer@dell.com>
 <20170827103008.GA10391@yuvallap>
 <D5C986D7.1DF85%Andrew.Boyer@emc.com>
 <e426219f-a558-209b-350c-bd71c39e52eb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e426219f-a558-209b-350c-bd71c39e52eb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 28, 2017 at 09:37:08AM -0400, Doug Ledford wrote:
> On 8/28/2017 8:38 AM, Boyer, Andrew wrote:
> > 
> > On 8/27/17, 6:30 AM, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> >> On Fri, Aug 25, 2017 at 03:05:56PM -0400, Andrew Boyer wrote:
> >>> Without this fix, ports configured on top of ixgbe miss link up
> >>> notifications. ibv_query_port() will continue to return IBV_PORT_DOWN
> >>> even
> >>> though the port is up and working.
> >>>
> >>> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> >>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> >>> ---
> >>>  drivers/infiniband/sw/rxe/rxe_net.c | 7 ++++++-
> >>>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
> >>> b/drivers/infiniband/sw/rxe/rxe_net.c
> >>> index 3ba76e7..133c6c4 100644
> >>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> >>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> >>> @@ -651,8 +651,13 @@ static int rxe_notify(struct notifier_block
> >>> *not_blk,
> >>>  		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
> >>>  		rxe_set_mtu(rxe, ndev->mtu);
> >>>  		break;
> >>> -	case NETDEV_REBOOT:
> >>>  	case NETDEV_CHANGE:
> >>> +		if (netif_running(ndev) && netif_carrier_ok(ndev))
> >>> +			rxe_port_up(rxe, port_num);
> >> On top of which branch/patch this patch is based on?
> > Yikes, it relies on an internal patch that Doug wasn¹t interested in
> > taking. Will respin.
> > 
> 
> I don't remember seeing a patch come through that added rxe_port_up(),
> let alone turning it away...

rxe_port_up is already implemented but since RXE device has only one port i
don't see a reason to pass porn_num to this function.
I might be wrong.

> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
