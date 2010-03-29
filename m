From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 13:37:15 -0600
Message-ID: <20100329193715.GA28070@obsidianresearch.com>
References: <4BB0E670.3010507@opengridcomputing.com> <B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com> <adaiq8fvtos.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiq8fvtos.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 29, 2010 at 12:01:07PM -0700, Roland Dreier wrote:
>  > > The rdma_cm might be able to support this if the port space were separated based
>  > > on the address family, depending on how PS IB ends up.
>  > 
>  > I think separate port spaces is the correct solution.
> 
> This gets a bit tricky -- for normal IP stuff, there's the "bindv6only"
> sysctl (and the IPV6_V6ONLY socket option).  Without that, you can't
> bind an IPv4 socket to the same port as an IPv6 socket, since the IPv6
> socket will accept IPv4 connections via an v4->v6 mapped address.  (You
> can look at inet_csk_bind_conflict() to see the full complexity of the
> checking done when binding an IPv4 socket)

Yeah, exactly, it is very complex and there is a real need for
things pretending to be IP to capture all this subtlety. The details
can't just be skipped over, people will notice :(

Though, I'm also not entirely certain that NFS-RDMA is right to bind
to both AFs, generally speaking on Linux for a multi-protocol app you
only want to bind to v6 addresses.. Or is it using IPV6_V6ONLY or alike?

> I wonder what the right way from the RDMA CM to stay close to Linux
> sockets semantics without adding too much horror is.  (Adding Jason to
> the CC list since he usually has an opinion about things like this :)

Clearly the best way is to figure out some way to work with the
existing routines in the kernel. This stuff is complex and duplicating
all of it in rdma_cm would be annoying..

To match the semantics each CM ID would still register to one SID but
an incoming connection request on a v4 PF SID could be matched to a v6
SID, etc.

I don't think new port spaces in the API are desirable.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
