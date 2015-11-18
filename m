From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Wed, 18 Nov 2015 22:27:41 +0200
Message-ID: <20151118202740.GA3262@yuval-lab>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <1438264693.9344.19.camel@opteya.com>
 <20150730152049.GA29102@yuval-lab>
 <55BA47F0.5080504@redhat.com>
 <20150730171538.GA25282@obsidianresearch.com>
 <20150730204635.GC3487@yuval-lab>
 <20150730210018.GA32451@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730210018.GA32451-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 03:00:18PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 30, 2015 at 11:46:36PM +0300, Yuval Shaia wrote:
> > On Thu, Jul 30, 2015 at 11:15:38AM -0600, Jason Gunthorpe wrote:
> > > On Thu, Jul 30, 2015 at 11:51:12AM -0400, Doug Ledford wrote:
> > > 
> > > > In its current state, I have my doubts about this patch.  However, it
> > > > seems to me that this should be relatively easy to fix in such a way
> > > > that you get 90%+ of the performance benefit, and can turn it on by
> > > > default, and we don't cause any problems.
> > > 
> > > The best way to implement this is to leverage all the checksum
> > > offload work people did for virtualization.
> > > 
> > > Forward the checksum offload status through the RC connection and
> > > recover it on the other side.
> > The current approach is to utilize IPoIB's private-data to exchange this
> > information.
> 
> You need private-data exchange to negotiate the feature.
> 
> The feature should be a per-packet csum status header.
> 
> When sending a skb that is already fully csumed the receiver sets
> CHECKSUM_UNNECESSARY.
> 
> When sending a skb that has CHECKSUM_PARTIAL then the
> receiver needs to call skb_partial_csum_set.
> 
> Look at how something like VIRTIO_NET_HDR_F_NEEDS_CSUM works and copy
> that scheme.
Correct me if i'm wrong here but isn't this protocol assume both parties
are aware of this special header?
My case is a bit different, driver must support backward computability in a
way that peer maybe a driver that do not support this feature and expect
packet to be full checksummed.
> 
> DO NOT EVER set CHECKSUM_UNNECESSARY on packets that do not have valid
> csums - that breaks the net stack.
The entire idea here is to fake csum offload so how would i tell the stack
not to run csum on incoming packet?
> 
> Yes, you need to add a header to all packets to support this scheme,
> that is what the private-data negotiation is for.
> 
> While you are at it, I'd make room for something like
> VIRTIO_NET_HDR_GSO_* in the RC protocol too. Implementing GSO
> forwarding is probably another big performance win.
If i understood you correctly and you mean exchange of
"driver-capabilities", then yes, it is there with the extends of
ipoib_cm_data structure.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
