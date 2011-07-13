From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/4] infiniband-diags: properly resolve node guids
Date: Tue, 12 Jul 2011 23:09:44 -0600
Message-ID: <20110713050944.GB26663@obsidianresearch.com>
References: <20110705120815.3cc7d59b.weiny2@llnl.gov>
 <4E1779CE.9030502@dev.mellanox.co.il>
 <20110708215046.GB10216@obsidianresearch.com>
 <4E177DA5.9030600@dev.mellanox.co.il>
 <20110708152953.0063fb7b.weiny2@llnl.gov>
 <20110708225510.GC10216@obsidianresearch.com>
 <20110711140602.9ae3943e.weiny2@llnl.gov>
 <20110711211843.GD10216@obsidianresearch.com>
 <20110712165250.a3cb9d47.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110712165250.a3cb9d47.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 12, 2011 at 04:52:50PM -0700, Ira Weiny wrote:

> > And, I don't think there is anything wrong with reporting a whole
> > switch node either - but the portGUID should be identifier, not the
> > node GUID.
> 
> Ok, I see where you are coming from but I am not sure I agree with you.
> 
> I guess I don't see an issue with using NodeGUID as a unique ID for a node.
> The node-name-map functionality in complib provides a translation from
> NodeGUID's to names.  (For those NodeDescriptions which are not programmable
> in FW.)

Well, I never liked that functionality in complib either ;) I'd have
been much happier if portGUID was the key. That avoids the ambiguity
of refering to mulitple ports using a single name, and avoids needing
to do a NodeInfoRecord query followed by a PathRecord query to setup
a path to a user defined name.

> > Ie, admins should never need to know what the node GUID is, and they
> > certainly should not be required to keep track of both a port GUID and
> > a node GUID for every CA just to use one tool or another.
> 
> I see your point.  However, I don't think it is correct to consider
> a PortGUID a representation of a node.  Specifically what does
> "iblinkinfo" print for a [E]SP0 PortGUID?  (for example when not run
> with "--all-ports"). iblinkinfo and by derivation ibqueryerrors
> reports information for all the links (all the ports) on a node.

A tool should behave exactly the same if it is given a GID, port GUID, LID
or directed route path (and perhaps in future an IP address that would
be ARP'd to get a GID). Not supporting those address options in a tool
goes against the UI design of every other tool in the diags suite.

For a program like iblinkinfo I think it would be appropriate to show
the entire switch, and to show only the single CA port. IIRC this is
what the ibtool version of iblinkinfo does.

If you think displaying an entire CA node is appropriate then use the
SA to translate from a standard end port identifier to a node GUID and
then use the SA to enumerate all the CA node end ports. Don't require
the user to enter a node identifier just to avoid some processing in a
diag tool :(

The point is, nobody should be expected to know what node GUIDs are,
we want people to refer to fabric devices by GID, LID or DR path,
which are all more natural.

> Frankly this is a part of the spec which I consider convoluted and perhaps
> there is no good way around it.  Specifically querying NodeInfo on a Node
> changes depending on which port the NodeInfo was requested on.  This just
> seems wrong.  ;-)

NodeInfo and the NodeGUID exist in the form they do to make discovery
work, and they work well in that capacity.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
