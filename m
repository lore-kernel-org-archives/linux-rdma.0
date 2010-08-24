From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB: Broken IGMP processing
Date: Tue, 24 Aug 2010 12:49:26 -0600
Message-ID: <20100824184926.GA27899@obsidianresearch.com>
References: <alpine.DEB.2.00.1008231427130.12815@router.home> <7E95F01E94AB484F83061FCFA35B39F8013249@exil.voltaire.com> <20100823194555.GN26549@obsidianresearch.com> <alpine.DEB.2.00.1008231454230.12815@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231454230.12815-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 23, 2010 at 02:59:45PM -0500, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Jason Gunthorpe wrote:
> 
> > Simplest then is to check if byte 24 of the packet is 0xff.
> > (ie IN6_IS_ADDR_MULTICAST)
> 
> Dont see that function defined anywhere in the kernel.

That is what userspace calls it..

How about

ipv6_addr_type(((ipv6hdr *)skb->head)->daddr) & IPV6_ADDR_MULTICAST

There are 32 occurrences of 'skb->head' in drivers/net..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
