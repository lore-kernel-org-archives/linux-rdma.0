From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 09:24:53 -0700
Message-ID: <20180209162453.GD7584@mellanox.com>
References: <20180208233829.GA16128@ziepe.ca>
 <1518192109.2871.5.camel@wdc.com>
 <20180209161030.GA7584@mellanox.com>
 <HE1PR0502MB3004BB45FC9ADB9B49CAF283D1F20@HE1PR0502MB3004.eurprd05.prod.outlook.com>
 <1518193161.2871.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518193161.2871.14.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 09, 2018 at 04:19:23PM +0000, Bart Van Assche wrote:
> On Fri, 2018-02-09 at 16:12 +0000, Parav Pandit wrote:
> > Any reason to use open code instead of using BIT() macro from
> > include/linux/bitops.h which does the same thing?
> 
> Personally I'm in favor of removing the BIT() macro from the kernel. That macro
> is not useful and only adds confusion. Code that does not use that macro is
> easier to read because one does not have to look up whether the BIT() macro
> is defined as 1U << x, 1UL << x or 1ULL << x.

Really? The rule is pretty simple:

 BIT(x) for x < 32
 BIT_ULL(x) for x >= 32 && x < 64

Why do you care about what specific type the macro produces?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
