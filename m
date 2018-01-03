From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] ethernet: mlx4: Delete an error message for a failed
 memory allocation in five functions
Date: Wed, 3 Jan 2018 13:24:59 +0200
Message-ID: <adfc3229-d3f9-afb9-00e6-9f765af0cbe8@mellanox.com>
References: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
 <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
 <alpine.DEB.2.20.1801030904290.5305@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1801030904290.5305@hadrien>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>, Tariq Toukan <tariqt@mellanox.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 03/01/2018 10:06 AM, Julia Lawall wrote:
> 
> 
> On Wed, 3 Jan 2018, Tariq Toukan wrote:
> 
>>
>>
>> On 01/01/2018 10:46 PM, SF Markus Elfring wrote:
>>> From: Markus Elfring <elfring@users.sourceforge.net>
>>> Date: Mon, 1 Jan 2018 21:42:27 +0100
>>>
>>> Omit an extra message for a memory allocation failure in these functions.
>>>
>>> This issue was detected by using the Coccinelle software.
>>>
>>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>>> ---
>>
>> Is this an issue? Why? What is your motivation?
>> These are error messages, very informative, appear only upon errors, and in
>> control flow.
> 
> Strings take up space.  Since there is a backtrace on an out of memory
> problem, if the string does not provide any more information than the
> position of the call, then there is not much added value.  I don't know
> what was the string in this case.  If it provides some additional
> information, then it would be reasonable to keep it.

I don't really accept this claim...

Short informative strings worth the tiny space they consume. It helps 
the users of our driver understand what went wrong in simple words, 
without the need to understand the role of the functions/callstack or 
being familiar with different parts of the driver code.

In addition, some out-of-memory errors are recoverable, even though 
their backtrace is also printed. For example, in function 
mlx4_en_create_cq (appears in patch) we have a first allocation attempt 
(kzalloc_node) and a fallback (kzalloc). I'd prefer to state a clear 
error message only when both have failed, because otherwise the user 
might be confused whether the backtrace should indicate a malfunctioning 
interface, or not.

Tariq

> 
> julia
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
