From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 13:39:56 -0600
Message-ID: <20160531193956.GD21834@obsidianresearch.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com>
 <20160531173033.GC7477@leon.nu>
 <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
 <20160531181223.GE7477@leon.nu>
 <20160531182100.GC21834@obsidianresearch.com>
 <20160531185432.GF7477@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160531185432.GF7477@leon.nu>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, matanb@mellanox.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 31, 2016 at 09:54:32PM +0300, Leon Romanovsky wrote:

> > No, you quoted the relevant standard:
> > 
> > .. but shall be capable of representing the values of all the members
> >   of the enumeration. ..
> > 
> > Truncation is not allowed.
> 
> I'm not convinced that it talks about truncation.
> 
> From the same document:
> "The expression that defines the value of an enumeration constant shall
> be an integer constant expression that has a value representable as an
> int."

Hmm.

There are two things going on here.

The quote above is refereing to the type of the constants. In C99 the
type of the constants is not the type of the enum. (I did not know
that, what a goofy obscure thing. C++11 gets it right) It would appear
the constants are fixed at int by the standard.

However, gcc/clang both will upgrade the type of the constant values,
on a value by value basis, to something larger:

This illustrates the concept:

enum Foo
{
	FOO_VALUE1 = 1ULL,
	FOO_VALUE2 = (uint32_t)UINT32_MAX,
	FOO_VALUE3 = ((uint64_t)2) << 32,
	FOO_VALUE4 = 1<<31,
};

static void check_int(int *v)  { }
static void check_long(long *v)  { }
// Both work:
//static void check_ull(uint64_t *v)  { }
static void check_ull(enum Foo *v)  { }

int main(int argc,const char *argv[])
{
	check_int((__typeof__(FOO_VALUE1) *)0);
	check_long((__typeof__(FOO_VALUE2) *)0);
	check_ull((__typeof__(FOO_VALUE3) *)0);
	check_int((__typeof__(FOO_VALUE4) *)0);
}				  

The four constants have different types and the types are not
necessarily what you'd expect (eg FOO_VALUE3 has been promoted to a
64 bit signed long, FOO_VALUE1 has been demoted to an int)

So the enum is safe, but having different types of the values is
certainly unexpected.

I still think the actual bug is only 1<<31 I pointed out earlier:

enum Foo
{
	FOO_VALUE1 = 1,
	FOO_VALUE2 = ((uint64_t)2) << 32,
	FOO_VALUE3 = 1<<31,
};
uint64_t res = FOO_VALUE1 | FOO_VALUE2 | FOO_VALUE3;
printf("%lx\n",res);
==
ffffffff80000001

Which is clearly wrong. This is because signed int becomes sign
extended when converted to uint64_t, corrupting the upper bits.

Since adding the ULL's doesn't make the enum constants have uniform
type I would not bother with the churn.

Jason
