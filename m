From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 13:01:39 -0400
Message-ID: <59FF0C04-2BFB-4F66-81BA-A598A9A087FC@oracle.com>
References: <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me> <20170515143632.GH3616@mtr-leonro.local> <20170515145952.GA7871@infradead.org> <20170515170506.GK3616@mtr-leonro.local> <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu> <20170518133439.GD3616@mtr-leonro.local> <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com> <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me> <20170620074639.GP17846@mtr-leonro.local> <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me> <20170620083309.GQ17846@mtr-leonro.local> <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me> <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <614481c7-22dd-d93b-e97e-52f868727ec3-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 20, 2017, at 8:02 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>>>> Can you share the check that correlates to the vendor+hw syndrome?
>>> 
>>> mkey.free == 1
>> Hmm, the way I understand it is that the HW is trying to access
>> (locally via send) a MR which was already invalidated.
>> Thinking of this further, this can happen in a case where the target
>> already completed the transaction, sent SEND_WITH_INVALIDATE but the
>> original send ack was lost somewhere causing the device to retransmit
>> from the MR (which was already invalidated). This is highly unlikely
>> though.
>> Shouldn't this be protected somehow by the device?
>> Can someone explain why the above cannot happen? Jason? Liran? Anyone?
>> Say host register MR (a) and send (1) from that MR to a target,
>> send (1) ack got lost, and the target issues SEND_WITH_INVALIDATE
>> on MR (a) and the host HCA process it, then host HCA timeout on send (1)
>> so it retries, but ehh, its already invalidated.
> 
> Well, this entire flow is broken, why should the host send the MR rkey
> to the target if it is not using it for remote access, the target
> should never have a chance to remote invalidate something it did not
> access.
> 
> I think we have a bug in iSER code, as we should not send the key
> for remote invalidation if we do inline data send...
> 
> Robert, can you try the following:
> --
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 12ed62ce9ff7..2a07692007bd 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -137,8 +137,10 @@ iser_prepare_write_cmd(struct iscsi_task *task,
> 
>        if (unsol_sz < edtl) {
>                hdr->flags     |= ISER_WSV;
> -               hdr->write_stag = cpu_to_be32(mem_reg->rkey);
> -               hdr->write_va   = cpu_to_be64(mem_reg->sge.addr + unsol_sz);
> +               if (buf_out->data_len > imm_sz) {
> +                       hdr->write_stag = cpu_to_be32(mem_reg->rkey);
> +                       hdr->write_va = cpu_to_be64(mem_reg->sge.addr + unsol_sz);
> +               }
> 
>                iser_dbg("Cmd itt:%d, WRITE tags, RKEY:%#.4X "
>                         "VA:%#llX + unsol:%d\n",
> --
> 
> Although, I still don't think its enough. We need to delay the
> local invalidate till we received a send completion (guarantees
> that ack was received)...
> 
> If this indeed the case, _all_ ULP initiator drivers share it because we
> never condition on a send completion in order to complete an I/O, and
> in the case of lost ack on send, looks like we need to... It *will* hurt
> performance.
> 
> What do other folks think?
> 
> CC'ing Bart, Chuck, Christoph.
> 
> Guys, for summary, I think we might have a broken behavior in the
> initiator mode drivers. We never condition send completions (for
> requests) before we complete an I/O. The issue is that the ack for those
> sends might get lost, which means that the HCA will retry them (dropped
> by the peer HCA) but if we happen to complete the I/O before, either we
> can unmap the request area, or for inline data, we invalidate it (so the
> HCA will try to access a MR which was invalidated).

So on occasion there is a Remote Access Error. That would
trigger connection loss, and the retransmitted Send request
is discarded (if there was externally exposed memory involved
with the original transaction that is now invalid).

NFS has a duplicate replay cache. If it sees a repeated RPC
XID it will send a cached reply. I guess the trick there is
to squelch remote invalidation for such retransmits to avoid
spurious Remote Access Errors. Should be rare, though.

RPC-over-RDMA uses persistent registration for its inline
buffers. The problem there is avoiding buffer reuse to soon.
Otherwise a garbled inline message is presented on retransmit.
Those would probably not be caught by the DRC.

But the real problem is preventing retransmitted Sends from
causing a ULP request to be executed multiple times.


> Signalling all send completions and also finishing I/Os only after we
> got them will add latency, and that sucks...

Typically, Sends will complete before the response arrives.
The additional cost will be handling extra interrupts, IMO.

With FRWR, won't subsequent WRs be delayed until the HCA is
done with the Send? I don't think a signal is necessary in
every case. Send Queue accounting currently relies on that.

RPC-over-RDMA relies on the completion of Local Invalidation
to ensure that the initial Send WR is complete. For Remote
Invalidation and pure inline, there is nothing to fence that
Send.

The question I have is: how often do these Send retransmissions
occur? Is it enough to have a robust recovery mechanism, or
do we have to wire in assumptions about retransmission to
every Send operation?


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
