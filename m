From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Mon, 21 Aug 2017 09:22:37 -0600
Message-ID: <20170821152237.GA3400@obsidianresearch.com>
References: <1502976998-20906-1-git-send-email-yishaih@mellanox.com>
 <20170817173320.GB22792@obsidianresearch.com>
 <20170817173932.GJ23648@mtr-leonro.local>
 <20170817180349.GD24735@obsidianresearch.com>
 <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <99bc8f57-6a58-d309-7142-74cc498f7feb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 21, 2017 at 12:06:57PM +0300, Yishai Hadas wrote:
> On 8/17/2017 9:03 PM, Jason Gunthorpe wrote:
> >On Thu, Aug 17, 2017 at 08:39:32PM +0300, Leon Romanovsky wrote:
> >>On Thu, Aug 17, 2017 at 11:33:20AM -0600, Jason Gunthorpe wrote:
> >>>On Thu, Aug 17, 2017 at 04:36:38PM +0300, Yishai Hadas wrote:
> >>>>From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>
> >>>>The returned UAR pointer is actually void ** and points to whole
> >>>>UAR database.
> >>>>
> >>>>Because user is not supposed to access it and expected to use
> >>>>the CQ doorbell, we will return uar[0] (CQ doorbell) directly
> >>>>and eliminate the following logic in the applications:
> >>>>
> >>>>uint64_t cq_db_reg = (uint64_t *)(((uint64_t)(uint64_t *)rxq->cq_uar) +
> >>>>                     MLX5_CQ_DOORBELL;
> >>>
> >>>NAK, at least, as is..
> >>>
> >>>This changes the ABI and mlx5dv is a public interface now, so you have
> >>>to do it properly.
> >>>
> >>>Looking at it, my advice is to rev the symbol version of
> >>>mlx5dv_init_obj and consider providing a compat symbol.
> >>>
> >>>Also, you need to change the name of the 'uar' field:
> >>>
> >>>>-	cq_out->uar	  = mctx->uar;
> >>>>+	cq_out->uar	  = mctx->uar[0];
> >>>
> >>>To something else, to make it clear, which of the two ABIs the
> >>>application code is coded to - for a change like this, you *MUST*
> >>>force old apps to have a compile failure.
> >>
> >>I know exactly who coded on top of this interface. They are the ones who
> >>asked for this change and they are fully understand the implications,
> >>inability to work with this interface on "old" libraries.
> >
> >I don't care who they are - you need to follow sane ABI rules if you
> >are pushing public shared libraries into distros. This is not negotiable.
> >
> 
> There is no ABI/API change but just a bug fix in mlx5 driver.
> The API talked about void* but by mistake the mlx5 code returned void**,
> this patch fixes that.

The commit message is garbage then.

Is there existing code out there that uses cq_out->uar and works
properly today? Yes or No?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
