From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] mlx5: Report if kernel allows using MPW in
 SQ
Date: Wed, 13 Sep 2017 12:38:49 -0600
Message-ID: <20170913183849.GD1536@obsidianresearch.com>
References: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
 <1505130185-32658-2-git-send-email-yishaih@mellanox.com>
 <20170911164257.GA2403@obsidianresearch.com>
 <1bb5967f-45fd-fb22-7772-10bf6b35e2e1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1bb5967f-45fd-fb22-7772-10bf6b35e2e1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 12, 2017 at 06:13:40PM +0300, Yishai Hadas wrote:
> On 9/11/2017 7:42 PM, Jason Gunthorpe wrote:
> >On Mon, Sep 11, 2017 at 02:43:04PM +0300, Yishai Hadas wrote:
> >> 	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
> >>-	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
> >>+	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1), /* Obsoleted */
> >>+	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),

> The bug was fixed in kernel 4.14 and now the feature is supported, the
> legacy value 1 on resp.support_multi_pkt_send_wqe is not reported from
> kernel any more as we can't rely on, and a new bit MLX5_ALLOW_MPW (1 << 1)
> was introduced to indicate that feature is supported.

That is very messy.. At least delete the MLX5DV_CONTEXT_FLAGS_MPW
constant to create a compile failure for this break.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
