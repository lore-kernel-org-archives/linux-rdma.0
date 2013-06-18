From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Node Description mismatch between saquery & smpquery
Date: Tue, 18 Jun 2013 11:14:41 -0700
Message-ID: <1371579281.19017.86.camel@auk59.llnl.gov>
References: <1371505093.19017.76.camel@auk59.llnl.gov>
	 <51C040C7.9070109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C040C7.9070109-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2013-06-18 at 07:13 -0400, Hal Rosenstock wrote:
> On 6/17/2013 5:38 PM, Albert Chu wrote:
> > We've recently noticed that the Node Description for a node can
> > mis-mismatch between the output of smpquery and saquery.  For example:
> > 
> > # smpquery NodeDesc 427
> > Node Description:.................sierra1932 qib0
> > 
> > # saquery NodeRecord 427 | grep NodeDesc
> >                 NodeDescription.........QLogic Infiniband HCA
> > 
> > A restart of OpenSM is the current solution to resolve this.
> > 
> > We've noticed it occurring more often on our larger clusters than our
> > smaller clusters, leading to a speculation about why it is happening.
> > 
> > The speculation is when a node comes up, there is a window of time in
> > which the HCA is up, can be scanned by OpenSM, but not yet have its node
> > descriptor set (in RHEL I appears to be set via /etc/init.d/rdma).
> > During this window, OpenSM reads/stores the non-desired node descriptor
> > (in the above case the non-desired "Qlogic Infiniband HCA").
> > 
> > When the node descriptor is changed, a trap should be sent to opensm
> > indicating the change.  Normally OpenSM gets the trap and reads the new
> > node descriptor.
> 
> Are you sure the trap is being issued by those devices when the
> NodeDescription is changed locally ?

These particular devices do support the trap and tests show they do send
traps on changes (i.e. manually
changing /sys/class/infiniband/qib0/node_desc).

> Also, if so, do these devices implement timeout/retry on sending the
> trap (e.g. trying to make sure that they receive trap repress before
> giving up on trap) ?

This I don't know.  I've been trying to figure out if they do and if
they do how it might be configurable.  Is there a way to figure this
out?

> > On our large clusters all nodes are typically brought up at the same
> > time, so there are probably a ton of node descriptor change traps
> > happening at the exact same time.  We speculate a number of these are
> > dropped/lost, and subsequently OpenSM never realizes that the node
> > descriptor has changed.
> 
> Do you see any evidence of that traps are being dropped ? Have you
> correlated any VL15Dropped counters in the subnet with this ? Also,
> there is a module parameter in MAD kernel module that might help with
> any unsolicited MAD bursts. You might try increasing that on your SM
> node(s).

On our largest clusters we always see a nice chunk of VL15 drops,
however we haven't correlated them specifically to a trap.

> > I don't know if the speculation sounds reasonable or not.  Regardless,
> > we're not sure of the best fix.
> > 
> > A trivial fix would be to just make OpenSM re-scan the node descriptor
> > of an HCA, perhaps during a heavy sweep.  But I don't know if this is
> > optimal.  It'll introduce more MADs on the wire.  However if the present
> > solution is to restart OpenSM, we figure this can't be any worse.
> 
> Yes, but to add the additional queries in is O(n) there and has been
> resisted in the past.
> 
> > Just wondering what peoples thoughts are of if there's another obvious
> > solution we're not seeing.
> 
> I think this issue needs better understanding first.

Yeah, just looking for hints/pointers for the time being.

Thanks,

Al

> -- Hal
> 
> > Al
> > 
> 
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
