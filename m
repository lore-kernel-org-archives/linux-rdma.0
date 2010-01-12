From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Tue, 12 Jan 2010 16:24:21 -0700
Message-ID: <20100112232421.GA16490@obsidianresearch.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com> <ada4omyud7c.fsf@roland-alpha.cisco.com> <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com> <adak4vuqrcw.fsf@roland-alpha.cisco.com> <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com> <adavdfapimb.fsf@roland-alpha.cisco.com> <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com> <ada3a2bp7ow.fsf@roland-alpha.cisco.com> <e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com> <adavdf7nd7k.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adavdf7nd7k.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 02:57:35PM -0800, Roland Dreier wrote:

> I doubt you could benchmark the overhead of calling ib_post_recv() in
> the full SRP protocol.  Really, I bet it's less than 100 nanoseconds to
> form the work request and call ib_post_recv().  Maybe I'm wrong but I
> really expect the overhead of actually doing IO (even to a ramdisk
> buffer or something) is going to be much higher than posting a receive.
> 
> Or maybe you did benchmark it and I'm wrong?

I'd actually think that the decline caused by exhausting credit on
the initiator side is far worse than ib_post_recv.. If ib_post_recv
really is noticable then maybe just force loading the RQ after XX
unposted are outstanding.

I also was wondering if the SRP spec had anything to say about this,
creating this kind of RQ->SQ dependency on either side should only be
done if the protocol explicitly allows it for one side only -
otherwise you risk deadlocking when used with an initiator that felt
it too could create that kind of dependency.

Also, I couldn't tell for sure from a cursory examination of the
patch, but the initiator must be designed to not stall processing the
RQ dependent on the SQ or the credit level, when using a credit scheme
like this. Or you will deadlock.

For instance it isn't clear to me how the control flow around
srp_process_cred_req is ment to work - it tries to send a reply, but
if it can't due to srp_get_txp_iu failing it just gives up forever?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
