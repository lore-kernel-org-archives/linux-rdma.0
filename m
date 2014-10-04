From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Sat, 4 Oct 2014 21:36:37 +0300
Message-ID: <20141004183636.GA2883@yuval-lab>
References: <20140914184621.GA4283@yuval-lab>
 <20141001115531.GA10035@yuval-lab>
 <542BEFED.6050203@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <542BEFED.6050203-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 01, 2014 at 03:13:33PM +0300, Or Gerlitz wrote:
> 
> On 10/1/2014 2:55 PM, Yuval Shaia wrote:
> >On transmit checksum calculation is done while copying buffer from user-space so not much benefit
> but this copying can go away, right?
I assume this is exactly what networking-layer does when driver reports NETIF_F_IP_CSUM.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
