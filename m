From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 23 Jul 2015 13:15:16 +0300
Message-ID: <55B0BEB4.9080702@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722174401.GG26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 8:44 PM, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2015 at 09:50:12AM -0700, Christoph Hellwig wrote:
>>> +/**
>>> + * ib_map_mr_sg() - Populates MR with a dma mapped SG list
>>> + * @mr:            memory region
>>> + * @sg:            dma mapped scatterlist
>>> + * @sg_nents:      number of entries in sg
>>> + * @access:        access permissions
>>
>> I know moving the access flags here was my idea originally, but I seem
>> convinced by your argument that it might fit in better with the posting
>> helper.  Or did someone else come up with a better argument that mine
>> for moving it here?
>
> I was hoping we'd move the DMA flush and translate into here and make
> it mandatory. Is there any reason not to do that?

The reason I didn't added it in was so the ULPs can make sure they meet
the restrictions of ib_map_mr_sg(). Allow SRP to iterate on his
SG list set partials and iSER to detect gaps (they need to dma map
for that).

>
>>> +int ib_map_mr_sg(struct ib_mr *mr,
>>> +		 struct scatterlist *sg,
>>> +		 unsigned short sg_nents,
>>> +		 unsigned int access)
>>> +{
>>> +	int rc;
>>> +
>>> +	if (!mr->device->map_mr_sg)
>>> +		return -ENOSYS;
>>> +
>>> +	rc = mr->device->map_mr_sg(mr, sg, sg_nents);
>>
>> Do we really need a driver callout here?  It seems like we should
>
> The call out makes sense to me..
>
> The driver will convert the scatter list directly into whatever HW
> representation it needs and prepare everything for posting. Every
> driver has a different HW format, so it must be a callout.
>
>> Also it seems like this returns 0/-error.  How do callers like SRP
>> see that it only did a partial mapping and it needs another MR?
>
> I would think it is an error to pass in more sg_nents than the MR was
> created with, so SRP should never get a partial mapping as it should
> never ask for more than max_entries.
>
> (? Sagi, did I get the intent of this right?)

Error is returned when:
- sg_nents > max_entries
- sg has gaps
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
