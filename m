From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v6] Add OPA extended LID support
Date: Tue, 15 Aug 2017 15:13:35 -0700
Message-ID: <82b0f16b-86e5-0b24-c638-d8a606047f87@intel.com>
References: <1502734663-44224-1-git-send-email-don.hiatt@intel.com>
 <50ff7793-413a-09a6-1805-ca0bce0452a2@intel.com>
 <cd6cd877-659d-8218-abf8-a23905af4f42@intel.com>
 <8d3d0a5a-df5e-b023-ec7c-f83e47a22f00@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8d3d0a5a-df5e-b023-ec7c-f83e47a22f00-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/15/2017 1:40 PM, Don Hiatt wrote:
>
>
> On 8/14/2017 1:12 PM, Don Hiatt wrote:
>> On 8/14/2017 11:36 AM, Don Hiatt wrote:
>>>
>>>
>>> On 8/14/2017 11:17 AM, Don Hiatt wrote:
>>>> This patch series primarily increases sizes of variables that hold
>>>> lid values from 16 to 32 bits. Additionally, it adds a check in
>>>> the IB mad stack to verify a properly formatted MAD when OPA
>>>> extended LIDs are used.
>>>>
>>>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>>
>>>> This is an incremental patch to move from v3 of the 'Add OPA
>>>> extended LID support' to v6 of the series.
>>>> Changes from v5:
>>>> ---------------
>>>> * Fixed typo in WARN_ON_ONCE usage in helper functions.
>>>> * Actually return be16 in ib_lid_be16() helper function.
>>>
>>> Sorry, this was meant to go to my email as a test, not to the list. 
>>> My tests are still running so please
>>> hold off on this until I confirm.
>>>
>> All test completed fine. I think we're good to go.
>>
>> Leon, if I missed anything else please let me know.
>>
>> Thanks,
>>
>> don
>>
> I did not get this email respond but saw it on the mailing list so 
> pasted it in to respond)
>
> >Yeah, you should fix the function below too.
> >The whole extended LID series did enormous mess with all these 
> lid/slid/dlid.
> >
> > 88 static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
> > 89 {
> > 90         if ((be32_to_cpu(dlid) >=
> > 91              be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> > 92             (be32_to_cpu(slid) >=
> > 93              be16_to_cpu(IB_MULTICAST_LID_BASE)))
> > 94                 return true;
> > 95         else
> > 96                 return false;
> > 97 }
> >
> >It will help a lot, if you break this patch to small steps:
> >1. Fix existing annotation errors.
> >2. Change (rename) the ib_lid/ib_slid functions.
> >3. Add WARN_ON.
> >
> >Right now, we have potential breakage of compatibility between
> >big-endian vs. little-endian systems.
> >
> >Please run smatch and sparse checkers before LID patches and after to
> >know what else you should fix.
> >
> > Thanks
>
> This patch series sat on the mailing list for over two months since 
> the your last
> request. It then got merged in and an incremental patch was asked for.
>
> I've been trying to address your concerns but since this patch is 
> going in as an
> incremental  patch I do not see how breaking it up as requested is 
> required.
>
> If Doug would like to pull the entire series then I'll break the 
> patchfor es up.
>
> As of now, with this patch the endian-ness issues have been resolved, 
> or are you
> saying they are not?
>
>
I ran sparse/smatch and the endian issues are fixed. The only smatch 
warnings in this
patch are for OPA record types. Once this incremental patch is accepted 
I'll follow
up to specifically address the OPA record type warnings.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
