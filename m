From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 5/7] libmlx4: add IBoE support
Date: Tue, 19 Jul 2011 10:49:06 -0600
Message-ID: <20110719164906.GA18090@obsidianresearch.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1107191231540.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1107191231540.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2011 at 12:32:52PM +0300, Or Gerlitz wrote:
> Modify libmlx4 to support IBoE, where the only user space piece
> to handle is the creation of UD address handles - the L2 Ethernet
> attributes have to be resolved from the DGID.

It seems a shame to add a kernel syscall to every ah creation just to
learn the link type.

Other than rejecting some GIDs it doesn't seem like there is any
operational need to learn the link type..

Also, did anyone document the GID format for IBoE? IIRC we invented
this for Linux since IBA refused to standardize anything.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
