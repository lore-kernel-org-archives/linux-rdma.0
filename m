From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Thu, 14 Jul 2016 09:50:01 -0700
Message-ID: <d875a341-9f3e-0e24-d476-86205fc59fc9@oracle.com>
References: <1468402436-25053-1-git-send-email-yuval.shaia@oracle.com>
 <20160713174742.GE19657@obsidianresearch.com>
 <20160713191224.GB2985@yuval-lap>
 <20160713192504.GA26851@obsidianresearch.com>
 <20160713195030.GB4929@yuval-lap.uk.oracle.com>
 <02892134-15c7-963a-d13b-95d6e35ceaca@oracle.com>
 <20160714055028.GA3287@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160714055028.GA3287-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Haakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 7/13/2016 10:50 PM, Yuval Shaia wrote:
> On Wed, Jul 13, 2016 at 01:46:07PM -0700, Santosh Shilimkar wrote:
>>
>> On 7/13/2016 12:50 PM, Yuval Shaia wrote:
>>> On Wed, Jul 13, 2016 at 01:25:04PM -0600, Jason Gunthorpe wrote:
>>>> On Wed, Jul 13, 2016 at 10:12:25PM +0300, Yuval Shaia wrote:
>>>>> On Wed, Jul 13, 2016 at 11:47:42AM -0600, Jason Gunthorpe wrote:
>>>>>> On Wed, Jul 13, 2016 at 02:33:56AM -0700, Yuval Shaia wrote:
>>>>>>> To avoid entering into endless loop when device can't poll CQE from CQ
>>>>>>> driver should not reschedule if error is not -EAGAIN.
>>>>>>
>>>>>> ?? what causes ib_poll_cq to return an error?
>>>>>>
>>>>>> You need to describe the motivation here.
>>>>>
>>>>> EAGAIN is fine - HW driver returns this to indicates temporary error and
>>>>> caller should retry again.
>>>>> However, other errors (such as EINVAL) may refer to some fatal error where
>>>>> HW driver is unable to recover from.
>>>>
>>>> So you've never seen this?
>>>
>>> Waiting for real use case might take some time.
>>>
>>>>
>>>> I question the sanity of a poll_cq implementation that can return a
>>>> hard error...
>>>>
>>>>> Two examples:
>>>>> - Mellanox folks may comment for example if the case where
>>>>>  __mlx4_qp_lookup() returns NULL in function mlx4_ib_poll_one() means
>>>>>  fatal or not.
>>>>> - At least by reading the of c4iw_poll_cq_one() it is clear that it may
>>>>>  return fatal error.
>>>>
>>>> If EAGAIN should be ignored, then all other errors indicate the CQ is
>>>> dead and needs to be reconstructed. So the approach in this patch to
>>>> add a 'recv_conseq_cq_errs' is nonsense. You need to trigger some kind
>>>> of restart of the QP instead.
>>>
>>> The idea behind consec counter is not a recovery mechanism it is just some
>>> why to "retry" for a while just before declaring game over. I do not have
>>> strong opinion on that, actually my first try was w/o it, i.e. 'kill' on
>>> the first error.
>>>
>>> Patch does not offer any recovery mechanism it simply print fatal error to
>>> console and exit NAPI. This fatal error will suggest admin to reload the
>>> driver or something like that.
>>> This takes us to "recovery-mechanism" :)
>>> I'm not sure that restarting the QP will help as the error is while reading
>>> the CQ and restarting the CQ is more or less like restarting the driver.
>>>
>> Probably Jason mean destroy the problematic CQ and create a new one.
>> This is what Haakon suggested as well but it will lead to the leak
>> and also possible issue with outstanding WC's getting lost without
>> being flushed on that CQ.
>
> It is not only leak.
> This CQ serve many QP (== many connections). Destroying it seems to me
> catastrophic as reloading the driver.
>
Fair enough.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
