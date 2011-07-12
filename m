From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 3/4] infiniband-diags: properly resolve node guids
Date: Tue, 12 Jul 2011 16:52:50 -0700
Message-ID: <20110712165250.a3cb9d47.weiny2@llnl.gov>
References: <20110705120815.3cc7d59b.weiny2@llnl.gov>
	<4E1779CE.9030502@dev.mellanox.co.il>
	<20110708215046.GB10216@obsidianresearch.com>
	<4E177DA5.9030600@dev.mellanox.co.il>
	<20110708152953.0063fb7b.weiny2@llnl.gov>
	<20110708225510.GC10216@obsidianresearch.com>
	<20110711140602.9ae3943e.weiny2@llnl.gov>
	<20110711211843.GD10216@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110711211843.GD10216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 11 Jul 2011 14:18:43 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Mon, Jul 11, 2011 at 02:06:02PM -0700, Ira Weiny wrote:
> 
> > > But very few diags seem to be designed around the idea that they will
> > > operate on a bundle of end ports (eg a node), they tend to be one end
> > > port only, so asking for a "node" is nonsense.
> > 
> > Why do you object to tools which report information for an entire
> > node?  Nodes, specifically switches, are much more manageable chunks
> > than an entire fabric.
> 
> I don't object to that, I'm just pointing out that most of the tools
> aren't like that today, and many don't have a clear way to format
> their output in a multi-end-port format.
> 
> And, I don't think there is anything wrong with reporting a whole
> switch node either - but the portGUID should be identifier, not the
> node GUID.

Ok, I see where you are coming from but I am not sure I agree with you.

I guess I don't see an issue with using NodeGUID as a unique ID for a node.
The node-name-map functionality in complib provides a translation from
NodeGUID's to names.  (For those NodeDescriptions which are not programmable
in FW.)

> 
> > > I don't like this trend to make node GUID the default GUID input
> > > format for diags. FWIW, ibtool consistently uses port GUID as the
> > > default GUID type for all end port specifications.
> > 
> > I am not proposing this for all tools.  Why shouldn't a user be able to query
> > more than a single port at a time in some "higher level" tools?
> 
> I'd much rather see only portGUID used as an argument and a
> --all-ports option that would report all HCA ports - by automatically
> doing the necessary SA operations to find them. This is much better
> than having to force an admin to use port GUIDs in some tools and node
> GUID in (very few) other tools.
> 
> Ie, admins should never need to know what the node GUID is, and they
> certainly should not be required to keep track of both a port GUID and
> a node GUID for every CA just to use one tool or another.

I see your point.  However, I don't think it is correct to consider a PortGUID
a representation of a node.  Specifically what does "iblinkinfo" print for a
[E]SP0 PortGUID?  (for example when not run with "--all-ports"). iblinkinfo and
by derivation ibqueryerrors reports information for all the links (all the
ports) on a node.

Frankly this is a part of the spec which I consider convoluted and perhaps
there is no good way around it.  Specifically querying NodeInfo on a Node
changes depending on which port the NodeInfo was requested on.  This just
seems wrong.  ;-)

To me when I wrote iblinkinfo it just made sense that you would request
information about a particular node (specifically switch).  Otherwise the
output would be pretty stupid for a switch PortGUID.  Therefore the NodeGUID
seemed reasonable.

> 
> > Also how would you propose to resolve a query via NodeDescription?
> > Put yourself in the shoes of the administrator who is trying to
> > manage 1000's of "nodes" in a system.  Names are much easier to deal
> > with than GUID's and LID's.
> 
> I've no objection to searching by node description, as long as the
> tool supports a multiple end port output format. Don't see what this
> has to do with node GUID support :)

Only that searching for NodeRecords to resolve nodes on the fabric is a
reasonable way to go.  This patch moves in that direction.

Ira

> 
> Jason


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
