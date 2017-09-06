From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Wed, 6 Sep 2017 14:09:57 -0600
Message-ID: <20170906200957.GB22567@obsidianresearch.com>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net>
 <1230f9d9-07c1-6d00-b197-f408712fb5c1@grimberg.me>
 <890CC58C-7F8F-4B7E-8620-21F07007D3AA@oracle.com>
 <6dcdcc25-2613-cdb5-1db2-6c944f05242b@grimberg.me>
 <4E2E5580-69A5-4C3B-9FCA-E61AE2042E6B@oracle.com>
 <9059315f-1985-042e-a59f-26a66fbece3e@grimberg.me>
 <5B2F42B8-2CBD-43F4-BBAD-71EDD4F871FB@oracle.com>
 <20170906193946.GC18461@obsidianresearch.com>
 <4D7ECF64-0F68-4137-B72A-9E942147C8D4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D7ECF64-0F68-4137-B72A-9E942147C8D4-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 04:02:24PM -0400, Chuck Lever wrote:
> 
> > On Sep 6, 2017, at 3:39 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > 
> > On Wed, Sep 06, 2017 at 02:33:50PM -0400, Chuck Lever wrote:
> > 
> >> B. Force RPC completion to wait for Send completion, which
> >> would allow the post-v4.6 scatter-gather code to work
> >> safely. This would need some guarantee that Sends will
> >> always complete in a short period.
> > 
> > Why is waiting for the send completion so fundamentally different from
> > waiting for the remote RPC reply?
> > 
> > I would say that 99% of time the send completion and RPC reply
> > completion will occure approximately concurrently.
> > 
> > eg It is quite likely the RPC reply SEND carries an embeded ack
> > for the requesting SEND..
> 
> Depends on implementation. Average RTT on IB is 3-5 usecs.
> Average RPC RTT is about an order of magnitude more. Typically
> the Send is ACK'd more quickly than the RPC Reply can be sent.
> 
> But I get your point: the normal case isn't a problem.
> 
> The problematic case arises when the Send is not able to complete
> because the NFS server is not reachable. User starts pounding on
> ^C, RPC can't complete because Send won't complete, control
> doesn't return to user.

Sure, but why is that so different from the NFS server not generating
a response?

I thought you already implemetned a ctrl-c scheme that killed the QP?
Or was that just a discussion?

That is the only way to async terminate outstanding RPCs and clean
up. Killing the QP will allow the send to be 'completed'.

Having ctrl-c escalate to a QP tear down after a short timeout seems
reasonable. 99% of cases will not need the teardown since the send
will complete..

How does sockets based NFS handle this? Doesn't it zero copy from these
same buffers into SKBs? How does it cancel the SKBs before the NIC
transmits them?

Seems like exactly the same kind of problem to me..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
