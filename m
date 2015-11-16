From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Mon, 16 Nov 2015 11:50:52 +0200
Message-ID: <5649A6FC.7000700@dev.mellanox.co.il>
References: <1447610393-2899-1-git-send-email-hch@lst.de>
 <5648CD03.4000206@dev.mellanox.co.il>
 <CAJ3xEMgKiB_qK-WkD0mB3NnCkE0=S_khc93-X381rRbROoYWkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMgKiB_qK-WkD0mB3NnCkE0=S_khc93-X381rRbROoYWkw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 15/11/2015 23:10, Or Gerlitz wrote:
> On Sun, Nov 15, 2015, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
>> On 15/11/2015 19:59, Christoph Hellwig wrote:
>
>>> Without this sg_dma_len will return 0 on architectures tha have
>>> the dma_length field.
>
> and what wrong with that?

Because it's not length 0. It's because I did a (documented) hack
with the new memory registration API. I hope we can fix it soon.

>
> Christoph, probably typo here? "tha" needs to be "that"
>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>>    drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>>> b/drivers/infiniband/ulp/srp/ib_srp.c
>>> index 32f7962..445c0a6 100644
>>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>> @@ -1520,6 +1520,9 @@ static int srp_map_idb(struct srp_rdma_ch *ch,
>>> struct srp_request *req,
>>>                  state.sg_nents = 1;
>>>                  sg_set_buf(idb_sg, req->indirect_desc, idb_len);
>>>                  idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
>>> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
>>> +               idb_sg->dma_length = idb_sg->length;          /* hack^2 */
>>> +#endif
>>
>>
>> :)
>>
>> We should really get this properly map/unmap per IO at some point.
>> Probably do it in both code paths...
>
> Sagi, can you please elaborate a little further on the problem, srpt
> WA,

It's srp initiator. This falls in the case where srp sends an indirect
buffer descriptor to the target (which is registered). For this
descriptor it uses a pre-dma-mapped buffer, so in order to fit it into
the new memory registration scheme (which works on SG lists), I hacked
a single entry SG and used the pre-dma-mapped address. What was missing
is the dma_length setting (because we didn't dma mapped the SG).

The proper fix is doing correct map/unmap per IO.

> what do we do in isert and what is the proposed not WA solution?

iser does not have indirect buffer descriptors, only a single rkey
(per-direction).
