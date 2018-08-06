From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH rdma-next v4 2/3] test_overflow: Add shift overflow tests
Date: Tue, 7 Aug 2018 00:54:08 +0200
Message-ID: <c6ca9a92-85fc-3cdf-823c-2260145049b0@rasmusvillemoes.dk>
References: <20180801212541.22889-1-keescook@chromium.org>
 <20180801212541.22889-3-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801212541.22889-3-keescook@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Randy Dunlap <rdunlap@infradead.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2018-08-01 23:25, Kees Cook wrote:
> This adds overflow tests for the new check_shift_overflow() helper to
> validate overflow, signedness glitches, storage glitches, etc.
> 

Just a few random comments, not really anything worth a v5 by itself.
IOW, I can live with this being sent upstream during next merge window.

> Co-developed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> +static int __init test_overflow_shift(void)
> +{
> +	int err = 0;
> +
> +/* Args are: value, shift, type, expected result, overflow expected */
> +#define TEST_ONE_SHIFT(a, s, t, expect, of) ({				\
> +	int __failed = 0;						\
> +	typeof(a) __a = (a);						\
> +	typeof(s) __s = (s);						\
> +	t __e = (expect);						\
> +	t __d;								\
> +	bool __of = check_shl_overflow(__a, __s, &__d);			\
> +	if (__of != of) {						\
> +		pr_warn("expected (%s)(%s << %s) to%s overflow\n",	\
> +			#t, #a, #s, of ? "" : " not");			\
> +		__failed = 1;						\
> +	} else if (!__of && __d != __e) {				\
> +		pr_warn("expected (%s)(%s << %s) == %s\n",		\
> +			#t, #a, #s, #expect);				\
> +		if ((t)-1 < 0)						\
> +			pr_warn("got %lld\n", (s64)__d);		\
> +		else							\
> +			pr_warn("got %llu\n", (u64)__d);		\
> +		__failed = 1;						\
> +	}								\
> +	if (!__failed)							\
> +		pr_info("ok: (%s)(%s << %s) == %s\n", #t, #a, #s,	\
> +			of ? "overflow" : #expect);			\

Isn't that a bit much, one pr_info for every test case (especially with
the number of test cases you've done, and thanks for that btw.)? For the
others, there's just one "doing nnn tests". It's harder here because we
can only let the tests count themselves, but we could have
TEST_ONE_SHIFT do exactly that and then print a pr_info at the end (or
pr_warn if any failed).

[Or, if we're willing to do something a bit ugly, forward-declaring
file-scope statics is actually allowed, and can be combined with
__COUNTER__...

#define foo() printf("test number %d\n", __COUNTER__)

static int start;
static int end;

static int start = __COUNTER__;
void t(void)
{
	printf("Will do %d tests\n", end - start);
	foo();
	foo();
}
static int end = __COUNTER__ - 1;

the expansion of TEST_ONE_SHIFT wouldn't have to use __COUNTER__ in any
meaningful way. This of course goes out the window if
check_shl_overflow is robustified with UNIQUE_ID. There's even a way to
work around that, but I'd better stop here.]


> +	__failed;							\
> +})
> +
> +	err |= TEST_ONE_SHIFT(1, 0, int, 1 << 0, false);
> +	err |= TEST_ONE_SHIFT(1, 16, int, 1 << 16, false);
> +	err |= TEST_ONE_SHIFT(1, 30, int, 1 << 30, false);
> +	err |= TEST_ONE_SHIFT(1, 0, s32, 1 << 0, false);
> +	err |= TEST_ONE_SHIFT(1, 16, s32, 1 << 16, false);
> +	err |= TEST_ONE_SHIFT(1, 30, s32, 1 << 30, false);

I don't see much point in doing both int and s32 as they are AFAIK
unconditionally the same on all architectures. Similarly for unsigned
int/u32.

> +
> +	/* Overflow: shifted at or beyond entire type's bit width. */
> +	err |= TEST_ONE_SHIFT(0, 8, u8, 0, true);
> +	err |= TEST_ONE_SHIFT(0, 9, u8, 0, true);

Hmm, seeing these I'd actually rather we didn't base the upper bound for
the shift count on sizeof(*d) but rather used a fixed 64, since that's
what we use for the temporary variable, and capping the shift count is
mostly for avoiding UB in the implementation. For any non-zero input
value, a shift count greater than 8 would still report overflow because
of the truncation.

More generally, I think that if the actual C expression

  a << s

doesn't invoke UB (i.e., a is non-negative and s is sane according to
the type of a), no bits are lots during the shift, and the result fits
in *d, we should not report overflow. Hence we should not impose
arbitrary limits on s just because the destination happens to be u8.
That some shift count/destination type combos then happen to guarantee
overflow for all but an input of 0 is just the way the math works.

> +
> +	/*
> +	 * Corner case: for unsigned types, we fail when we've shifted
> +	 * through the entire width of bits. For signed types, we might
> +	 * want to match this behavior, but that would mean noticing if
> +	 * we shift through all but the signed bit, and this is not
> +	 * currently detected (but we'll notice an overflow into the
> +	 * signed bit). So, for now, we will test this condition but
> +	 * mark it as not expected to overflow.
> +	 */
> +	err |= TEST_ONE_SHIFT(0, 7, s8, 0, false);
> +	err |= TEST_ONE_SHIFT(0, 15, s16, 0, false);
> +	err |= TEST_ONE_SHIFT(0, 31, int, 0, false);
> +	err |= TEST_ONE_SHIFT(0, 31, s32, 0, false);
> +	err |= TEST_ONE_SHIFT(0, 63, s64, 0, false);

I can't really see how this is a "corner case". For an s8 destination
and a shift count of, say, 4, there happens to be 8 input values that
won't lead to "overflow". When the shift count is 7, there's 1 input
value that won't lead to "overflow". So?

Rasmus
