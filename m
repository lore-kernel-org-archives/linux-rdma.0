From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Thu, 16 Jul 2015 15:21:04 +0300
Message-ID: <55A7A1B0.5000808@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150715073233.GA11535@infradead.org>
 <20150715170750.GA23588@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150715170750.GA23588-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/15/2015 8:07 PM, Jason Gunthorpe wrote:
> On Wed, Jul 15, 2015 at 12:32:33AM -0700, Christoph Hellwig wrote:
>> int rdma_create_mr(struct ib_pd *pd, enum rdma_mr_type mr,
>> 	u32 max_pages, int flags);
>>
>>>    *     array from a SG list
>>>    * @mr:          memory region
>>>    * @sg:          sg list
>>>    * @sg_nents:    number of elements in the sg
>>>    *
>>>    * Can fail if the HW is not able to register this
>>>    * sg list. In case of failure - caller is responsible
>>>    * to handle it (bounce-buffer, multiple registrations...)
>>>    */
>>> int ib_mr_set_sg(struct ib_mr *mr,
>>>                   struct scatterlist *sg,
>>>                   unsigned short sg_nents);
>>
>> Call this rdma_map_sg?
>>
>>>           /* register the MR */
>>>           frwr.opcode = IB_WR_FAST_REG_MR;
>>>           frwr.wrid = my_wrid;
>>>           frwr.wr.fast_reg.mr = mr;
>>>           frwr.wr.fast_reg.iova = ib_sg_dma_adress(&sg[0]);
>>>           frwr.wr.fast_reg.length = length;
>>>           frwr.wr.fast_reg.access_flags = my_flags;
>>
>> Provide a helper to hide all this behind the scenes please:
>>
>> void rdma_init_mr_wr(struct ib_send_wr *wr, struct rdma_mr *mr,
>> 		u64 wr_id, int mr_access_flags);
>>
>> Or if we got with Jason's suggestion split "int mr_access_flags" into
>> "bool remote, bool is_write".
>
> Yes please. Considering the security implications we need to be much
> more careful API wise here. This is more of a code-as-documentation
> issue than a functional issue.

I gotta say,

these suggestions of bool/write or supported_ops with a convert helper
seem (to me at least) to make things more complicated.

Why not just set the the access_flags as they are?
I want local use?
set IB_ACCESS_LOCAL_WRITE
I want a peer to read from me?
set IB_ACCESS_REMOTE_READ
I want a peer to write to me?
IB_ACCESS_REMOTE_WRITE
...

isn't it much simpler?

If we want to mask out iWARP difference, we use the
Steve's roles_to_access() helper thing...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
