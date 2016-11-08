From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic
Date: Tue, 8 Nov 2016 15:36:18 +0530
Message-ID: <20161108100617.GA2812@chelsio.com>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
 <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
 <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
 <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
 <1477885208.27946.8.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477885208.27946.8.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday, October 10/31/16, 2016 at 09:10:08 +0530, Nicholas A. Bellinger wrote:
> Hi Steve, Potnuri, & Co,
> 
> On Tue, 2016-10-18 at 09:34 -0500, Steve Wise wrote:
> > > 
> > > > I tried out this change and it works fine with iwarp. I dont see SQ
> > > > overflow. Apparently we have increased the sq too big to overflow. I am
> > going
> > > > to let it run with higher workloads for longer time, to see if it holds
> > good.
> > > 
> > > Actually on second thought, this patch is an overkill. Effectively we
> > > now set:
> > > 
> > > MAX_CMD=266
> > > and max_rdma_ctx=128 so together we take 394 which seems to too much.
> > > 
> > > If we go by the scheme of 1 rdma + 1 send for each IO we need:
> > > - 128 sends
> > > - 128 rdmas
> > > - 10 miscs
> > > 
> > > so this gives 266.
> > > 
> > > Perhaps this is due to the fact that iWARP needs to register memory for
> > > rdma reads as well? (and also rdma writes > 128k for chelsio HW right?)
> > >
> > 
> > iWARP definitely needs to register memory for the target of reads, due to
> > REMOTE_WRITE requirement for the protocol.  The source of a write doesn't need
> > to register memory, but the SGE depth can cause multiple WRITE WRs to be
> > required to service the IO.  And in theory there should be some threshold where
> > it might be better performance-wise to do a memory register + 1 WRITE vs X
> > WRITEs.    
> > 
> > As you mentioned, the RW API should account for this, but perhaps it is still
> > off some.  Bharat, have a look into the RDMA-RW API and let us see if we can
> > figure out if the additional SQ depth it adds is sufficient.
> >  
> > > What is the workload you are running? with immediatedata enabled you
> > > should issue reg+rdma_read+send only for writes > 8k.
> > > 
> > > Does this happen when you run only reads for example?
> > > 
> > > I guess its time to get the sq accounting into shape...
> > 
> > So to sum up - 2 issues:
> > 
> > 1) we believe the iSER + RW API correctly sizes the SQ, yet we're seeing SQ
> > overflows.  So the SQ sizing needs more investigation.
> > 
> > 2) if the SQ is full, then the iSER/target code is supposed to resubmit.  And
> > apparently that isn't working.
> > 
> 
> For #2, target-core expects -ENOMEM or -EAGAIN return from fabric driver
> callbacks to signal internal queue-full retry logic.  Otherwise, the
> extra se_cmd->cmd_kref response SCF_ACK_KREF is leaked until session
> shutdown and/or reinstatement occurs.
> 
> AFAICT, Potunri's earlier hung task with v4.8.y + ABORT_TASK is likely
> the earlier v4.1+ regression:
> 
> https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afdb1e3e
> 
> That said, there is room for improvement in target-core queue-full error
> signaling, and iscsi-target/iser-target callback error propagation.  
> 
> Sending out a series shortly to address these particular items.
> Please have a look.
>
Thanks for the changes Nicholas.
Testing them now.
Thanks,
Bharat.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
