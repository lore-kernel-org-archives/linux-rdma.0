From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 4/4] IB/core: Add IP to GID netlink offload
Date: Tue, 10 May 2016 10:57:58 +0000
Message-ID: <VI1PR05MB1391E99DF74B2A76025ADAA0D2710@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1462376518-6725-1-git-send-email-leon@kernel.org>
 <1462376518-6725-5-git-send-email-leon@kernel.org>
 <20160504185241.GD20554@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504185241.GD20554-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry it took me so long to response, I had personal matters I had to attend
and was without internet access.

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, May 04, 2016 9:53 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch
> <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Matan
> Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 4/4] IB/core: Add IP to GID netlink offload
> 
> On Wed, May 04, 2016 at 06:41:58PM +0300, Leon Romanovsky wrote:
> > From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > There is an assumption that rdmacm is used only between nodes
> > in the same IB subnet, this why ARP resolution can be used to turn
> > IP to GID in rdmacm.
> >
> > When dealing with IB communication between subnets this assumption
> > is no longer valid. ARP resolution will get us the next hop device
> > address and not the peer node's device address.
> >
> > To overcome this limitation, let's check user space if it can
> > provide the GID of the peer node, and fail if not.
> >
> > We add a sequence number to identify each request and fill in the GID
> > upon answer from user space.
> 
> This description doesn't describe what this patch is trying to do.
> 
> This patch is delegating IP to GID translation to user space if there
> is a route table entry for the destination.
> 
> I have to say, I really don't like this at all. If we want to have
> proper routing support then the translation needs to be done somehow
> in-band. What is user space supposed to do?
I agree that in the long term an in-band kernel based solution is a better option.
As it stands today, I don't know of any standard way to achieve that.

I'll add a better description to the next version, but in a nutshell:
We are using ibacm to answer those requests, we envision two ways to do that,
The easier one is to load Ibacm with a file that contains ip->gid of the entire fabric.
The more tricky one is feed live information, so if a new node becomes active, update
The entire fabric about its IP and GID and remove the information if a node goes down.

That's also the reason why I've added the RDMA_NL_LS_OP_IP_RESOLVE under 
Local service operations. This way ibacm can still listen on one netlink socket
For both SA and IP->GID queries.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
