From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 14:17:39 -0400
Message-ID: <D3DC49A2-FFC9-4F62-8876-3E6AD5167DE5@oracle.com>
References: <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu> <20170518133439.GD3616@mtr-leonro.local> <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com> <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me> <20170620074639.GP17846@mtr-leonro.local> <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me> <20170620083309.GQ17846@mtr-leonro.local> <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me> <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me> <59FF0C04-2BFB-4F66-81BA-A598A9A087FC@oracle.com> <20170620173532.GA827@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170620173532.GA827-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 20, 2017, at 1:35 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> On Tue, Jun 20, 2017 at 01:01:39PM -0400, Chuck Lever wrote:
> 
>>>> Shouldn't this be protected somehow by the device?
>>>> Can someone explain why the above cannot happen? Jason? Liran? Anyone?
>>>> Say host register MR (a) and send (1) from that MR to a target,
>>>> send (1) ack got lost, and the target issues SEND_WITH_INVALIDATE
>>>> on MR (a) and the host HCA process it, then host HCA timeout on send (1)
>>>> so it retries, but ehh, its already invalidated.
> 
> I'm not sure I understand the example.. but...
> 
> If you pass a MR key to a send, then that MR must remain valid until
> the send completion is implied by an observation on the CQ. The HCA is
> free to re-execute the SEND against the MR at any time up until the
> completion reaches the CQ.
> 
> As I've explained before, a ULP must not use 'implied completion', eg
> a receive that could only have happened if the far side got the
> send. In particular this means it cannot use an incoming SEND_INV/etc
> to invalidate an MR associated with a local SEND, as that is a form
> of 'implied completion'
> 
> For sanity a MR associated with a local send should not be remote
> accessible at all, and shouldn't even have a 'rkey', just a 'lkey'.
> 
> Similarly, you cannot use a MR with SEND and remote access sanely, as
> the far end could corrupt or invalidate the MR while the local HCA is
> still using it.
> 
>> So on occasion there is a Remote Access Error. That would
>> trigger connection loss, and the retransmitted Send request
>> is discarded (if there was externally exposed memory involved
>> with the original transaction that is now invalid).
> 
> Once you get a connection loss I would think the state of all the MRs
> need to be resync'd. Running through the CQ should indicate which ones
> are invalidate and which ones are still good.
> 
>> NFS has a duplicate replay cache. If it sees a repeated RPC
>> XID it will send a cached reply. I guess the trick there is
>> to squelch remote invalidation for such retransmits to avoid
>> spurious Remote Access Errors. Should be rare, though.
> 
> .. and because of the above if a RPC is re-issued it must be re-issued
> with corrected, now-valid rkeys, and the sender must somehow detect
> that the far side dropped it for replay and tear down the MRs.

Yes, if RPC-over-RDMA ULP is involved, any externally accessible
memory will be re-registered before an RPC retransmission.

The concern is whether a retransmitted Send will be exposed
to the receiving ULP. Below you imply that it will not be, so
perhaps this is not a concern after all.


>> RPC-over-RDMA uses persistent registration for its inline
>> buffers. The problem there is avoiding buffer reuse to soon.
>> Otherwise a garbled inline message is presented on retransmit.
>> Those would probably not be caught by the DRC.
> 
> We've had this discussion on the list before. You can *never* re-use a
> SEND, or RDMA WRITE buffer until you observe the HCA is done with it
> via a CQ poll.

RPC-over-RDMA is careful to invalidate buffers that are the
target of RDMA Write before RPC completion, as we have
discussed before.

Sends are assumed to be complete when a LocalInv completes.

When we had this discussion before, you explained the problem
with retransmitted Sends, but it appears that all the ULPs we
have operate without Send completion. Others whom I trust have
suggested that operating without that extra interrupt is
preferred. The client has operated this way since it was added
to the kernel almost 10 years ago.

So I took it as a "in a perfect world" kind of admonition.
You are making a stronger and more normative assertion here.


>> But the real problem is preventing retransmitted Sends from
>> causing a ULP request to be executed multiple times.
> 
> IB RC guarentees single delivery for SEND, so that doesn't seem
> possible unless the ULP re-transmits the SEND on a new QP.
> 
>>> Signalling all send completions and also finishing I/Os only after
>>> we got them will add latency, and that sucks...
> 
> There is no choice, you *MUST* see the send completion before
> reclamining any resources associated with the send. Only the
> completion guarentees that the HCA will not resend the packet or
> otherwise continue to use the resources.

On the NFS server side, I believe every Send is signaled.

On the NFS client side, we assume LocalInv completion is
good enough.


>> With FRWR, won't subsequent WRs be delayed until the HCA is
>> done with the Send? I don't think a signal is necessary in
>> every case. Send Queue accounting currently relies on that.
> 
> No. The SQ side is asynchronous to the CQ side, the HCA will pipeline
> send packets on the wire up to some internal limit.

So if my ULP issues FastReg followed by Send followed by
LocalInv (signaled), I can't rely on the LocalInv completion
to imply that the Send is also complete?


> Only the local state changed by FRWR related op codes happens
> sequentially with other SQ work.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
