From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 01/17] Update rdma/ib_user_verbs.h
Date: Mon, 22 Jan 2018 12:48:48 +0200
Message-ID: <c4ee82a7-f235-4370-cf64-d5c73a79bd1b@dev.mellanox.co.il>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-2-jgg@ziepe.ca>
 <fe2337a1-b02d-cc01-c55d-e6e493ec30ef@dev.mellanox.co.il>
 <20180115171033.GA2206@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115171033.GA2206-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/15/2018 7:10 PM, Jason Gunthorpe wrote:
> On Mon, Jan 15, 2018 at 07:01:13PM +0200, Yishai Hadas wrote:
>> On 1/12/2018 12:13 AM, Jason Gunthorpe wrote:
>>> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> To let us use definitions from the latest kernel headers in followup
>>> patches.
>>>
>>>  From v4.15-rc7
>>>
>>> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>   buildlib/RDMA_LinuxHeaders.cmake            |    2 +-
>>>   buildlib/fixup-include/rdma-ib_user_verbs.h | 1176 +++++++++++++++++++++++++++
>>>   2 files changed, 1177 insertions(+), 1 deletion(-)
>>>   create mode 100644 buildlib/fixup-include/rdma-ib_user_verbs.h
>>>
>>> diff --git a/buildlib/RDMA_LinuxHeaders.cmake b/buildlib/RDMA_LinuxHeaders.cmake
>>> index ea60b9b55844ea..aa2a89a53d0c2d 100644
>>> +++ b/buildlib/RDMA_LinuxHeaders.cmake
>>> @@ -86,7 +86,7 @@ function(rdma_report_missing_kheaders)
>>>   endfunction()
>>>   # This list is topologically sorted
>>> -rdma_check_kheader("rdma/ib_user_verbs.h" "${DEFAULT_TEST}" NO_SHIM OPTIONAL)
>>> +rdma_check_kheader("rdma/ib_user_verbs.h" "int main(int argc,const char *argv[]) { return IB_USER_VERBS_EX_CMD_MODIFY_CQ; }")
>>
>> Any future change in this kernel header will require a change in this check
>> as well and also a commit into fixup-include/rdma-ib_user_verbs.h with the
>> new kernel code, correct ?
> 
> Yes.
> 
>> How will people be aware of that and won't miss it ? can we have some script
>> that will warn/suggest the expected change upon a kernel change ?
> 
> Keeping the header up to date is not a big problem, there is no way to
> get new symbols otherwise so people patching in new features have to
> do it.
> 
> travis always does compiles using these headers as well.
> 
> Keeping the check quoted above broadly correct is more difficult. I
> can't think of how to automate that, other than to manually inspect
> patches that update the header to make sure they update the check as
> well.
> 
> We could also switch to a more iproute like model where we just
> unconditionally use our copies of the kernel headers..

Are you referring to drop the cmake linux header check and always use a 
private copy of the latest kernel UAPI file in rdma-core ? it can make 
more sense comparing to current candidate code.

It can reside in a folder named 'rdma' and not installed by rdma-core as 
applications don't use this file. If so we can drop the fixup file and 
its matching check.

What do you think ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
