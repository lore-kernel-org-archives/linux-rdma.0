From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: changing subnet ID
Date: Wed, 13 Apr 2011 17:25:49 -0600
Message-ID: <20110413232548.GA8717@obsidianresearch.com>
References: <20110413221831.GA20946@nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110413221831.GA20946-2Ww08eqqtp6fRvmTrFJqzg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 13, 2011 at 03:18:31PM -0700, Bob Ciotti wrote:

> Question with regard to changing the subnet prefix in OpenSM.
> 
> We want to uniquely identify individual subnets via changing the
> subnet prefix in OpenSM:

I highly recommend assigning a uniqe GID prefix to all subnets. eg
the ibtool program will use the GID prefix to identify the proper HCA
port to use, which in of itself makes it worth doing..

You should not use FE80::/10 as a prefix.

In IB all prefixes are /64s. I recommend generating a ULA for your
site and using that. See

http://en.wikipedia.org/wiki/Unique_local_address

This bit of python shows how to create the random address for your site:

>>> import os
>>> "fd"+os.urandom(40//8).encode("hex")+"0000"
'fd0b96859d2b0000'
(aka fd0b:9685:9d2b:0000::/64)

The lower 16 bits of the ULA can be incremented and assigned to each of
your site's subnets. Generate a new ULA if you run out.

This will work well with future IB routing specifications and allow
a hierarchical routing scheme where all subnets in your site can be
collapsed to a single /48 address for off-site access.

> The RFC on ipv6 addressing
> (http://tools.ietf.org/html/rfc4291#section-2.5.6) says those bits
> should be 0. I'm unclear if FE80/10 or FE80:0:0:0/64 is link local.

In IPv6 FE80::/10 is link local, technically in IB all prefixes are
/64 so it is FE80::/64.

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
