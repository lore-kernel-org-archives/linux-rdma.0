From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Tue, 24 Oct 2017 10:02:23 -0400
Message-ID: <b1ec461a-9c04-ff16-2a2a-4f21dfbfbcb1@intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
 <20171023183848.GC16127@mtr-leonro.local>
 <d09970ea-2531-4d8e-0b4f-85533ff8487a@intel.com>
 <20171023193102.GE16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023193102.GE16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/23/2017 3:31 PM, Leon Romanovsky wrote:
>>> Please, no "inline-function" in *.c files as it is written in CodingStyle.
>>
>> Sure about that?
> 
> I'm not style-nazi, so won't insist, but this is in CodingStyle.
> 
> Documentation/process/coding-style.rst
>   841 15) The inline disease
>   842 ----------------------
>   843
>   844 There appears to be a common misperception that gcc has a magic "make me
>   845 faster" speedup option called ``inline``. While the use of inlines can be
>   846 appropriate (for example as a means of replacing macros, see Chapter 12), it
>   847 very often is not. Abundant use of the inline keyword leads to a much bigger
>   848 kernel, which in turn slows the system as a whole down, due to a bigger
>   849 icache footprint for the CPU and simply because there is less memory
>   850 available for the pagecache. Just think about it; a pagecache miss causes a
>   851 disk seek, which easily takes 5 milliseconds. There are a LOT of cpu cycles
>   852 that can go into these 5 milliseconds.

Right, which doesn't say not to put it in a .c file. So I think the 
location is OK for this. However, whether it even needs to be an inline 
function at all in the first place is certainly a valid question. Let me 
chat with Sebastian and double check, if it doesn't really need to be 
inlined we'll send a v2.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
