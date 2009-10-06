From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 6 Oct 2009 17:17:20 -0600
Message-ID: <20091006231720.GR5191@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <20091006200739.GP5191@obsidianresearch.com> <B266C10D3C26431E8FF5012420132452@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B266C10D3C26431E8FF5012420132452-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 06, 2009 at 03:53:21PM -0700, Sean Hefty wrote:
> >Actually, thinking about it some more, that would be very helpful. As
> >I said before, I have worked on apps using IB CM. The only reason is
> >to have complete control over the addressing. If I could use RDMA CM
> >API in some kind of AF_GID addressing and service ID space, it would
> >basically eliminate the need for IB CM entirely and make it alot less
> >trouble to support things like iWarp, since it now just another AF/PF
> >in the same API family.
> 
> In order to maintain application level compatibility, there are a few
> requirements for the changes in this patch.  An event needs to be queued
> indicating that the librdmacm rdma_resolve_addr() call is complete.  The IB CM
> REQ message should carry the IP address, so that data should be set.  And the
> state of the rdma_cm_id needs to change.

All these APIs were put together pretty quickly, if we can move ahead
in a significant way by making minor adjustments (like adding a family
field here and there) then I think it is worth doing.

> I did consider the possibility of having the sockaddr contain some
> IB related address, with user space performing the mapping.  My
> thought was that the IP address needed to be given to the kernel
> since the IB CM message carries the IP address in the private data.
> The GID could actually be extracted from the rdma_set_ib_paths()
> call.

I'm not necessarily proposing that an IB centric RDMA CM interface
continue to use IP addressess, but that I can provide IB addresses
through the RDMA CM API and create IB CM connections. To me this is
really what your acm patch is attempting to do. That there is IP
addresses at all seems more of a convenience.

So, an AF_GID RDMA CM connection process would not (directly)
interoperate with an AF_IP/AF_IPV6 RDMA CM connection process.

> I'm not sure about defining a new address family for GIDs, given
> that a GID is already supposed to be an IPv6 address.  Maybe the
> RDMA CM could check whether an address mapped to IB GID or not.  If
> the source address of either an

GIDs are addresses that are formed like IPv6 addresses that occupy a
completely distjoint address space. It is correct to have them exist
in their own family (ie AF_GID). That is the only way to disambiguate
them from IPv6 addresses.

IETF has not (and probably will not) reserve an IPv6 prefix space for
GIDs, so there is no other way.

> could assume the same of the destination address.  Something would
> need to be done to determine what would go into the IB CM REQ, but
> that may introduce incompatibilities.

The same approach that the IB CM uses today would have to be
used. There would need to be technology specific APIs to set ancillary
data. The IP version already has APIs to set port numbers, GID based
RDMA CM would need APIs to set services IDs and so on, just like in
the IB CM case.

I'm not suggesting that you implement RMDA CM IP semantics in
userspace using the IB CM, I'm suggesting you expose the IB CM GID
semantics through the RDMA CM API exactly as they are. Your IBACM
would then become an enhanced path resolution module to the RDMA CM, 
much like getaddrinfo is to socket()/bind()/connect().

So the output from IBACM would specify on AF_GID address family and
include opaque data blobs that are passed through the RDMA CM API that
contain all the PR records, service ID, etc. If used on non-IB then
IBACM could just return AF_IP/AF_IPV6 and related blobs. Thus the
consumer of the API gets transparency and network protocol agility,
and all the mess can be hid in the address resolution API.

Like getaddrinfo it could be string based, and perhaps with some
careful thought we can make a string descriptor that can actually
expose some of the good IB functionality, like multipath, APM, etc.

Ie, perhaps if you get
 getrdmaaddrinfo("gid=fd83:609c:bdc8:1:213:72ff:fe29:e65d","123123232");
you would get data describing an IB CM connection using service ID
123123232 to GID fd83:609c:bdc8:1:213:72ff:fe29:e65d, while
 getrdmaaddrinfo("192.168.122.1%eth2","1243");
Would describe an IP based RDMA connection using device eth2 and port
1234.

And maybe, say
 getrdmaaddrinfo("acm=192.168.122.1%eth2","1243");
Invokes your new module, but the result is an AF_GID family connection.

Like in IP/IPv6 the connection process would proceed in exactly the
same way no matter if it is iWARP, IB RDMA, CEE RDMA, or
whatever. This model has worked very well for writing dual stack
IPv4/IPv6 applications.

> Note that between the two patches, this one is less important to
> scaling than the other one.  It would be ideal to avoid sending ARP
> requests when they are not needed.

Yes, I see that, but the ARP request is an absolutely critical part of
the IP world, to eliminate it, but still pretend to be IP really is
cheating too much, IMHO. :)

> >You get the source address via the user (netlink) or kernel
> >(ip_route_output_key) equivalent of 'ip route get x.x.x.x dev XXX'
> 
> Yes - ip route get gives what's needed.  Is there a simple way to
> obtain that same data from within a program?
 
Another topic, but yes, ip route get just does a netlink
queury. I can give you all the details if you want to try it.

However as I explained in the thread, I highly skeptical about all of
this. That query needs to be done exactly once and the connection must
be bound to that result from then on. Currently too many route lookups
are done, and adding more to userspace does not seem to be the right
direction - unless the userspace one replaces all the kernel lookups..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
