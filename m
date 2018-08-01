From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/3] overflow.h: Add arithmetic shift helper
Date: Wed, 1 Aug 2018 11:44:22 -0700
Message-ID: <CAGXu5jJ7yKsCdcKiqoXAoBPsQbWZK4ERMJnK5chdwJtQ+2AAag@mail.gmail.com>
References: <20180801060947.16670-1-keescook@chromium.org> <20180801060947.16670-2-keescook@chromium.org>
 <0568f73f-c1ff-1e9d-8ef9-04c46eb13d6e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0568f73f-c1ff-1e9d-8ef9-04c46eb13d6e@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-rdma <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 1, 2018 at 9:28 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/31/2018 11:09 PM, Kees Cook wrote:
>> From: Jason Gunthorpe <jgg@mellanox.com>
>>
>> Add shift_overflow() helper to assist driver authors in ensuring that
>> shift operations don't cause overflows or other odd conditions.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>> [kees: tweaked comments and commit log, dropped unneeded assignment]
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  include/linux/overflow.h | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
>> index 8712ff70995f..69fc366ce865 100644
>> --- a/include/linux/overflow.h
>> +++ b/include/linux/overflow.h
>> @@ -202,6 +202,37 @@
>>
>>  #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
>>
>> +/** check_shift_overflow() - Calculate a left-shifted value and check overflow
>> + *
>> + * @a: Value to be shifted
>> + * @b: How many bits left to shift
>> + * @d: Pointer to where to store the result
>> + *
>> + * Computes *@d = (@a << @s)
>> + *
>
> missed                     @b [again]

Heh, thanks. It's fixed on disk, but... I failed to merge it into the
patch. Anyway, I'll spin this one more time with s/shift/shl/ and this
fixed.

-Kees

-- 
Kees Cook
Pixel Security
