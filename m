From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 2/3] test_overflow: Add shift overflow tests
Date: Tue, 31 Jul 2018 22:51:42 -0700
Message-ID: <CAGXu5jJ5y_0mJ-ijPX-=mf5sDEqwVh_BaV7GVumi5tpirbp19w@mail.gmail.com>
References: <20180801000039.44314-1-keescook@chromium.org> <20180801000039.44314-3-keescook@chromium.org>
 <20180801021353.GA31192@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801021353.GA31192@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-rdma <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 31, 2018 at 7:13 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Tue, Jul 31, 2018 at 05:00:38PM -0700, Kees Cook wrote:
>> +     /* Overflow: high bit falls off. */
>> +     /* 10010110 */
>> +     err |= TEST_ONE_SHIFT(150, 1, u8, 0, true);
>> +     /* 1000100010010110 */
>> +     err |= TEST_ONE_SHIFT(34966, 1, u16, 0, true);
>> +     /* 10000100000010001000100010010110 */
>> +     err |= TEST_ONE_SHIFT(2215151766U, 1, u32, 0, true);
>> +     err |= TEST_ONE_SHIFT(2215151766U, 1, unsigned int, 0, true);
>> +     /* 1000001000010000010000000100000010000100000010001000100010010110 */
>> +     err |= TEST_ONE_SHIFT(9372061470395238550ULL, 1, u64, 0, true);
>
> This same idea should be repeated with signed outputs and check both
> overflow past the end (<<2) and overflow into the signed bit (<<1)
>
>         /* Overflow, high bit falls into the sign bit or off the end */
>         /* 01001011 */
>         err |= TEST_ONE_SHIFT(75, 1, s8, 0, true);
>         err |= TEST_ONE_SHIFT(75, 2, s8, 0, true);
>
> And also general type mismatch overflow:
>
>         err |= TEST_ONE_SHIFT(0x100, 0, u8, 0, true);
>         err |= TEST_ONE_SHIFT(0xFF, 0, s8, 0, true);

Ah yes, thanks. I've added these for the next version now.

-Kees

-- 
Kees Cook
Pixel Security
