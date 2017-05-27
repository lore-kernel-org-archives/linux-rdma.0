From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] libibumad: clean up htonll/ntohnll handling
Date: Sat, 27 May 2017 18:01:08 -0400
Message-ID: <ab35bf90-5d66-d972-1561-d519bb7289fd@redhat.com>
References: <20170522141722.50502-1-jarod@redhat.com>
 <20170524163301.GA7054@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170524163301.GA7054-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2017-05-24 12:33 PM, Jason Gunthorpe wrote:
> On Mon, May 22, 2017 at 10:17:22AM -0400, Jarod Wilson wrote:
>> Only ntohll was being checked to see if it wasn't defined, and was then
>> redefining htonll as well as ntohll. This was causing some problems for
>> the compile of the opa-ff package. Simple enough to rearrange this code a
>> bit such that htonll and ntohll are handled entirely independent of one
>> another.
> 
> What problem did this cause?
> 
>> +/* Users should use the glibc functions directly, not these wrappers */
>>   #ifndef ntohll
>> -#undef htonll
>>   #undef ntohll
>> -/* Users should use the glibc functions directly, not these wrappers */
>> -static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
>>   static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
>> -#define htonll htonll
>>   #define ntohll ntohll
>>   #endif
>> +#ifndef htonll
>> +#undef htonll
> 
> Both these undefs are not needed anymore.
> 
> Seems fine to me, if not weird that something would have a problem
> here.

My understanding from Honggang is that this was necessary for him to get 
opa-ff and infiniband-diags to compile (along with an update to our 
libibmad package). He should be able to fill in the blanks with further 
details.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
