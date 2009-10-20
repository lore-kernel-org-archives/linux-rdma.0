From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 15:30:29 -0600
Message-ID: <20091020213029.GK14520@obsidianresearch.com>
References: <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <20091020183132.GE14520@obsidianresearch.com> <A47D2FC6B143436DB87704307B0E715D@amr.corp.intel.com> <20091020191821.GI14520@obsidianresearch.com> <8D09997BDBC5482C86EAD338F19C8030@amr.corp.intel.com> <20091020202902.GJ14520@obsidianresearch.com> <B7BCBF813BF447B28330C2DB8F1437D6@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B7BCBF813BF447B28330C2DB8F1437D6-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 01:48:34PM -0700, Sean Hefty wrote:
> >Private data:
> >- AF_IB/PS_TCP - the kernel munges the private data to be compatible
> >  with AF_INET/PS_TCP, but otherwise is the same.
> >- AF_IB/PS_IB - the kernel doesn't touch the private data.
> 
> I was thinking AF_IB/* - kernel doesn't touch the private data, as
> it lacks the necessary information.

That was my first thinking as well.. 

If you want to go that way then I suggest compltely ditching
AF_IB/PS_TCP and extend PS_IB to include the service ID mask.

Basically, in PS_IB, you get to specify a service ID and a service ID
mask. When you bind the kernel keeps the unmasked bits and computes
masked bits.

Presenting a service ID + mask in the IP RDMA CM service ID format
will cause the kernel to allocate a 'port'.

This scheme is then also re-usable for other things, like IBTA defined
SDP port service ID allocation, and 'Local OS Administered Service IDs'

Basically, we just deal with the port problem as a sub-case of the
general service ID allocation problem.

The IB CM learns how to do this and the RDMA CM AF_INET/PS_TCP just
does exactly the above inside the kernel to avoid collision problems.
(IB CM just does while (!exists((rand() & ~mask | serviceID))) to
 choose an appropriate random unused service ID.)

Actually, this is pretty nice - probably should do it no matter what
for AF_IB/PS_IB

Could we get rid of PS_SDP too like this?

> >What about the service_mask feature of IB CM?
> 
> not sure - Is it needed in user space?

I don't have a clear idea how the service mask was intended to
be used to comment much on this. But it seems useful for the above.

> >How are the IP source and dest IPs going to be picked in for PS_TCP
> >mode?
> >
> >I guess user space does that and passes it through to the kernel?
> 
> It could pass the private data when calling rdma_connect.

Well.. The main problem I see with this is that it does not fit very
well into a rdma_getaddrinfo model. rdma_getaddrinfo should not
allocate any resources - but it should provide the private data
prefix (if any).

So.. the private data is either constructed in the kernel, or in
librdmacm. Both have different issues, librdmacm needs to retrieve a
source port from the kernel, or the kernel needs to get the IP data
from userspace. Both troublesome.

Can we just do away with the source port? Set it to 1234 or rand() or
something?  If this is only going to be used for ACM I'd be inclined
to do this because it is nice and simplifying.

The source port is pretty useles anyhow, the only app level purpose it
ever served in IP was to determine if a remote process might be root
by having it present a < 1024 source port. But that usage is extremely
rare (and broken with IB, nothing enforces this).

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
