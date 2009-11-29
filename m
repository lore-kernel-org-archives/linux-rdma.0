From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Reliable IB connections (RC) and event ordering
Date: Sun, 29 Nov 2009 11:03:32 -0800
Message-ID: <adak4x9ywzf.fsf@roland-alpha.cisco.com>
References: <e2e108260911290243h623d45bar77127e9610c8203e@mail.gmail.com>
	<e2e108260911290245mb9d603wf46ac7925824a9c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911290245mb9d603wf46ac7925824a9c4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org> (Bart
	Van Assche's message of "Sun, 29 Nov 2009 11:45:37 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > While working on the SRP target implementation I noticed the following
 > (the SRP protocol requires that an SRP initiator sets up an RC
 > connection to the SRP target during login):
 > * Sometimes (about 25% of SRP logins) the completion queue callback
 > function reports data arrival to the SRP target before the RTU event
 > has been delivered.
 > * Sometimes the completion queue callback function reports data
 > arrival after the DREQ message has been sent.
 > * According to the IBTA, message order is preserved over RC
 > connections and the system that sent the RTU message may only start
 > sending data after the RTU message has been sent (section 12.2).
 > 
 > Is this known behavior ? Is this the intended behavior of the Linux
 > InfiniBand stack ?

Yes, this is known and I don't think there is any other sane way to
implement things.  Recall that CM messages (RTU, DREQ, etc) are sent on
a separate QP than the actual connection being established, and that
there is no ordering between work requests on separate work queues.

If you want to refer to the IBA, you could look at figure 132 in section
12.9.6 -- an RC connection transitions to established when either the
RTU is received, or a message is received on the connection.  The IBA
takes into account this lack of ordering in multiple places -- defining
"communication established" async events, etc.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
