From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 09:48:39 -0800
Message-ID: <20091215094839.8cd94ba6.weiny2@llnl.gov>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	<20091215170317.GV5262@me>
	<20091215171532.GA8288@obsidianresearch.com>
	<20091215091819.c217cf36.weiny2@llnl.gov>
	<20091215173140.GB8288@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215173140.GB8288-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2009 10:31:40 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

[snip]

> 
> The spec provides no guidance whatsoever on how to tell if a packets
> generated from a PR need a GRH or not. The only other choice is to
> compare the resulting DGID against all the GID prefixs on the port and
> see if any match.
> 
> If a router spec is ever written I'm sure it will clarify this matter,
> and everyone will follow.
> 
> The SM decides what hop limit should be so the SM decides if it needs
> a GRH. I belive the original long ago version of this always set the
> hop limit to 0 unless the DLID was a router port.

Ok, then I think we need a new way to tell if we are hitting a router port in
pr_rcv_build_pr.  I don't think having a non-zero GID is the definition of
going through a router port.

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
