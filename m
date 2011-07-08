From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: enable perfmgr build by default
Date: Fri, 8 Jul 2011 09:06:58 -0700
Message-ID: <20110708090658.f15b95b0.weiny2@llnl.gov>
References: <20110706151116.79c187ea.weiny2@llnl.gov>
	<20110708104927.GC7420@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110708104927.GC7420-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 8 Jul 2011 03:49:27 -0700
Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Hi Ira,
> 
> On 15:11 Wed 06 Jul     , Ira Weiny wrote:
> > This should at least be compiled in by default.
> > 
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> 
> Sounds like a good idea.
> If we change the defaults, why should we keep this option for configure
> script? Is it really needed?

For our needs, no.  However, when we first put the PerfMgr in OpenSM there was some concern for developers who may be using OpenSM in an embedded environment.  Since the option exists (less work for me!) I did not see a good reason to take it out so that those developers could still compile it out if they wanted.  If this is no longer a requirement then, yes, I can remove the configure option.

Does anyone else want to chime in here?

> What about performance manager profiling? Shout it also compiled by default?

I think this may affect performance.  Although I don't think by much.  Since it is more of a development/debugging tool rather than something I think the user would want I thought it should still be a compile option.  If we do compile it on by default I would put an option in opensm.conf.

Let me know and I can alter the patch as you wish,
Ira

> 
> -- Alex


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
