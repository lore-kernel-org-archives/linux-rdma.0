From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 28 Oct 2009 16:33:31 +0200
Message-ID: <4AE8563B.4010706@voltaire.com>
References: <20091021233639.GS14520@obsidianresearch.com>	<BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com>	<20091022002846.GU14520@obsidianresearch.com>	<4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com>	<20091022011939.GW14520@obsidianresearch.com>	<60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com>	<20091022062531.GB26003@obsidianresearch.com>	<4AE43BED.3090405@voltaire.com>	<20091025200332.GN26003@obsidianresearch.com>	<4AE6EF44.5040004@voltaire.com> <20091027171403.GP26003@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091027171403.GP26003-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Wow, seriously? You do understand the purpose of review, right?
I think I do, maybe not to the depth you and your arguments are, but 
again, repeating myself: my kind of simple argument is that your review 
is way beyond the --change-- suggested by a patch but rather of a whole 
logic, and you block a patch b/c you don't like the logic this patch 
integrates with. To some extent such practice is excepted, but you took 
it to way beyond acceptable limit. I don't accept your assertion that 
the whole logic is broken and it makes sense to me to have a patch from 
Dave to fix the IPv6 part of it. Next or in parallel you are welcome to 
sent a patch fixing/re-writing the whole bind logic or even the whole 
rdma stack or the whole kernel.

> And yes, actually, accounting for how rdma_bind() is different from bind() when doing route resolution is pretty much the main remaining problem
go and fix that

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
