From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state
 for multicast
Date: Fri, 29 Apr 2016 20:37:09 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1604292035450.16783@east.gentwo.org>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com> <1461070287-13469-4-git-send-email-erezsh@mellanox.com> <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org> <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
 <20160427064239.GO7974@leon.nu> <5722C839.2070704@redhat.com> <c99ef08a-77d8-1524-042a-0f269a52028d@dev.mellanox.co.il> <20160429171246.GA4893@obsidianresearch.com> <c1bc7c93-53c9-8b71-16eb-2bb92df93b76@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c1bc7c93-53c9-8b71-16eb-2bb92df93b76-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 29 Apr 2016, Hal Rosenstock wrote:

> On 4/29/2016 1:12 PM, Jason Gunthorpe wrote:
> > On Fri, Apr 29, 2016 at 12:27:30PM -0400, Hal Rosenstock wrote:
> >>> You can never have a SendOnly_FullMember join.  Once you are FullMember,
> >>> you are no longer SendOnly.
> >>>
> >>> Is a NonMember (assuming here that NonMember is referring to what the CA
> >>> is listed as according to the SM) even allowed to join, either as
> >>> SendOnly or FullMember?  I would have thought if the SM listed that CA
> >>> as a NonMember, that any joins would be flat rejected and NonMember join
> >>> states wouldn't make any sense.
> >>
> >> There is now a new SendOnlyFullMember option added by IBTA MgtWG post
> >> IBA 1.3.
> >
> > As I understand it, this is done because the SendOnly Non-Member
> > essentially has useless reference counting semantics. FullMember
> > allows the group to be auto-created and continue to exist even if
> > there is only one SendOnly member.
>
> My understanding of this option is similar to the above.

The continued existence of the multicast group is important for Ethernet
gateways etc on the IB fabric. The Ethernet gateways will ignore join
requests from the Ethernet side if there is no IB multicast group.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
