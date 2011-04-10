From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/4] libibmad: Distinguish timed out from other errors
Date: Sun, 10 Apr 2011 12:00:05 -0400
Message-ID: <4DA1D405.4040305@dev.mellanox.co.il>
References: <4DA07983.8060308@dev.mellanox.co.il> <20110409171239.GA4372@obsidianresearch.com> <4DA1875F.2050601@dev.mellanox.co.il> <20110410140956.GB4372@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110410140956.GB4372-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/10/2011 10:09 AM, Jason Gunthorpe wrote:
> On Sun, Apr 10, 2011 at 06:33:03AM -0400, Hal Rosenstock wrote:
>> On 4/9/2011 1:12 PM, Jason Gunthorpe wrote:
>>> On Sat, Apr 09, 2011 at 11:21:39AM -0400, Hal Rosenstock wrote:
>>>>
>>>> Add error field like errno to ib_rpc_t structure
>>>> In mad_rpc code, make sure error is cleared and
>>>> in _do_madrpc, set ETIMEDOUT.
>>>>
>>>> error field could also be used to distinguish other errors if needed.
>>>
>>> This looks like it breaks the ABI since callers using functions that
>>> accept ib_rpc_t are expected to allocate the ib_rpc_t struct
>>> themselves.
>>
>> Yes, this changes the ABI. I didn't see a good way not to do this. Do
>> you have any ideas ? The only possible approach I saw was to steal the
>> high order bit from mgtclass (class is really only a byte) to indicate
>> which version of ib_rpc_t is being passed as to whether this field is
>> present.
> 
> If you are going to change the ABI like this then you have to bump the
> SONAME.

Typically it's been the libibmad maintainer who's bumped the versions
when appropriate as a release is readied.

> Setting a flag would work.

Not sure what you're referring to. Setting a flag where ?

-- Hal

> Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
