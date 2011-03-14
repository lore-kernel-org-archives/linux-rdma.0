From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 16:14:15 -0600
Message-ID: <20110314221415.GB12991@obsidianresearch.com>
References: <4D7E27E4.7060606@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612@orsmsx501.amr.corp.intel.com>
 <4D7E3568.7010406@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39DF3@orsmsx501.amr.corp.intel.com>
 <4D7E8A25.8010701@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39E12@orsmsx501.amr.corp.intel.com>
 <4D7E8F60.7030006@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D7E8F60.7030006-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2011 at 04:57:52PM -0500, Steve Wise wrote:
> On 03/14/2011 04:40 PM, Hefty, Sean wrote:
> >>>-max_qp_rd_atom and the responder_resources value reported in the connect
> >>>-request event.
> >>>+max_qp_rd_atom, but preferably greater than or equal to the
> >>responder_resources
> >>>+value reported in the connect request event.
> >>>
> >>For iwarp, its a fatal connection termination if the responder resources
> >>(aka IRD) is overflowed by the peer.  Is it not
> >>fatal for an IB connection?
> >Yes - it's fatal.  With rdma_accept, the user _can_ specify a lower number of responder_resources than what the client side requested in their initiator_depth.  The client must then determine if the responder_resources that were offered is sufficient (at least with IB).  This is why I added 'preferably' to the documentation.
> 
> When you say 'client must then determine', do you mean the client
> application?  So the IB CM really just passes along these values and
> doesn't really enforce any semantics?
> 
> The reason I'm asking is we're reviewing the IETF ID that extends
> MPA connection setup to allow negotiating ORD/IRD.  And I think we
> should not diverge from the way its done in IB.  IE: the RDMACM
> semantics should be the same IMO.

Not sure how this is presented by RDMA CM, but the way it works on
the wire in IB is..
 - Client sends "client's max outgoing RR usage" and "client's max
   incoming RR available" [which is min(ULP request,HCA limit)]
 - Server computes:
    server's max outgoing RR usage = min(client's max
                              incoming RR available,ULP limit,HCA
			      limit)
    server's max incoming RR available = min(client's max outoing RR
                           usage,ULP limit,HCA limit)
   and sends it back.
 - Client should sanity check:
    server's max outgoing RR usage <= client's max incoming RR available
    server's max incoming RR available >= client's max outoing RR usage
   And the ULP should confirm it can function within the RR limit.
 - The four values are encoded into two pairs in the CM messages, the
   client pair is in the REQ and the server pair is in the REP.
   Both sides end up learning all four values, but only the server's
   values are used.

Basically, the equations:
 server max outgoing RR usage = client max incoming RR available =
     min(server ULP, client ULP, server HCA, client HCA);
 client max outgoing RR usage = server max incoming RR available =
     min(server ULP, client ULP, server HCA, client HCA);
are being computed. Each side's ULP should have the opportunity to
specify the maximum number of RRs it will consume at once when posting
send WR's, to avoid consuming global RRs in the HCA.

FWIW, I'm not sure this actually works in Linux, last time I looked
it only worked if all values were the same, which they generally are
since nearly everything seems wired to 4.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
