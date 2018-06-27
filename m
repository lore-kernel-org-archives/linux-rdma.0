From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH rdma-next 08/12] overflow.h: Add arithmetic shift helper
Date: Wed, 27 Jun 2018 23:35:54 +0200
Message-ID: <118d26e6-7fe4-7001-fe90-da5090579a88@rasmusvillemoes.dk>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-9-leon@kernel.org>
 <CAKwiHFhgsyWYD+q+JFb2HJEphnjiiOp=o4Airv3MW031q2jx8w@mail.gmail.com>
 <20180625171157.GE5356@mellanox.com>
 <CAKwiHFiRYbyiJqDYCgKXKZYRr0KjCt8q9AwKwfqoCA1sT2KFyQ@mail.gmail.com>
 <20180626175435.GQ5356@mellanox.com>
 <CAKwiHFgchr+6HYOZ4e4e1vzL9cFabe6eonNNM8NTWZypazcuKA@mail.gmail.com>
 <20180627181012.GM20754@mellanox.com>
 <20180627182220.GV30877@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627182220.GV30877@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Kees Cook <keescook@chromium.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2018-06-27 20:22, Leon Romanovsky wrote:
> On Wed, Jun 27, 2018 at 12:10:12PM -0600, Jason Gunthorpe wrote:
>> On Wed, Jun 27, 2018 at 11:36:03AM +0200, Rasmus Villemoes wrote:
>>>    Well, the types you can check at compile-time, the values not, so you
>>>    still have to define the result, i.e. contents of *d, for negative
>>>    values (even if we decide that "overflow" should always be signalled in
>>>    that case).
>>
>> Why do a need to define a 'result' beyond whatever the not-undefined
>> behavior shift expression produces?

Well, perhaps you don't, it's just that the other check_*_overflow have
that behaviour (which they inherit from gcc's builtins), and it's a
nice-to-have. But I see that it's hard to come up with something
sensible in all the "doesn't make sense" cases. When writing the tests
for test_overflow.c, you can of course just omit the comparison to
the/an expected result in the overflow case.

>> /*
>>  * Compute *d = (a << s)
>>  *
>>  * Returns true if '*d' cannot hold the result or 'a << s' doesn't make sense.
>>  * - 'a << s' causes bits to be lost when stored in d
>>  * - 's' is garbage (eg negative) or so large that a << s is guarenteed to be 0
>>  * - 'a' is negative
>>  * - 'a << s' sets the sign bit, if any, in '*d'
>>  * *d is not defined if false is returned.
>>  */
>> #define check_shift_overflow(a, s, d)                                          \
>> 	({                                                                     \
>> 		typeof(a) _a = a;                                              \
>> 		typeof(s) _s = s;                                              \
>> 		typeof(d) _d = d;                                              \
>> 		u64 _a_full = _a;                                              \
>> 		unsigned int _to_shift =                                       \
>> 			_s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;               \
>>                                                                                \
>> 		*_d = (_a_full << _to_shift);                                  \
>>                                                                                \
>> 		(_to_shift != _s || *_d < 0 || _a < 0 ||                       \
>> 		 (*_d >> _to_shift) != a);                                     \
>> 	})

That last a still needs to be _a. Other than that, I don't see anything
wrong with this version.

>> int main(int argc, const char *argv[])
>> {
>> 	int32_t s32;
>> 	uint32_t u32;
>>
>> 	assert(check_shift_overflow(1, 0, &s32) == false && s32 == (1 << 0));
[...]>> 	assert(check_shift_overflow(0xFFFFFFFF, 1, &s32) == true);

Please add these in some form to test_overflow.c, but do also include
cases where a and *d have different width, e.g. check_shift_overflow(1,
32, &s64) should be ok, while check_shift_overflow(65432, 0, &s16)
should not.

Rasmus
