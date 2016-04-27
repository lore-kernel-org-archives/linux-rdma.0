From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Wed, 27 Apr 2016 05:21:46 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E22EC6A98@CRSMSX101.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
 <20160419173817.GF20844@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0@ORSMSX109.amr.corp.intel.com>
 <5717EAC1.6020602@redhat.com> <571F6795.8020808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571F6795.8020808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 4/20/2016 4:46 PM, Doug Ledford wrote:
> > On 04/19/2016 04:44 PM, Hefty, Sean wrote:
> >>> Right - and the RDMA uAPI has always had an integrated driver-bypass
> >>> channel as part of the verb uAPI calls, extending that to allow for
> >>> new-driver-specific calls seems very natural.
> >>
> >> I remain unconvinced that having the equivalent of:
> >>
> >> 1 open unrelated-interface
> >> 2 ioctl open-file
> >> 3 close unrelated-interface
> >>
> >> is desirable.  If you want to push for a generic mechanism for mapping
> NIC resources into user space, then separate that from the device
> implementation.
> >>
> >> Doug, can you weigh in here with your thoughts?
> >>
> >
> > Yeah.  I've been off working on issues related to 4.6-rc (interfaces
> > that are DOA).  Give me a little bit to catch up on the thread and
> > I'll weigh in.
> >
> 
> I've spent a decent amount of time thinking about this as well as the general
> questions posed in the "Furhter thoughts on uAPI" thread.
> 
> In regards to the specific issues brought up here, and not really dealing with
> the concept of a Verbs 2.0 API.
> 
> I've been seeing more and more instances where we need to implement
> something, but over and over again, it's already been done (albeit not
> necessarily to our needs) in the core net stack.  It's actually so common that
> I'm starting to feel like I'm in the "Simpson's Did It"
> South Park episode.
> 
> I toyed for a bit with the idea that we could alter the core RDMA stack to
> simply always allocate a netdevice and in some way transition the RDMA
> stack to being a more fully integrated member of the net stack.
> This does have some advantages, but also lots of difficulties.

Sounds reasonable.

> 
> However, in retrospect, the iWARP, RoCE, and usNIC devices all already have
> netdevices because they are all Ethernet devices that support some form of
> RDMA.  The only devices left out are OPA and IB.
> 
> We already have precedent for requiring an IPoIB device, and it's associate
> netdevice, in order to manage some non-IP, non-Ethernet, IB specific items
> (the recent SRIOV patches being a perfect example).

I'm not sure this is always going to be the case.  I have heard a number of reports of IPoIBs inability to scale and a desire to not run it.

> 
> I think we simply need to standardize on this.  As such, I think I want to make
> this a hard and fast rule: For those devices that aren't netdevices in their own
> right, management that can be done via their IPoIB device(s), should be done
> that way.  The Ethernet devices already have their own EEPROM writing
> code, so I see no reason why we can't add an EEPROM read/write hook to
> IPoIB and then pass that on down to the
> hfi1 device.
> 
> Unless people have objections to this as a way forward, Dennis, as much as
> possible, when you attempt to address the comments in this thread, please
> do so via the IPoIB devices and existing core net stack infrastructure.

I think I have to object, at least in the short term.

Isn't there a way we can create a netdevice that does not have the associated overhead of IPoIB?

Right now it is perfectly reasonable to run some nodes without the IPoIB module even loaded (SM management nodes for example).  What happens to storage target hardware which is Linux based?  Will they be forced to be in an IPoIB subnet?

In the past there have been virtual NIC implementations which could be used instead of IPoIB.  If those are supported are we still going to require IPoIB as well?

I think my biggest concern at this point is the additional load one would place on a large fabric if you required IPoIB.  We have made improvements in this area but even with the path record improvements we have made through netlink multicast join operations are still a scalability concern.  Furthermore, this requires a user space daemon to scale properly.  This is not exactly something you want to depend on just to load your device driver on a node.

I'd really like to explore how to get more integrated with the netdevice functionality without requiring an actual IP subnet device.

I feel like this is a bit too much of "force network technology X to look like network tech Y".  We are discussing Verbs 2.0 specifically because not all RDMA hardware looks like InfiniBand.  Therefore we are looking at ways to make the interface more generic.

I am not opposed to more integration with the netdev stack but I was thinking it would be more of making non-ethernet devices true netdevices, not forcing another emulation layer to be required for OPA to even function.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
