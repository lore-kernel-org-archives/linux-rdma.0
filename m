From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
 from ibnd_node_t
Date: Thu, 12 Nov 2009 18:31:05 +0200
Message-ID: <20091112163105.GI7192@me>
References: <1257190401.580.31.camel@auk31.llnl.gov>
 <1257196316.580.33.camel@auk31.llnl.gov>
 <20091106181633.GQ7192@me>
 <1257532494.18550.89.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1257532494.18550.89.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:34 Fri 06 Nov     , Al Chu wrote:
> > 
> > Why do you want to remove this? port->path_portid can be useful for
> > logging, specific querying, etc.. Even node->dnext can be helpful for
> > some "advanced" use too.
> 
> The 'nodesdist' array (which is what the 'dnext' pointer is used for) is
> only used during the scan and is no longer available publicly.

Really? I thought that it could be a useful data for "advanced" uses.

> So the
> 'dnext' pointer doesn't serve a purpose being in the public ibnd_node_t
> struct.
> 
> Post scan, the 'path_portid' was ony used in ibnd_update_node(), which
> is now removed.

You are saying about libibnetdisc itself. My example was about an
application which uses this. For instance after discovery application
may want to query some ports for its own purpose. What is wrong with
that?

> In addition, Ira and I felt it is one of the fields
> that shouldn't have been exported out of libibnetdisc, it is far too
> "scan specific" and shouldn't be public.

I cannot understand why are you trying to make things there as "private"
as technically possible (even on price of extra code size and
complexity). Finally it is an open source stuff, so let to users to use
it how they want and for their own responsibility. :)

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
