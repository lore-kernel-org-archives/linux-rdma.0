From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Wed, 29 Jan 2014 17:06:46 +0200
Message-ID: <52E91906.70802@dev.mellanox.co.il>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>	<52CD1C68.4050406@mellanox.com>	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>	<52DBB4F1.4020400@mellanox.com>	<CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>	<CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>	<CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>	<52DF93D3
 .6030509@dev.mellanox.co.il> <CAJZOPZLBECYXrpp0GY0uUvyf+XbiLHhXdVukniPXD4AWZObymg@mail.gmail.com> <52E90C81.9040800@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E90C81.9040800-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/29/2014 4:13 PM, Bart Van Assche wrote:
> On 01/28/14 22:02, Or Gerlitz wrote:
>>>>> Roland, ping! the signature patches were posted > three months ago.
> I have a question about RDMA and T10-DIF support. The Linux block layer,
> the Linux SCSI core, Linux filesystems and block drivers all support
> discontiguous buffers. These are buffers that cannot be mapped onto a
> single contiguous range of virtual memory addresses. I think the RDMA
> FMR and FR memory registration mechanisms only support mapping a range
> of addresses that can be mapped onto a contiguous region of virtual
> addresses. This means that either multiple RDMA memory regions are
> needed to map a discontiguous buffer or that the buffer contents has to
> be copied before associating it with a memory region. What I understood
> from the mlx5 T10-DIF patch series is that the API introduced in that
> patch series is such that only a single memory region per data transfer
> operation is supported. This made me wonder how to support T10-DIF for
> discontiguous buffers.

Hey Bart, Thanks for the observation,

You are correct, the T10-PI RDMA offload API requires a single memory 
region that describes the data
and a single memory region that describes the protection information.

Non-contiguous buffers are a well known problem/challenge for RDMA 
transports, each handles them
differently: iSER uses bounce buffers, SRP registers multiple contiguous 
regions. The T10-PI offload API does
not impose any other constraint on this situation, each ULP will act the 
same: iSER will copy to contiguous
bounce buffers and SRP will register multiple "Signature" memory regions 
(each for a contiguous chunk of data)
and send the rkeys to the target.

> Would one of the options below perhaps be an
> appropriate solution ?
> - Add a flag in struct request_queue that tells the block layer to use a
>    bounce buffer (data copying) for I/O requests with a discontiguous
>    data buffer. The block layer already supports copying data buffers for
>    which e.g. DMA alignment requirements are not met. Rework patch
>    "IB/iser: Introduce fast memory registration model" (commit
>    5587856c9659ac2d6ab201141aa8a5c2ff3be4cd) such that it takes advantage
>    of that new flag. See also blk_rq_map_user_iov() for an example of
>    how the block layer decides when copying a data buffer is necessary.

Didn't understand why should it matter where the copy is done (iser/block)?

> - Modify the patches that add T10-DIF such that discontiguous buffers
>    are supported.

I thought about adding some kind of logic to T10-PI RDMA API to try and 
solve the alignment
issue at the same time, but the fact is that the two are unrelated, and 
I figured it is not
such a good idea. Non-contiguous memory registration is separate problem 
(hint: under
development) and should be addressed separately, T10-PI RDMA offload 
should play well
with it.

> Sorry that I had not realized this before.
>
> Bart.
>

Hops this helps,

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
