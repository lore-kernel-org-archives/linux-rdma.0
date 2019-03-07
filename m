From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 08:18:57 +0100
Message-ID: <2c122567-d14b-7867-9230-67f570c13d15@rasmusvillemoes.dk>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 07/03/2019 03.14, Bart Van Assche wrote:
> On 3/6/19 5:24 PM, Jason Gunthorpe wrote:
>>>
>>> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
>>> index 40b48e2133cb..8afe0c0ada6f 100644
>>> +++ b/include/linux/overflow.h
>>> @@ -202,6 +202,24 @@
>>>     #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
>>>   +/*
>>> + * Evaluate a >= 0 without triggering a compiler warning if the type
>>> of a
>>> + * is an unsigned type.
>>> + */
>>> +#define is_positive(a) ({                    \

is_non_negative, please! positive means > 0. And perhaps it's better to
move these utility macros closer to the top of the file, together with
the other type/range helpers.

>>> +    typeof(a) _minus_one = -1LL;                \
>>> +    typeof((a) + 0U) _sign_mask = _minus_one > 0 ? 0 :    \
>>>> This is probably just is_signed_type(a)
> 
> Hi Jason,
> 
> I don't think that gcc accepts something like is_signed_type(typeof(a))
> so I'm not sure that the is_signed_type() macro is useful in this context.

Of course it does, it is even already used exactly that way in overflow.h.

Nice hack, I can't come up with anything better ATM. So if you fix the
name and reuse is_signed_type instead of opencoding it you can add my ack.

>>> +                1ULL << (8 * sizeof(a) - 1);    \
>>> +                                \
>>> +    ((a) & _sign_mask) == 0;                \
>>  
>> This is the same sort of obfuscation that Leon was building, do you
>> think the & is better than his ==, >  version?
>>
>> Will gcc shortcircuit the warning if we write it as
>>
>> (is_signed_type(a) && a < 0)
>>
>> ?

Unlikely, the Wtype-limits warning trigger at a very early stage of
parsing, so it's the mere presence of the a < 0 subexpression that
tickles it. So no amount of hiding it behind short-circuiting logic or
if() statements will help. See also the comment above
__signed_mul_overflow, where even code in the the untaken branch of a
__builtin_choose_expr() can trigger Wtype-limit.

> I have tested this patch. With this patch applied no warnings are
> reported while building the mlx5 driver and the tests in
> lib/test_overflow.c pass.

In cases like this it's good to be more explicit, i.e. "I've tested this
patch with gcc 6.5.4 and...", and even better of course if one does it
with several compiler versions. Please include the above paragraph +
compiler version info in the commit log.

Rasmus
