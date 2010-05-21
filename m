From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Proposal for adding ib_usa to the Linux Infiniband Subsystem
Date: Fri, 21 May 2010 10:50:18 -0600
Message-ID: <20100521165018.GA8856@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D12E@MNEXMB1.qlogic.org> <C14850BAABFD4BE789736D497B1DC825@amr.corp.intel.com> <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D170-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've said this before, but again..

There are too many orthogonal interfaces here. We really don't need
more libraries or kernel modules or /dev/ devices. Really.

Subscribing and multiplexing notifications from a GSI service should
just be a general function in the mad code..

On Fri, May 21, 2010 at 10:57:48AM -0500, Mike Heinz wrote:
> Would it be better to omit the multicast support from ib_usa and simply add it as a way to handle notifications?
> 
> From: Sean Hefty [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
> Sent: Friday, May 21, 2010 11:30 AM
> To: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: Proposal for adding ib_usa to the Linux Infiniband Subsystem
> 
> >Why is this needed?
> >The SA protocol allows notices and multicast membership to be managed at a CA
> >port level.? As a result, if multiple processes want to receive notices or join
> >multicast groups, that registration must be coordinated per CA port.? Existing
> >code in the Linux kernel exists for this purpose, coordinating the needs of
> >various Infiniband kernel modules and presenting a single "per server CA port"
> >perspective to the SA.? The IB user space SA module provides a mechanism for
> >user space applications to take advantage of this existing kernel code for
> >managing SA registrations.
> 
> The AF_IB support that is being requested for the rdma_cm would provide greater
> support for IB multicast join/leave membership.  Some additional work would be
> needed to allow the user to specify the full MCMemberRecord, but the basic
> infrastructure should be there.  Just mentioning this as a possibility.  (The IB
> ACM code joins multicast groups using libibumad and sends MADs directly to the
> SA.)
> 
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
