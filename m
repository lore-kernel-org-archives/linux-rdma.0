From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ipoib: fix hard_header return value
Date: Tue, 26 Mar 2013 17:40:00 +0100
Message-ID: <5151CF60.3010100@acm.org>
References: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/26/13 17:24, Doug Ledford wrote:
> If you have a patched up dhcp server (and dhclient), they will use
> AF_PACKET/SOCK_DGRAM pair to send dhcp packets over IPoIB.  This has
> worked since forever if you use OFED kernels or one of the distribution
> kernels.  However, when testing an upstream kernel, it has been broken
> for a very long time (I tested 2.6.34, 2.6.38, 3.0, 3.1, 3.8, HEAD).
>
> It turns out that the hard_header routine in ipoib is not following
> the API and is returning 0 even when it pushed data onto the skb.  This
> then causes af_packet.c to overwrite the header just pushed with data
> from user space.  This header is immediately referenced in the
> ipoib_start_xmit routine, so I'm wondering how this ever worked in
> distro/ofed kernels that also have this bug, but fixing the bug here
> makes things work in upstream kernels.
>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 8534afd..31dd2a7 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -828,7 +828,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
>   	 */
>   	memcpy(cb->hwaddr, daddr, INFINIBAND_ALEN);
>
> -	return 0;
> +	return sizeof *header;
>   }
>
>   static void ipoib_set_mcast_list(struct net_device *dev)

Checkpatch recommends since some time to use sizeof(e) instead of sizeof 
e, isn't it ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
