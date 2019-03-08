From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Fri, 8 Mar 2019 08:58:21 +0100
Message-ID: <2d60debb-2b64-1b1f-7e16-d20720c93e28@rasmusvillemoes.dk>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
 <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
 <1552003703.45180.17.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552003703.45180.17.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 08/03/2019 01.08, Bart Van Assche wrote:
> On Thu, 2019-03-07 at 08:18 +0100, Rasmus Villemoes wrote:
>> On 07/03/2019 03.14, Bart Van Assche wrote:
>>> On 3/6/19 5:24 PM, Jason Gunthorpe wrote:
>>>>>
>>>>> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
>>>>> index 40b48e2133cb..8afe0c0ada6f 100644
>>>>> +++ b/include/linux/overflow.h
>>>>> @@ -202,6 +202,24 @@
>>>>>     #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
>>>>>   +/*
>>>>> + * Evaluate a >= 0 without triggering a compiler warning if the type
>>>>> of a
>>>>> + * is an unsigned type.
>>>>> + */
>>>>> +#define is_positive(a) ({                    \
>>
>> is_non_negative, please! positive means > 0. And perhaps it's better to
>> move these utility macros closer to the top of the file, together with
>> the other type/range helpers.
> 
> Hi Rasmus,
> 
> Thank you for the feedback. But according to what I found online opinions
> about whether or not zero is a positive number seem to vary. From
> https://en.wikipedia.org/wiki/Sign_(mathematics):

Yes, I'm a mathematician, I'm aware of that. You can also find people
who use "less than" in the "<=" sense, and then say "strictly less than"
when they mean "<".

> Terminology for signs
> 
> When 0 is said to be neither positive nor negative, the following phrases
> may be used to refer to the sign of a number:
> * A number is positive if it is greater than zero.
> * A number is negative if it is less than zero.
> * A number is non-negative if it is greater than or equal to zero.
> * A number is non-positive if it is less than or equal to zero.
> 
> When 0 is said to be both positive and negative, modified phrases are used
> to refer to the sign of a number:
> * A number is strictly positive if it is greater than zero.
> * A number is strictly negative if it is less than zero.
> * A number is positive if it is greater than or equal to zero.
> * A number is negative if it is less than or equal to zero.

Right, but in no way does it ever make sense to mix these conventions.
So the options for describing ">= 0, < 0" are "non_negative, negative"
or "positive, strictly_negative".

In the context of the C language, the first convention is used. While
not explicitly stated, it can be inferred from usage of the terms.
First, the word nonnegative is used (e.g. in defining argc). Second, "If
the value of the right operand [in a shift expression] is negative [...]
the behaviour is undefined.", so certainly negative cannot include 0.
Third, E* constants are required to be positive, and "[errno] is never
set to zero by any library function". Etc. etc.

The same goes for linux source itself. I'm sure you can find
documentation in the linux source along the lines of "0 for success,
negative for error", not "strictly negative for error".

Rasmus
