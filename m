From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: RE: Node Description mismatch between saquery & smpquery
Date: Mon, 17 Jun 2013 16:58:17 -0700
Message-ID: <1371513497.19017.77.camel@auk59.llnl.gov>
References: <1371505093.19017.76.camel@auk59.llnl.gov>
	 <2807E5FD2F6FDA4886F6618EAC48510E020A19F2@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E020A19F2-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2013-06-17 at 22:00 +0000, Weiny, Ira wrote:
> Does running "update_desc" in the console fix this?

This worked as a short term solution.  But we're still thinking about a
longer term one that requires less interaction.

Al

> Ira
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Albert Chu
> > Sent: Monday, June 17, 2013 2:38 PM
> > To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Node Description mismatch between saquery & smpquery
> > 
> > We've recently noticed that the Node Description for a node can mis-
> > mismatch between the output of smpquery and saquery.  For example:
> > 
> > # smpquery NodeDesc 427
> > Node Description:.................sierra1932 qib0
> > 
> > # saquery NodeRecord 427 | grep NodeDesc
> >                 NodeDescription.........QLogic Infiniband HCA
> > 
> > A restart of OpenSM is the current solution to resolve this.
> > 
> > We've noticed it occurring more often on our larger clusters than our smaller
> > clusters, leading to a speculation about why it is happening.
> > 
> > The speculation is when a node comes up, there is a window of time in which
> > the HCA is up, can be scanned by OpenSM, but not yet have its node
> > descriptor set (in RHEL I appears to be set via /etc/init.d/rdma).
> > During this window, OpenSM reads/stores the non-desired node descriptor
> > (in the above case the non-desired "Qlogic Infiniband HCA").
> > 
> > When the node descriptor is changed, a trap should be sent to opensm
> > indicating the change.  Normally OpenSM gets the trap and reads the new
> > node descriptor.
> > 
> > On our large clusters all nodes are typically brought up at the same time, so
> > there are probably a ton of node descriptor change traps happening at the
> > exact same time.  We speculate a number of these are dropped/lost, and
> > subsequently OpenSM never realizes that the node descriptor has changed.
> > 
> > I don't know if the speculation sounds reasonable or not.  Regardless, we're
> > not sure of the best fix.
> > 
> > A trivial fix would be to just make OpenSM re-scan the node descriptor of an
> > HCA, perhaps during a heavy sweep.  But I don't know if this is optimal.  It'll
> > introduce more MADs on the wire.  However if the present solution is to
> > restart OpenSM, we figure this can't be any worse.
> > 
> > Just wondering what peoples thoughts are of if there's another obvious
> > solution we're not seeing.
> > 
> > Al
> > 
> > --
> > Albert Chu
> > chu11-i2BcT+NCU+M@public.gmane.org
> > Computer Scientist
> > High Performance Systems Division
> > Lawrence Livermore National Laboratory
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
