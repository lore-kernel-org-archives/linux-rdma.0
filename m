From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: enable perfmgr build by default
Date: Fri, 8 Jul 2011 10:13:13 -0700
Message-ID: <20110708101313.60512582.weiny2@llnl.gov>
References: <20110706151116.79c187ea.weiny2@llnl.gov>
	<20110708104927.GC7420@calypso.voltaire.com>
	<20110708090658.f15b95b0.weiny2@llnl.gov>
	<4E172F16.1000708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E172F16.1000708-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 8 Jul 2011 09:23:50 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Ira,
> 
> On 7/8/2011 12:06 PM, Ira Weiny wrote:
> > However, when we first put the PerfMgr in OpenSM there was some concern for developers who may be using OpenSM in an embedded environment.
> 
> Do you recall the specific concerns ? I forget and would rather not dig
> them out unless really necessary...

If I recall there was no "specific" concern just that someone _may_ do this.

Also I think there was some concern about the PerfMgr taking too much processing time with it's threads.  But I think that is configurable by the number of SMP's on the wire and turning it off if one prefers a different model.

Ira

> 
> -- Hal


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
