From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 09:18:19 -0800
Message-ID: <20091215091819.c217cf36.weiny2@llnl.gov>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	<20091215170317.GV5262@me>
	<20091215171532.GA8288@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215171532.GA8288-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2009 10:15:32 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> > > However, I don't understand the comment "Only set HopLimit if going through a
> > > router"?
> > 
> > This is from '#ifdef ROUTER_EXP' days - as far as I could understand
> > HopLimit should be set to IB_HOPLIMIT_MAX for inter-subnet MADs.
> 
> If HopLimit is 0 then no GRH is required, if it is non 0 then the user
> of that path needs to apply a GRH. IIRC there are already a few things
> in the kernel that follow this?

Is that in the spec somewhere?  The follow on would be that if they specify a
DGID in the PathRecord query and the result is subnet local they must still
use a GRH even if the packet is going to stay local?  I think this makes sense
but I wonder if __everyone__ is following that?

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
