From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 09:10:30 -0700
Message-ID: <20180209161030.GA7584@mellanox.com>
References: <20180208233829.GA16128@ziepe.ca>
 <1518192109.2871.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518192109.2871.5.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 09, 2018 at 04:01:51PM +0000, Bart Van Assche wrote:
> On Thu, 2018-02-08 at 16:38 -0700, Jason Gunthorpe wrote:
> >  enum {
> > -	MLX4_WQE_BIND_TYPE_2		= (1<<31),
> > +	MLX4_WQE_BIND_TYPE_2		= (1UL<<31),
> >  	MLX4_WQE_BIND_ZERO_BASED	= (1<<30),
> >  };
> 
> Hello Jason,
> 
> A quote from the C11 standard:
> 
> "The expression that defines the value of an enumeration constant shall be an
> integer constant expression that has a value representable as an int. [ ... ]
> Each enumerated type shall be compatible with char, a signed integer type, or
> an unsigned integer type. The choice of type is implementation-defined but
> shall be capable of representing the values of all the members of the
> enumeration."
> 
> Does that mean that this change relies on extensions to the C standard?

Yes, this relies on a common compiler extension to promote the type of
enum constants beyond int. AFAIK all compilers have done this forever,
kinda bonkers it isn't in C11, IMHO.

As I understand it, the current code is also non-conforming as (1<<31)
is apparently undefined behavior, and at least gcc throws a warning
for it in -Wpedantic mode.

I did a patch that will make our public headers mostly strictly
conforming to C11 with -Wpedantic set, which I've been wondering if it
is worth sending..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
