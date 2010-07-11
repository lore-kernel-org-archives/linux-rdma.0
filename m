From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: When IBoE will be merged to upstream?
Date: Sat, 10 Jul 2010 22:34:50 -0600
Message-ID: <20100711043449.GA31404@obsidianresearch.com>
References: <20100624203701.GA4630@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com> <20100625155755.GC4630@obsidianresearch.com> <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com> <adak4pcnw3c.fsf@roland-alpha.cisco.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com> <4C32D0BD.3030902@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com> <4C3417FA.7000600@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 10, 2010 at 11:55:18AM +0300, Liran Liss wrote:

> "...A verbs consumer using a RoCE network relies strictly on
> so-called Layer 3 addressing (GIDs); layer 2 addresses (e.g. subnet
> local identifiers) are not passed across the verbs interface..."

Ah, hmm, well, I was on that list during this time and I don't think
this statement means what you are saying it does :)
 
> As opposed to what it may seem at first sight, adding Eth L2
> parameters to the address vector, *does not* make RoCE closer to IB.
> It actually goes the other way around.  Here is a quick list of what
> would have to be changed if we were to include Eth L2 address
> parameters to the Address Vector and other structures/functions that
> expose L2 params:

Umh, no.. Stick the L2 address in the GID itself, stick the vlan tag
in either the DLID or the PKey and you are done. No structures get
bigger, nothing really changes.

There are already AH differences between iwarp and IB and generic code
to handle them.

rdmacm can support address resultion only for UD applications.

Still not seeing how this is a big issue? 

You cannot hide destination resolution in create_ah. You just
can't. create_ah does not accept any sort of source address specifier
which is absolutely critical to reoslve a destination ip address in
all cases, ie for instance IPv6 link local addresses, but there are
other cases too.

If IP semantics are going to be used then *ALL* linux IP semantics
must be supported, not just those that are convinent to implement, and
that means you need a source IP address, device, QOS parameters and
destination IP address to make a route determination.

The only subsystem in verbs that has this information is RDMA CM.

To me this is a fundamental problem that completely nixes L3 path 
resolution in create_ah as a possible solution - as you explained
you need to do the L3 path resolution to figure out the vlan tag to
use, to get the desired IP netdevice, to execute the ND query..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
