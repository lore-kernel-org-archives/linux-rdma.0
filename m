From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
	from ibnd_node_t
Date: Fri, 13 Nov 2009 09:50:46 -0800
Message-ID: <1258134646.31785.294.camel@auk31.llnl.gov>
References: <1257190401.580.31.camel@auk31.llnl.gov>
	 <1257196316.580.33.camel@auk31.llnl.gov> <20091106181633.GQ7192@me>
	 <1257532494.18550.89.camel@auk31.llnl.gov> <20091112163105.GI7192@me>
	 <1258048268.31785.185.camel@auk31.llnl.gov>  <20091112223142.GZ7192@me>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112223142.GZ7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Sasha,

On Fri, 2009-11-13 at 00:31 +0200, Sasha Khapyorsky wrote:
> Hi Al,
> 
> On 09:51 Thu 12 Nov     , Al Chu wrote:
> > 
> > > Really? I thought that it could be a useful data for "advanced" uses.
> > 
> > It was removed in commit 094f922a34d6378d6a3bd1d137f90d6530685f94.  It
> > was a simpler version of a patch that Ira had proposed on the mailing
> > list.
> 
> This means that I'm applying patches too quickly :)
> 
> Then 'dest' is likely useless without such array, but 'portid' is not.

I'll go ahead and post a modified patch that only splits out 'dnext'.

Al

> > > I cannot understand why are you trying to make things there as 
> > > "private" as technically possible (even on price of extra code size 
> > > and complexity). Finally it is an open source stuff, so let to users 
> > > to use it how they want and for their own responsibility. :)
> > 
> > At the core of this patch (as well as some other patches I've submitted
> > on libibnetdiscover before), is cleaning up the interface of
> > libibnetdisc to be just the "core" of libibnetdisc.  We could stick
> > anything into the public structs that could have potential usefulness,
> > but at some point I think we need to limit ourselves to only the core
> > stuff.  Why not add the ibmad_port to the structs?  Or instead of
> > putting just the guids or lids in the structs, why not also the pkeys,
> > capability masks, or VL tables?
> 
> This can be done (if needed), but will require some efforts, and this is
> not what I'm asking for. I'm just proposing to not remove potentially
> useful things, that is all and this is for no price.
> 
> And cleaning interface is a good thing.
> 
> Sasha
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
