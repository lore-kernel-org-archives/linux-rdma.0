From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 11:33:39 +0300
Message-ID: <55A61AE3.8020609@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150715073233.GA11535@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150715073233.GA11535-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/15/2015 10:32 AM, Christoph Hellwig wrote:
> Hi Sagi,
>
> I went over your proposal based on reviewing the ongoing MR threads
> and my implementation of a similar in-driver abstraction, so here
> are some proposed updates.
>
>> struct provider_mr {
>> 	u64		*page_list; // or what ever the HW uses
>> 	... <more private stuff> ...
>> 	struct ib_mr	ibmr;
>> };
>
> Call this rdma_mr to fit the scheme we use for "generic" APIs in the
> RDMA stack?

Umm, I think this can become weird given all other primitives have
ib_ prefix. I'd prefer to keep that prefix to stay consistent, and have
an incremental change to do it for all the primitives (structs & verbs).

>
> Also let's hash out the API for allocating it, you suggest the existing
> but currently almost unused ib_create_mr API, which isn't quite suitable
> as it doesn't transparently allocate the page list or other MR-specific
> data.  Another odd bit in ib_create_mr is that it doesnt actually say
> which kind of MR to allocate.

I can change it to be whatever we want. Unlike other mr allocation APIs,
it can be easily extended without changing the callers.

>
> I'd also get rid of the horrible style of using structs even for simple
> attributes.

The reason I thought an attr struct would benefit is that it can be
easily extended without changing every single caller (we might have
more attributes in the future?). Plus, it is consistent with QP and
CQ creation.

If you feel strongly about it, I can change it.

>
> so how about:
>
>
> int rdma_create_mr(struct ib_pd *pd, enum rdma_mr_type mr,
> 	u32 max_pages, int flags);
>
>>    *     array from a SG list
>>    * @mr:          memory region
>>    * @sg:          sg list
>>    * @sg_nents:    number of elements in the sg
>>    *
>>    * Can fail if the HW is not able to register this
>>    * sg list. In case of failure - caller is responsible
>>    * to handle it (bounce-buffer, multiple registrations...)
>>    */
>> int ib_mr_set_sg(struct ib_mr *mr,
>>                   struct scatterlist *sg,
>>                   unsigned short sg_nents);
>
> Call this rdma_map_sg?

OK.

>
>>           /* register the MR */
>>           frwr.opcode = IB_WR_FAST_REG_MR;
>>           frwr.wrid = my_wrid;
>>           frwr.wr.fast_reg.mr = mr;
>>           frwr.wr.fast_reg.iova = ib_sg_dma_adress(&sg[0]);
>>           frwr.wr.fast_reg.length = length;
>>           frwr.wr.fast_reg.access_flags = my_flags;
>
> Provide a helper to hide all this behind the scenes please:
>
> void rdma_init_mr_wr(struct ib_send_wr *wr, struct rdma_mr *mr,
> 		u64 wr_id, int mr_access_flags);
>
> Or if we got with Jason's suggestion split "int mr_access_flags" into
> "bool remote, bool is_write".

Yea I can do that...

>
> To support FRMs if we care enough we'd create a purely in-memory MR
> in rdma_create_mr and then map it to ib_fmr_pool_map_phys with a helper
> that the driver can call instead of rdma_init_mr_wr.
>

Lets take it at a later stage.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
