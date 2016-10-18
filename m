From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: SQ overflow seen running isert traffic
Date: Tue, 18 Oct 2016 09:34:33 -0500
Message-ID: <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
References: <20160927070157.GA13140@chelsio.com> <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me> <20161017111655.GA21245@chelsio.com> <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com> <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me> <20161018112801.GA3117@chelsio.com> <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > I tried out this change and it works fine with iwarp. I dont see SQ
> > overflow. Apparently we have increased the sq too big to overflow. I am
going
> > to let it run with higher workloads for longer time, to see if it holds
good.
> 
> Actually on second thought, this patch is an overkill. Effectively we
> now set:
> 
> MAX_CMD=266
> and max_rdma_ctx=128 so together we take 394 which seems to too much.
> 
> If we go by the scheme of 1 rdma + 1 send for each IO we need:
> - 128 sends
> - 128 rdmas
> - 10 miscs
> 
> so this gives 266.
> 
> Perhaps this is due to the fact that iWARP needs to register memory for
> rdma reads as well? (and also rdma writes > 128k for chelsio HW right?)
>

iWARP definitely needs to register memory for the target of reads, due to
REMOTE_WRITE requirement for the protocol.  The source of a write doesn't need
to register memory, but the SGE depth can cause multiple WRITE WRs to be
required to service the IO.  And in theory there should be some threshold where
it might be better performance-wise to do a memory register + 1 WRITE vs X
WRITEs.    

As you mentioned, the RW API should account for this, but perhaps it is still
off some.  Bharat, have a look into the RDMA-RW API and let us see if we can
figure out if the additional SQ depth it adds is sufficient.
 
> What is the workload you are running? with immediatedata enabled you
> should issue reg+rdma_read+send only for writes > 8k.
> 
> Does this happen when you run only reads for example?
> 
> I guess its time to get the sq accounting into shape...

So to sum up - 2 issues:

1) we believe the iSER + RW API correctly sizes the SQ, yet we're seeing SQ
overflows.  So the SQ sizing needs more investigation.

2) if the SQ is full, then the iSER/target code is supposed to resubmit.  And
apparently that isn't working.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
