From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Mon, 27 Mar 2017 05:20:25 +0300
Message-ID: <cfde9eab-a52a-8888-7d32-4f6fc9f9640a@grimberg.me>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This series introduces IBNBD/IBTRS kernel modules.
>
> IBNBD (InfiniBand network block device) allows for an RDMA transfer of block IO
> over InfiniBand network. The driver presents itself as a block device on client
> side and transmits the block requests in a zero-copy fashion to the server-side
> via InfiniBand. The server part of the driver converts the incoming buffers back
> into BIOs and hands them down to the underlying block device. As soon as IO
> responses come back from the drive, they are being transmitted back to the
> client.

Hi Jack, Danil and Roman,

I met Danil and Roman last week at Vault, and I think you guys
are awesome, thanks a lot for open-sourcing your work! However,
I have a couple of issues here, some are related to the code and
some are fundamental actually.

- Is there room for this ibnbd? If we were to take every block driver
   that was submitted without sufficient justification, it'd be very
   hard to maintain. What advantage (if any) does this buy anyone over
   existing rdma based protocols (srp, iser, nvmf)? I'm really (*really*)
   not sold on this one...

- To me, the fundamental design that the client side owns a pool of
   buffers that it issues writes too, seems inferior than the
   one taken in iser/nvmf (immediate data). IMO, the ibnbd design has
   scalability issues both in terms of server side resources, client
   side contention and network congestion (on infiniband the latter is
   less severe).

- I suggest that for your next post, you provide a real-life use-case
   where each of the existing drivers can't suffice, and by can't
   suffice I mean that it has a fundamental issue with it, not something
   that requires a fix. With that our feedback can be much more concrete
   and (at least on my behalf) more open to accept it.

- I'm not exactly sure why you would suggest that your implementation
   supports only infiniband if you use rdma_cm for address resolution,
   nor I understand why you emphasize feature (2) below, nor why even
   in the presence of rdma_cm you have ibtrs_ib_path? (confused...)
   iWARP needs a bit more attention if you don't use the new generic
   interfaces though...

- I honestly do not understand why you need *19057* LOC to implement
   a rdma based block driver. Thats almost larger than all of our
   existing block drivers combined... First glance at the code provides
   some explanations, (1) you have some strange code that has no business
   in a block driver like ibtrs_malloc/ibtrs_zalloc (yikes) or
   open-coding various existing logging routines, (2) you are for some
   reason adding a second tag allocation scheme (why?), (3) you are open
   coding a lot of stuff that we added to the stack in the past months...
   (4) you seem to over-layer your code for reasons that I do not
   really understand. And I didn't really look deep at all into the
   code, just to get the feel of it, and it seems like it needs a lot
   of work before it can even be considered upstream ready.

> We design and implement this solution based on our need for Cloud Computing,
> the key features are:
> - High throughput and low latency due to:
> 1) Only two rdma messages per IO

Where exactly did you witnessed latency that was meaningful by having
another rdma message on the wire? That's only for writes, anyway, and
we have first data bursts for that..

> 2) Simplified client side server memory management
> 3) Eliminated SCSI sublayer

That's hardly an advantage given all we are losing without it...

...

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
