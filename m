From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_console.c: Support portstatus output for
	incorrect link speeds
Date: Fri, 22 Feb 2013 15:20:50 -0800
Message-ID: <1361575250.24405.104.camel@auk59.llnl.gov>
References: <1361489963.24405.68.camel@auk59.llnl.gov>
	 <5127C824.2090108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5127C824.2090108-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-02-22 at 14:33 -0500, Hal Rosenstock wrote:
> Hi Al,
> 
> On 2/21/2013 6:39 PM, Albert Chu wrote:
> > Usually coinciding with use of the force_link_speed configuration option,
> > some link speeds can be observed to be incorrect.  For example, a link
> > may be active at QDR even if SDR & DDR speeds are the only ones enabled.
> 
> Are you referring to the fact that after setting the enabled speed, the
> IB spec does not mandate a link renegotiation and hence one may not have
> occurred so the enabled speed can be out of whack with the active speed ?

Now that I re-read my patch comment, it wasn't the clearest.

What you describe above very well could have occurred or maybe it was
just bad hardware.  The key was that ports were running at speeds (e.g.
QDR) that were not enabled (e.g. only SDR & DDR) and the current opensm
console was reporting invalid/incorrect error messages.

> Also, isn't there a similar issue with extended speeds (and
> force_link_speed_ext) ? If so, should that also be part of this patch ?
>
> Same issue also is there for link width as it works the same way as link
> speed. Maybe that too is yet another patch.
>
> What do you think ?

Yeah, I should have done those as well.  I was only solving the one
particular bug found.  I'll rework the patch.

Al

> -- Hal
> 
> > Under these scenarios, the portstatus may incorrectly output port status,
> > confusing users.
> > 
> > A new port output status of "incorrect speed" differentiates ports in this
> > state from other states, so as to not confuse users.
> > 
> > Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> 
> <snip...>
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
