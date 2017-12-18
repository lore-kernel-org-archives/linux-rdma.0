From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-next, 01/31] IB/core: Fix do not add RoCEv2 default GID
 when IPv6 is disabled
Date: Mon, 18 Dec 2017 13:48:18 -0700
Message-ID: <20171218204818.GA18725@ziepe.ca>
References: <20171114125218.20477-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:48PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Currently two RoCE default GIDs are added whenever HCA supports RoCEv1
> and RoCEv2. Default GIDs are created using unique GUID and well known
> prefix as defined by the IB spec 1.3 section 4.1.1 and 3.5.10.
> 
> For few HCAs GUID is derived from the MAC address of the netdev. Due to
> this scheme, default RoCEv2 GID resemebles link-local IPv6 based GID.
> Even when IPv6 is disabled at compile time in kernel, default RoCEv2 GID
> can get added. When such RoCEv2 GID is used, offload HCA starts using
> IPv6 packets for QP.
> This leads to sending IPv6 packets in network from a host which has IPv6
> disabled kernel.
> 
> This can be seen with below simple test.
> ib_send_bw -x 1 -d mlx5_1
> ib_send_bw -x 1 -d mlx5_1 <ip_v4_addr>
> 
> It may not be a good idea to send/receive IPv6 packets on kernel which
> has IPv6 disabled.
> 
> Therefore lets honor networking stack's IPv6 disabled setting.
> This patch avoids adding RoCEv2 based default GID when IPv6 is
> disabled in kernel.
> 
> ibv_devinfo -v output can be seen as below on IPv6 disabled kernel as
> below with one IPv4 address assign to netdevice.
> 
> GID[  0]: fe80:0000:0000:0000:268a:07ff:fe55:4661
> GID[  2]: 0000:0000:0000:0000:0000:ffff:c3a8:0124
> GID[  3]: 0000:0000:0000:0000:0000:ffff:c3a8:0124
> 
> This also ensures that any RoCE specific legacy application who has
> assumed GID indexes for IP addresses start from 2, still continue to
> have such IP based GIDs assigned from start index of 2.

I'm not going to take this patch.. The entire concept is wrong.

rocev2 should *NOT* be creating a default IPv6 address, ever. So
turning that off is simply the wrong solution to this problem.

rocev2 is IP based and must exclusively follow the IP address list in
the host.

It must never invent its own IP that is not associated with a netdev.

Creating a rocev1 compatability DGID does makes sense, but that is a
*DGID* and it must never be co-mingled with rocev2 packets.

> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

BTW, Leon when you send these patches please make sure the Reviewer's
are CC'd as they should see and have a chance to respond to review
comments.. I added Eli manually in this case..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
