From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Block PKEY creation using ip link
Date: Thu, 26 Oct 2017 10:57:39 -0600
Message-ID: <20171026165739.GB5829@obsidianresearch.com>
References: <DB5PR05MB16704ACD20AE16C44B838486B4450@DB5PR05MB1670.eurprd05.prod.outlook.com>
 <20171026100634.GG16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171026100634.GG16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 26, 2017 at 01:06:34PM +0300, Leon Romanovsky wrote:
> On Thu, Oct 26, 2017 at 09:47:44AM +0000, Denis Drozdov wrote:
> > Temporary commit that blocks pkey creation using
> > ip link. Example:
> >
> > ip link add link ib2 name ib2.1 type ipoib
> >         RTNETLINK answers: Operation not supported
> >
> > Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> NAK,
> It is completely wrong and this bug relevant for mlx5 enhanced IPoIB devices,
> but you are disabling all IPoIB capable devices.

+1

If this flow doesn't work with netdev offload, then disable the entire
netdev offload completely until it can be fixed properly.

It is absolutely not OK to selectively break established user APIs like
'ip link' just because a kernel-side optimization is not implemented
correctly, you don't get to do that.

If we knew that the netdev offload patches broke 'ip link' they would
not have been accepted.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
