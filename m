From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_console.c: Support portstatus output for incorrect
 link speeds
Date: Fri, 22 Feb 2013 14:33:56 -0500
Message-ID: <5127C824.2090108@dev.mellanox.co.il>
References: <1361489963.24405.68.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361489963.24405.68.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 2/21/2013 6:39 PM, Albert Chu wrote:
> Usually coinciding with use of the force_link_speed configuration option,
> some link speeds can be observed to be incorrect.  For example, a link
> may be active at QDR even if SDR & DDR speeds are the only ones enabled.

Are you referring to the fact that after setting the enabled speed, the
IB spec does not mandate a link renegotiation and hence one may not have
occurred so the enabled speed can be out of whack with the active speed ?

Also, isn't there a similar issue with extended speeds (and
force_link_speed_ext) ? If so, should that also be part of this patch ?

Same issue also is there for link width as it works the same way as link
speed. Maybe that too is yet another patch.

What do you think ?

-- Hal

> Under these scenarios, the portstatus may incorrectly output port status,
> confusing users.
> 
> A new port output status of "incorrect speed" differentiates ports in this
> state from other states, so as to not confuse users.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
