From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next 9/9] Samples: Peer memory client example
Date: Thu, 2 Oct 2014 13:35:45 +0000
Message-ID: <8035d6ee73434a92b3f304e58ae8c02d@AMSPR05MB422.eurprd05.prod.outlook.com>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
 <1412176717-11979-10-git-send-email-yishaih@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237399DE5096@ORSMSX109.amr.corp.intel.com>
 <20141002031441.GA10386@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141002031441.GA10386-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Wed, Oct 01, 2014 at 05:16:12PM +0000, Hefty, Sean wrote:
> > > Adds an example of a peer memory client which implements the peer
> memory
> > > API as defined under include/rdma/peer_mem.h.
> > > It uses the HOST memory functionality to implement the APIs and
> > > can be a good reference for peer memory client writers.
> >
> > Is there a real user of these changes?
> 
> Agreed..
> 
> Can you also discuss what is going on at the PCI-E level? How are the
> peer-to-peer transactions addressed? Is this elaborate scheme just a
> way to 'window' GPU memory or is the NIC sending special PCI-E packets
> at the GPU?
> 

The current implementation is using a 'window' on the GPU memory,
opened through one of the device's PCI-e BAR. Future iterations of the
technology might use a different kind of messaging. The proposed 
interface enables such mechanisms, as both parties of the peer to peer 
communication are explicitly informed of the peer identity for the
given region.

> I'm really confused why this is all necessary, we can already map
> PCI-E memory into user space, and there were much simpler patches
> floating around to make that work several years ago..
> 

We believe that a specialized interface for pinning/registering peer
to peer memory regions is needed here.

First of all, most hardware vendors don't provide a user space mapping
mechanism of memory over PCI-E. Even the vendors who are supporting
such mapping, require the usage of different, proprietary interfaces
to do so. As such, a solution which relies on a user space based
mapping will be extremely clunky. The user space code will have to
keep an intimate knowledge of how to map the memory for each and every
of the different hardware vendors supported. This adds an additional
user space/kernel dependency, making portability and usability harder.
The proposed solution provides a simple, "one stop shop" for all the
memory registration needs. The application simply provides a pointer
to the reg_mr verb, and internally the kernel is handling any mapping
and pinning needed. This interface is easier to use from the user
perspective, compared to the suggested alternative.

Additionally, there are cases where the peer memory client, which
provides the memory, requires an immediate invalidation of the memory
mapping. For example, when the accelerator card is swapping tasks and
the pervious allocated memory is being discarded or swapped out. The
current umem interface does not support this kind of
functionality. The suggested patchset defines an enriched interface,
where the RDMA low level driver is notified when the memory must be
invalidated. This interface is implemented in two low level drivers as
part of this patchset. A possible future peer memory client could
replace the functionality of umem for standard host memory (similar to
the example), and use the mmu_notifiers callbacks to invalidate memory
that is not accessible any more.


Thanks,
--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
