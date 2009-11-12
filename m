From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
 from ibnd_node_t
Date: Fri, 13 Nov 2009 00:31:42 +0200
Message-ID: <20091112223142.GZ7192@me>
References: <1257190401.580.31.camel@auk31.llnl.gov>
 <1257196316.580.33.camel@auk31.llnl.gov>
 <20091106181633.GQ7192@me>
 <1257532494.18550.89.camel@auk31.llnl.gov>
 <20091112163105.GI7192@me>
 <1258048268.31785.185.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1258048268.31785.185.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 09:51 Thu 12 Nov     , Al Chu wrote:
> 
> > Really? I thought that it could be a useful data for "advanced" uses.
> 
> It was removed in commit 094f922a34d6378d6a3bd1d137f90d6530685f94.  It
> was a simpler version of a patch that Ira had proposed on the mailing
> list.

This means that I'm applying patches too quickly :)

Then 'dest' is likely useless without such array, but 'portid' is not.

> > I cannot understand why are you trying to make things there as 
> > "private" as technically possible (even on price of extra code size 
> > and complexity). Finally it is an open source stuff, so let to users 
> > to use it how they want and for their own responsibility. :)
> 
> At the core of this patch (as well as some other patches I've submitted
> on libibnetdiscover before), is cleaning up the interface of
> libibnetdisc to be just the "core" of libibnetdisc.  We could stick
> anything into the public structs that could have potential usefulness,
> but at some point I think we need to limit ourselves to only the core
> stuff.  Why not add the ibmad_port to the structs?  Or instead of
> putting just the guids or lids in the structs, why not also the pkeys,
> capability masks, or VL tables?

This can be done (if needed), but will require some efforts, and this is
not what I'm asking for. I'm just proposing to not remove potentially
useful things, that is all and this is for no price.

And cleaning interface is a good thing.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
