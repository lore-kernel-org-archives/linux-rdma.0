From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
 from ibnd_node_t
Date: Fri, 13 Nov 2009 00:59:56 +0200
Message-ID: <20091112225956.GA7192@me>
References: <1257190401.580.31.camel@auk31.llnl.gov>
 <1257196316.580.33.camel@auk31.llnl.gov>
 <20091106181633.GQ7192@me>
 <1257532494.18550.89.camel@auk31.llnl.gov>
 <20091112163105.GI7192@me>
 <20091112105930.4248e521.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091112105930.4248e521.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 10:59 Thu 12 Nov     , Ira Weiny wrote:
> 
> nodesdist was remove from the public interface.  Although an "advanced" user
> might have been able to use it, the data stored there was very scan specific.
> Removing it was a good idea for 2 reasons, 1) simplify the interface,

I don't see how this conceptually simplifies interface. I think that
it started from a wrong approach about having two data structure sets -
public and private. Now it requires cleaning again and again in order to
have simpler interface.

> 2) if
> the scan algorithm changed users might have to change the way they use the
> data; not good for compatibility.

Maybe, but let him to decide. Such usage is not mandatory.

> I agree there was some usefulness, sometimes.  However the path_portid can not
> be guaranteed to be valid.

Why not? Isn't it a valid on the last scan?

> Again there are multiple issues.  First I don't
> think we want to support to this to the users.

But you don't need to support it. Advanced use is developer's
responsibility.

> Second Al is working toward is
> the ability to cache the fabric information to be read back later.  Storing
> all this "scan" specific information is going to be extra work which is
> superfluous to the layout of the fabric.

Hard to say really without seeing any code, but you can simply keep all
this scan specific information over session and have a pointer field on
ibnd_fabric structure which refer this.

> > I cannot understand why are you trying to make things there as "private"
> > as technically possible (even on price of extra code size and
> > complexity). Finally it is an open source stuff, so let to users to use
> > it how they want and for their own responsibility. :)
> 
> Making things "private" allows us to change the library without breaking the
> interface.

I don't think

> Furthermore, it simplifies the interface for users who want to
> write code at a higher level.

I'm not asking to make high level life harder :). My point is to not
prevent from advanced developers to use available low level too,
especially when such preventing requires some extra efforts.

> My original design goals were 2 fold.  1. make
> a library which speeds up the functionality of the perl script tools.  2.
> Provide a C interface to a fast scan library which can be used to implement
> further tools which would have formerly been implemented via scripts around
> ibnetdiscover.

My purposes serve (2) very well. Isn't it?

> 
> Here is one use case we have been working off of.
> 
> One of our MPI developers here is not familiar with Infiniband. He has
> written many scripts around the current suite of tools for various research
> that he does.  The concepts of nodes, ports, and links are familiar to him but
> sending a "MAD" or differentiating between a GSI MAD vs SMP is not.  I want to
> give him information about nodes, links, ports, errors, data counters, routing
> tables, etc. without making him use the MAD layer, or worse yet, umad layer.

How having 'path_portid' in node structure enforces him to use the MAD
or umad (which is simpler than mad in general, IMO) layers? It doesn't.

> In this use case he does not care that libibnetdisc does a BFS and creates a
> nodesdist structure of some sort resulting from that algorithm.  Presenting a
> "fabric" with a list of "nodes" which further have some "ports" makes sense to
> a user like this.

Again, how having access to internal discovery stuff makes a life of
such users harder?

> This use case in addition to trying to cache the data makes a simpler, cleaner
> interface much more attractive.  :-D

And there is another use case (hypothetical yet) - one of our IB
developers is familiar with infiniband... Would such "high-level"-only
interface be so attractive for him?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
