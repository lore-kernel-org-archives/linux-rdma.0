From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ipoib 10ge gateway
Date: Tue, 5 Jan 2010 17:37:34 -0700
Message-ID: <20100106003734.GC4664@obsidianresearch.com>
References: <e75d22a91001050706i228099d7qf6d745371d9547e9@mail.gmail.com> <2B7CD63E-C426-4E24-ADD1-9866D7ABF9C9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2B7CD63E-C426-4E24-ADD1-9866D7ABF9C9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2010 at 07:27:57PM -0500, Aaron Knister wrote:

> As an aside I would love to know how to pull an infiniband interface
> into a bridge.

bridging only works between networks with the same L2 address scheme
and support in the bridging driver for that address scheme.

The vnic schemes should work with bridging, but not ipoib.

You can solve some problems that bridging is also used to solve using
proxy arp and routing, those should work with ipoib.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
