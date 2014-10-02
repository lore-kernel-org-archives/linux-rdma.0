From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 9/9] Samples: Peer memory client example
Date: Wed, 1 Oct 2014 21:14:41 -0600
Message-ID: <20141002031441.GA10386@obsidianresearch.com>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
 <1412176717-11979-10-git-send-email-yishaih@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE5096@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DE5096-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 01, 2014 at 05:16:12PM +0000, Hefty, Sean wrote:
> > Adds an example of a peer memory client which implements the peer memory
> > API as defined under include/rdma/peer_mem.h.
> > It uses the HOST memory functionality to implement the APIs and
> > can be a good reference for peer memory client writers.
> 
> Is there a real user of these changes?

Agreed..

Can you also discuss what is going on at the PCI-E level? How are the
peer-to-peer transactions addressed? Is this elaborate scheme just a
way to 'window' GPU memory or is the NIC sending special PCI-E packets
at the GPU?

I'm really confused why this is all necessary, we can already map
PCI-E memory into user space, and there were much simpler patches
floating around to make that work several years ago..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
