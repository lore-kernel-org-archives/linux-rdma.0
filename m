From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Fri, 9 Oct 2009 01:39:31 +0200
Message-ID: <15ddcffd0910081639l7398a511o24e946cf68428838@mail.gmail.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>
	 <4ACAF913.3050909@voltaire.com>
	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>
	 <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>
	 <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>
	 <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>
	 <20091008005425.GW5191@obsidianresearch.com>
	 <3BA5B96263EC4ACA8FF3C4D8DCF47C69@amr.corp.intel.com>
	 <20091008172120.GX5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091008172120.GX5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> If the listening side continues to use the IP mode to listen then I guess the
> client can compute an appropriate service ID, but it seems a bit
> strange for one side to use IP and the other side to use the ACM
> method? I was imagining you'd configure both sides to use the same  method.

1st, unlike IP, in IB only the active/connecting side does address
resolution, 2nd, the listener may be in the kernel where the active
may be user space, but anyway, ACM is an alternative way to do
destination gid resolution and path query emulation, I don't see what
it has to the with the CM protocol expect for keeping things the way
they were in this respect (rdma-cm IP header in the REQ, etc).

I don't see why if someone is resolving address through ACM they
aren't PS_TCP consumers.

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
