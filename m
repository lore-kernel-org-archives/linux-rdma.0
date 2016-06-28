From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Tue, 28 Jun 2016 16:26:43 +0300
Message-ID: <ff4aa43f-a09c-15dc-0f3b-e4c7718e4b93@dev.mellanox.co.il>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160627181758.GD23540-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/27/2016 9:17 PM, Jason Gunthorpe wrote:
> On Sun, Jun 26, 2016 at 07:54:21PM +0300, Yishai Hadas wrote:
>>> I'm still very much of the opinion that extended CQs should only allow
>>> compatible QP's to be added.
>>
>> Application may create a CQ with large subset of flags that may fit some of
>> its attached QP types. Semantically, it is similar to what we have today, it
>> allows to put different QP types on the same CQ and by thus allow
>> application to have ordered completion events.
>
> This is repeating your argument, I disagree, it is a horrible API
> design, you need to defend this with an actual use case.
>
>> We don't see a good reason to change from current behavior and hurt
>> applications that expect that valid behavior.
>
> Safety for the API consumer.

Disagree, safety should not limit the general usage of an API.
The new API preserves the behavior of the legacy API so that a CQ can be 
attached to more than one QP type.

>>> Add a compatibility layer
>
> Doug and I have both stated we don't want to see so many
> single-provider APIs and churn in libibverbs. This was designed to be
> a generic API that all providers can implement.

The API is generic and can be implemented by any provider, which 
limitation do you see here ?

> The responsibility falls on you to make sure that it works
> universally. Compat is one option.

Compatibility layer can be added in the future, nothing in current 
implementation might block it from happen. No reason to delay a 
libibvers release as of that.

  >>> Exact set of access flags
>>
>> Application can ask for subset of the available bits, in addition, it has an
>> option to ask for all legacy ones (i.e. IBV_WC_STANDARD_FLAGS) for a case
>> that a CQ needs to support all legacy attribute and could be attached to
>> both RC and UD QPs.
>
> Again, this is pretty much nonsense. Asking for data that can't be
> returned is just an insane API design.

See above comment for CQ usage.

In addition, this enum can be used by vendors to sum up the supported WC 
flags instead of repeating the full list of bits. (Look for 
CREATE_CQ_SUPPORTED_WC_FLAGS in libmlx5 code.)

>>> You might want to look at having the caller pass in 'cq' from a member
>>> in ibv_cq_ex. That way the caller can hold the cq in a register
>>> instead of constantly reloading it like this - I'm assuming to_mcq is
>>> not just an container_of??
>>
>> The assumption is *incorrect*, the internal access from ibv_cq_ex to driver
>> CQ is done via offsetof/container_of which is done in compile time, no need
>> to have some change from the clean usage of the API to that mode.
>
> Fine on cq, but the wqe pointer may benifit, and other drivers may
> benifit. It still needs to be studied.

The ibv_wc_read_xxx functions may require some cached context to return 
the correct value. The internal driver CQ can be accessed using 
container_of and if some cached context is needed it can be taken from 
there.

At the moment we don't see a justification to change the clean API that 
uses ibv_cq_ex* as the input.


>> From performance point of view we don't expect a change here, we followed
>> the created assembly code and saw no difference even when it was annotated
>> with 'restrict'.
>
> The annotations help the caller.

We followed also the caller's assembly code but couldn't find a change 
that can justify using 'restrict'.

>> In addition, please note the 'restrict' notation was only became standard as
>> part of C99, in previous compilers it may not work at all or requires
>> different key word to be defined as part of the CONFIG step.
>
> Use __restrict like glibc does.

It may require some logic in the configure script, as pointed above we 
still don't see its benefit.

>> We can go ahead and define the ibv_wc_read_xxx with const qualifier on its
>> input struct ibv_cq_ex *ibcq in some extra incremental patch if makes sense.
>
> Of course it makes sense, you need to fix all of this stuff in all
> the patches you wrote.

We can send a patch for that, let's first agree to ignore the restrict 
if it hasn't approved to be helpful, patch touches same place.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
