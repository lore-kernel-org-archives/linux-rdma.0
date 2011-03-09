From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an
 error wc
Date: Wed, 9 Mar 2011 10:42:37 -0700
Message-ID: <20110309174237.GP22729@obsidianresearch.com>
References: <20110309042613.GA21606@obsidianresearch.com>
 <4D771E0F.7040402@mellanox.com>
 <20110309070441.GA25213@obsidianresearch.com>
 <AANLkTinsu1xCJr0ROfjGABWg6yHZit27eSFPZgd7GFF2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinsu1xCJr0ROfjGABWg6yHZit27eSFPZgd7GFF2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2011 at 12:14:48PM +0100, Bart Van Assche wrote:

> If the mlx4 hardware can do this right now then that means that the
> mlx4 driver does not pass on the opcode for error completions. 

Right, my patch fixes that for userspace, a kernel change would be
very similer, and it lookes like mtcha is basically the same too, if
the chip firwmare operate similarly.

The opcode that is passed on may not be 100% accurate, but it will
reflect the IBV_WC_RECV bit correctly.

> The approach taken in the recently posted ib_srpt code is to encode
> the opcode in the wr_id. See also the encode_wr_id(),
> opcode_from_wr_id() and idx_from_wr_id() functions.

Right, this is definitely required today.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
