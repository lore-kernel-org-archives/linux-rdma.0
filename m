From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ConnectX-3 on non-coherent AARCH64 system
Date: Mon, 13 Mar 2017 10:55:09 -0600
Message-ID: <20170313165509.GA25664@obsidianresearch.com>
References: <b01684b6-ba4a-65cc-ea20-b578e1e2fa2e@nvidia.com>
 <20170310170626.GE22960@obsidianresearch.com>
 <40698e27-8b17-df09-8165-40420f16a37e@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <40698e27-8b17-df09-8165-40420f16a37e-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Cc: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 10:43:04AM -0600, Stephen Warren wrote:

> In my case, I primarily want another "DMA device" to access the data
> read/written by Infiniband. If CPU access to the data buffers doesn't work
> correctly, it might not be such a big deal. So, I'd be willing to take a
> solution that only fixed the MMU setup issues for the pages used for
> ConnectX HW control. I expect making those uncached would work, and since
> the number of these control pages (compared to the data plane) is small, the
> performance probably wouldn't be too bad. Would it be possible for the
> kernel ConnectX driver to modify the process page tables to flip all known
> control pages from cached to uncached when the completion queues are
> created?

I don't know the mlx drivers well enough to remark if that is simple
or not.. It looks liky they rely on the userspace provider itself
allocating memory DMA rather than the driver in the kernel.. Flipping
pre-allocated user pages into UC is probably quite difficult to do
properly..

> Once upon a time, we might have got away with assuming the answer based on
> architecture, but I suspect that ARM==non-coherent is false in many cases
> these days.

There are certainly cases.. Currently we do not even build the user
space side on ARM32 because nobody has asked for it, even though
surely there is hardware that can accommodate it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
