From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Node Description mismatch between saquery & smpquery
Date: Tue, 18 Jun 2013 22:07:42 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E020A8CB1@CRSMSX101.amr.corp.intel.com>
References: <1371505093.19017.76.camel@auk59.llnl.gov>
	 <51C040C7.9070109@dev.mellanox.co.il>
 <1371579281.19017.86.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371579281.19017.86.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> Subject: Re: Node Description mismatch between saquery & smpquery
> 
> On Tue, 2013-06-18 at 07:13 -0400, Hal Rosenstock wrote:
> > On 6/17/2013 5:38 PM, Albert Chu wrote:
> > > We've recently noticed that the Node Description for a node can
> > > mis-mismatch between the output of smpquery and saquery.  For
> example:
> > >
> > > # smpquery NodeDesc 427
> > > Node Description:.................sierra1932 qib0
> > >
> > > # saquery NodeRecord 427 | grep NodeDesc
> > >                 NodeDescription.........QLogic Infiniband HCA
> > >
> > > A restart of OpenSM is the current solution to resolve this.

[snip]

> > >
> > > When the node descriptor is changed, a trap should be sent to opensm
> > > indicating the change.  Normally OpenSM gets the trap and reads the
> > > new node descriptor.
> >
> > Are you sure the trap is being issued by those devices when the
> > NodeDescription is changed locally ?
> 
> These particular devices do support the trap and tests show they do send
> traps on changes (i.e. manually changing
> /sys/class/infiniband/qib0/node_desc).
> 
> > Also, if so, do these devices implement timeout/retry on sending the
> > trap (e.g. trying to make sure that they receive trap repress before
> > giving up on trap) ?
> 
> This I don't know.  I've been trying to figure out if they do and if they do how
> it might be configurable.  Is there a way to figure this out?
> 

Looking quickly at the driver I don't think it does resend the trap.  However, Mike might know better: CC'ed.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
