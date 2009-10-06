From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 6 Oct 2009 14:07:39 -0600
Message-ID: <20091006200739.GP5191@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AA7E7C8FC2A04B9688CD69CEB7355DF8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 06, 2009 at 12:05:02PM -0700, Sean Hefty wrote:

> From user space, the call sequence does not change.  The user calls
> rdma_resolve_addr, rdma_resolve_route, rdma_connect, etc.  It is up to the
> librdmacm to perform the resolution.  Today, the resolution request is simply
> passed down to the kernel, which restricts how the resolution can be performed.

Well, that is the whole trade off for using IP based addressing via
RDMA CM - you completely give up the IB addressing
architecture. Having an option for user space to specify an IP address
and a HW address is just really very, very strange.

I understand why you'd want to do this, but it is just such a brutal
hack..

IMHO, I think the fundamental problem is that RDMA CM is tied to IP
(ie iWarp addressing). This was probably a mistake. We really needed a
protocol and address agnostic CM API that can work with RDMA IB, iWARP
and standard IB CM protocols, using the appropriate protocol specific
addressing family and mechanism in each case.

Then you could have ACM provide GID based PR addressing using IB CM
within the RDMA CM API and it doesn't create such a complex mess. This
would then mirror how sockets work.

Actually, thinking about it some more, that would be very helpful. As
I said before, I have worked on apps using IB CM. The only reason is
to have complete control over the addressing. If I could use RDMA CM
API in some kind of AF_GID addressing and service ID space, it would
basically eliminate the need for IB CM entirely and make it alot less
trouble to support things like iWarp, since it now just another AF/PF
in the same API family.

> (FYI - I have not yet implemented the librdmacm to call
> rdma_bind_addr as part of rdma_resolve_route on linux.  I did not
> see an easy way to convert a destination IP address to a source IP
> address.  If anyone knows how, please let me know.)

Isn't this related to the now several threads discussing how route
resolution in the RDMA CM is busted?

http://lists.openfabrics.org/pipermail/general/2009-July/060612.html

You get the source address via the user (netlink) or kernel
(ip_route_output_key) equivalent of 'ip route get x.x.x.x dev XXX'

I wonder if Leo ever figured this out?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
