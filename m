From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 11:05:00 -0700
Message-ID: <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com> <20160531173033.GC7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160531173033.GC7477-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/31/2016 10:30 AM, Leon Romanovsky wrote:
> On Tue, May 31, 2016 at 11:13:06AM -0600, Jason Gunthorpe wrote:
>> On Tue, May 31, 2016 at 08:35:10AM -0700, Bart Van Assche wrote:
>>> On 05/30/16 03:09, Max Gurtovoy wrote:
>>>> ib_device_cap_flags 64-bit expansion caused a possible caps overlapping
>>>> (depending on machine endianness) and made consumers read wrong device
>>>> capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by the
>>>> iser driver causing it to use a non-existing capability. Fix this by
>>>> casting ib_device_cap_flags enumerations to ULL.
>>>>
>>>> [ ... ]
>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>> [ ... ]
>>>> enum ib_device_cap_flags {
>>>>       [ ... ]
>>>> 	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
>>>>      [ ... ]
>>>> };
>>>
>>> How can this patch make a difference? The presence of any constant
>>> in an enum that does not fit in a 32-bit integer makes an enum 64
>>> bits wide. In other words, all the changes from "1" into "1ULL" in
>>> this patch do not have
>>
>> The expressions are evaluated before the enum type is decided, the
>> enum type has no impact on the type of the expressions.
>
> It is machine/compiler dependent.
>
> Bart,
> Can you share your source of C-standard?
>
> This link [1] states in chapter "6.7.2.2 Enumeration specifiers"
>
> "Each enumerated type shall be compatible with char, a signed integer type,
> or an unsigned integer type. The choice of type is implementation-defined (110),
> but shall be capable of representing the values of all the members of the enumeration.
> The enumerated type is incomplete until after the } that terminates the list of enumerator
> declarations."
>
> And the footnote (110):
> "An implementation **may** delay the choice of which integer type until all enumeration
> constants have been seen."
>
> [1] http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

Let me rephrase my question. Before and after this patch 
IB_DEVICE_SG_GAPS_REG is defined as 1ULL << 32, so how can this patch 
make a difference? And if the issue is that some compilers choose a 
32-bit integer for ib_device_cap_flags and others a 64-bit integer, 
shouldn't ib_device_cap_flags be converted from an enum into a series of 
#defines? Or is the issue rather that some compilers choose the enum 
size depending on the size of the first enumeration constant? Anyway, I 
think the patch description needs to be clarified.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
