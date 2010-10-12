From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [patch v3] infiniband: uverbs: handle large number of entries
Date: Tue, 12 Oct 2010 15:01:18 -0600
Message-ID: <20101012210118.GR24268@obsidianresearch.com>
References: <20101007071610.GC11681@bicker> <20101007161649.GD21206@obsidianresearch.com> <20101007165947.GD11681@bicker> <20101009231607.GA24649@obsidianresearch.com> <20101012113117.GB6742@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101012113117.GB6742@bicker>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 12, 2010 at 01:31:17PM +0200, Dan Carpenter wrote:
> In the original code there was a potential integer overflow if you
> passed in a large cmd.ne.  The calls to kmalloc() would allocate smaller
> buffers than intended, leading to memory corruption.

Keep in mind these are probably performance sensitive APIs, I was
imagining batching a small number and they copy_to_user ? No idea what
the various performance trades offs are..

> Please, please, check this.  I've think I've done it right, but I don't
> have the hardware and can not test it.

Nor, do I.. I actually don't know what hardware uses this path? The
Mellanox cards use a user-space only version.
 
Maybe an iwarp card? I kinda recall some recent messages concerning
memory allocations in these paths for iwarp. I wonder if removing the
allocation is such a big win the larger number of copy_to_user calls
does not matter?

> It's strange to me that we return "in_len" on success.

Agree..

> +static int copy_header_to_user(void __user *dest, u32 count)
> +{
> +	u32 header[2];  /* the second u32 is reserved */
> +
> +	memset(header, 0, sizeof(header));

Don't you need header[0] = count ?

Maybe:
  u32 header[2] = {count};

And let the compiler 0 the other word optimally. Also, I'm not matters
here, since you are zeroing user memory that isn't currently used..

> +static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
> +{
> +	struct ib_uverbs_wc tmp;
> +
> +	memset(&tmp, 0, sizeof(tmp));

I'd really like to see that memset go away for performance. Again
maybe use named initializers and let the compiler zero the
uninitialized (does it zero padding, I wonder?). Or pre-zero this
memory outside the loop..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
