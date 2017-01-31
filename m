From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/6] mlx5: Fix missing break statement in
 sq_overhead
Date: Tue, 31 Jan 2017 14:56:21 -0700
Message-ID: <20170131215621.GA24747@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1485896886-23517-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170131211239.GA22475@obsidianresearch.com>
 <0cf30dc4-9390-6d99-2cab-bf1a73ea32e0@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0cf30dc4-9390-6d99-2cab-bf1a73ea32e0-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 11:37:49PM +0200, Yishai Hadas wrote:

> >Hum, looking again this confusing construction was probably as
> >intended before.. Yishai can you let me know?
> 
> The original code is correct, it intended to fallback to IBV_QPT_XRC_RECV to
> take into account the size of struct mlx5_wqe_xrc_seg in both cases.

okay thanks I updated the PR

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
