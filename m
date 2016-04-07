From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma
 alloc_session_cb init
Date: Thu, 07 Apr 2016 16:28:41 -0700
Message-ID: <1460071721.18732.61.camel@haakon3.risingtidesystems.com>
References: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
	 <5702B503.1060006@sandisk.com>
	 <1459809672.10124.18.camel@haakon3.risingtidesystems.com>
	 <5702EE56.10503@sandisk.com>
	 <1459810708.10124.25.camel@haakon3.risingtidesystems.com>
	 <57052BCB.6070405@sandisk.com>
	 <1460068300.18732.25.camel@haakon3.risingtidesystems.com>
	 <5706E3BB.70302@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5706E3BB.70302-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-04-07 at 15:48 -0700, Bart Van Assche wrote:
> On 04/07/2016 03:31 PM, Nicholas A. Bellinger wrote:
> >> I will have a look myself into the percpu_ida conversion.
> >
> > I found a pair of old ConnectX2 in IB mode and I'll be fixing this up
> > for v4.6-rc, so don't even bother.
> 
> Please make sure that you understand the ib_srpt driver before you try 
> to make further modifications to that driver. The patch for percpu_ida 
> allocation that is already in v4.6-rc1 introduces namely a severe race 
> condition next to the bugs that I had already explained. The proper 
> order for session setup is to allocate the send ioctx buffers first and 
> after these buffers have been allocated to transition to RTR. You 
> changed that order to transition first to RTR and next to allocate the 
> send ioctx buffers. By making this change you introduced a race window 
> during which any command that is received by the ib_srpt driver will try 
> to allocate a send ioctx from a not yet initialized send ioctx ring.
> 

Great, then I'll move srpt_ch_qp_rtr() into the alloc_session callback
as well.

Really, given SRP has no security at all doing all of this allocation
and setup before the target even knows if the initiator is allowed to
login makes zero sense to me.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
