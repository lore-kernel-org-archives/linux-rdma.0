From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 15:09:28 -0500
Message-ID: <383D1FFB-346B-40E9-A174-606F13AFF849@oracle.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com> <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com> <027101d26c2c$c94467f0$5bcd37d0$@opengridcomputing.com> <28B0D906-7BDB-4B87-94E9-6BE263BFBFF7@oracle.com> <038901d26c44$67d6c4f0$37844ed0$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <038901d26c44$67d6c4f0$37844ed0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jan 11, 2017, at 2:53 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
>> Hi Steve-
>> 
>> 
>>> On Jan 11, 2017, at 12:04 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> wrote:
>>> 
>>> Hey Chuck,
>>> 
>>>>> 
>>>>> Browsing the code of other drivers it can be seen that this ability is
>>> either
>>>> hardcoded or is
>>>>> learnt by the driver from the device.
>>>> 
>>>> In the latter case, there's no way for me to know what that
>>>> capability is by looking at kernel code. There's also no way
>>>> for me to know about out-of-tree drivers or pre-release devices.
>>> 
>>> But shouldn't NFS always limit its sge depths based on
> ib_device_attr->max_sge?
>>> I don't think it is reasonable to assume any minimum value supported by all
>>> devices...
>> 
>> The previous "minimum" requirement assumed 2 SGEs. RPC-over-RDMA just
>> doesn't work with fewer than that.
>> 
>> So you would rather have RPC-over-RDMA automatically reduce the inline
>> threshold setting for each connection if the current system setting
>> cannot be supported by the device? I'll consider that.
>> 
> 
> That seems reasonable.
> 
>> Keeping logic in the ULPs to handle devices with tiny capabilities
>> duplicates a lot of complexity and impedes the introduction of new
>> features like larger inline thresholds.
>> 
>> The one abstract feature ULPs might really want is the ability to
>> send medium-sized data payloads in place. More than a handful of
>> SGEs is needed for that capability (in the kernel, where such payloads
>> are typically in the page cache).
>> 
>> It might be cool to have an API similar to rdma_rw that allows ULPs
>> to use a scatterlist for Send and Receive operations. It could hide
>> the driver and device maximum SGE values.
>> 
> 
> I'm not sure what you mean by "in place"?  (sorry for being not up to speed on
> this whole issue)  But perhaps some API like this could be added to rdma_rw...

"in place" == the SGE array would point to struct pages
containing parts of the message payload. That's basically what
this "support large inline threshold" patch is doing.

If the device supports only 4 SGEs, then the largest
message size that can be sent this way is just one or two
pages.

Some would prefer to send much larger payloads this way.

I guess what I'm asking is whether 4 SGEs is going to be typical
of HCAs going forward, or whether there is a definite trend for
adding more in new device designs.


>>>> It's not feasible for me to stock my lab with more than a
>>>> couple of devices anyway.
>>>> 
>>>> For all these reasons, I rely on HCA vendors for smoke testing
>>>> NFS/RDMA with their devices.
>>>> 
>>>> [1] was posted for review on public mailing lists for weeks. I
>>>> received no review comments or reports of testing successes or
>>>> failures from any vendor, until Broadcom's report in late
>>>> December, three months after [1] appeared in a kernel release
>>>> candidate.
>>>> 
>>>> This may sound like sour grapes, but this is a review and
>>>> testing gap, and I think the community should have the ability
>>>> to address it.
>>>> 
>>>> HCA vendors, especially, have to focus on kernel release
>>>> candidate testing if functional ULPs are a critical release
>>>> criterion for them.
>>>> 
>>> 
>>> You're absolutely right.  I'm querying Chelsio to see how this might have
>>> slipped through the cracks.  Did this initial change land in linux-4.9?
>> 
>> I believe so.
>> 
>> 
>>> I have one nit though, your patch series are always very long and thus, to
> me,
>>> tedious to review.  It would be nice to see 5-8 patches submitted for review
> vs
>>> 15+.
>> 
>> I cap my patch series around 20 for just this reason. That
>> seemed to be the average number being posted for other ULPs.
>> 
>> The flip side is that sometimes it takes several quarters to
>> get a full set of changes upstream. Splitting features across
>> kernel releases means the feature can't be reviewed together,
>> and is sometimes more difficult for distribution backports.
>> 
>> Could also go with more smaller patches, where each patch is
>> easier to review, or capping at 8 patches but each patch
>> is more complex.
>> 
>> It's also OK to suggest series reorganization whenever you
>> feel the ennui. ;-)
>> 
>> 
>>>>> If I'm not mistaken, this issue affects nes and
>>>>> cxgb3/4 drivers, and perhaps others.
>>>> 
>>>> ocrdma and Oracle's HCA.
>>>> 
>>>> 
>>>>> E.g., for cxgb4:
>>>>> 
>>>>>      #define T4_MAX_RECV_SGE 4
>>>> 
>>>> Yet, without hard-coded max_sge values in kernel drivers, it's
>>>> difficult to say whether 4 is truly the lower bound.
>>>> 
>>>> 
>>>>>      static int c4iw_query_device(struct ib_device *ibdev, struct
>>> ib_device_attr
>>>> *props,
>>>>>                                   struct ib_udata *uhw)
>>>>>      {
>>>>>              ...
>>>>>              props->max_sge = T4_MAX_RECV_SGE;
>>>>> 
>>>>> ***
>>> 
>>> FYI:  cxgb4 supports 4 max for recv wrs, and 17 max for send wrs.  Perhaps
> 17
>>> avoided any problems for cxgb4 with the original code?
>> 
>> The original code needed only two SGEs for sending, and one for
>> receiving.
>> 
>> IIRC the RPC-over-RDMA receive path still needs just one SGE.
>> 
> 
> No I mean the code that bumps it up to 18.  Would that cause an immediate
> failure if cxgb4 supported 17 and only enforces it at post_send() time?

"mount" would fail immediately if the driver reported max_sge == 17.
The check that Ram mentioned happens at mount time, before anything
has been sent.


> (haven't looked in detail at your patches...sorry).  Our QA ran testing on 4.9
> and didn't see this issue, so that's why I'm asking.    They have not yet run
> NFS/RDMA testing on 4.9-rc.  I've asked them to do a quick regression test asap.

That's curious!


>>> Note: the ib_device_attr only has a max_sge that pertains to both send and
> recv,
>>> so cxgb4 sets it to the min value.  We should probably add a max_recv_sge
> and
>>> max_send_sge to ib_device_attr...
>> 
>> I could go for that too.
>> 
> 
> I'm swamped right now to add this, but the changes should be trivial...

Maybe I could get to it, but no promises.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
