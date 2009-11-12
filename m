From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
 from ibnd_node_t
Date: Thu, 12 Nov 2009 10:59:30 -0800
Message-ID: <20091112105930.4248e521.weiny2@llnl.gov>
References: <1257190401.580.31.camel@auk31.llnl.gov>
	<1257196316.580.33.camel@auk31.llnl.gov>
	<20091106181633.GQ7192@me>
	<1257532494.18550.89.camel@auk31.llnl.gov>
	<20091112163105.GI7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112163105.GI7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Nov 2009 18:31:05 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 10:34 Fri 06 Nov     , Al Chu wrote:
> > > 
> > > Why do you want to remove this? port->path_portid can be useful for
> > > logging, specific querying, etc.. Even node->dnext can be helpful for
> > > some "advanced" use too.
> > 
> > The 'nodesdist' array (which is what the 'dnext' pointer is used for) is
> > only used during the scan and is no longer available publicly.
> 
> Really? I thought that it could be a useful data for "advanced" uses.

nodesdist was remove from the public interface.  Although an "advanced" user
might have been able to use it, the data stored there was very scan specific.
Removing it was a good idea for 2 reasons, 1) simplify the interface, 2) if
the scan algorithm changed users might have to change the way they use the
data; not good for compatibility.

> 
> > So the
> > 'dnext' pointer doesn't serve a purpose being in the public ibnd_node_t
> > struct.
> > 
> > Post scan, the 'path_portid' was ony used in ibnd_update_node(), which
> > is now removed.
> 
> You are saying about libibnetdisc itself. My example was about an
> application which uses this. For instance after discovery application
> may want to query some ports for its own purpose. What is wrong with
> that?

I agree there was some usefulness, sometimes.  However the path_portid can not
be guaranteed to be valid.  Again there are multiple issues.  First I don't
think we want to support to this to the users.  Second Al is working toward is
the ability to cache the fabric information to be read back later.  Storing
all this "scan" specific information is going to be extra work which is
superfluous to the layout of the fabric.

> 
> > In addition, Ira and I felt it is one of the fields
> > that shouldn't have been exported out of libibnetdisc, it is far too
> > "scan specific" and shouldn't be public.
> 
> I cannot understand why are you trying to make things there as "private"
> as technically possible (even on price of extra code size and
> complexity). Finally it is an open source stuff, so let to users to use
> it how they want and for their own responsibility. :)

Making things "private" allows us to change the library without breaking the
interface.  Furthermore, it simplifies the interface for users who want to
write code at a higher level.  My original design goals were 2 fold.  1. make
a library which speeds up the functionality of the perl script tools.  2.
Provide a C interface to a fast scan library which can be used to implement
further tools which would have formerly been implemented via scripts around
ibnetdiscover.

Here is one use case we have been working off of.

One of our MPI developers here is not familiar with Infiniband.  He has
written many scripts around the current suite of tools for various research
that he does.  The concepts of nodes, ports, and links are familiar to him but
sending a "MAD" or differentiating between a GSI MAD vs SMP is not.  I want to
give him information about nodes, links, ports, errors, data counters, routing
tables, etc. without making him use the MAD layer, or worse yet, umad layer.
In this use case he does not care that libibnetdisc does a BFS and creates a
nodesdist structure of some sort resulting from that algorithm.  Presenting a
"fabric" with a list of "nodes" which further have some "ports" makes sense to
a user like this.

This use case in addition to trying to cache the data makes a simpler, cleaner
interface much more attractive.  :-D

Ira

[snip]

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
