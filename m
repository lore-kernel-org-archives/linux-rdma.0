From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 4/5] verbs: Tag matching send interface
Date: Mon, 12 Jun 2017 10:41:40 -0600
Message-ID: <20170612164140.GB12282@obsidianresearch.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <1497249767-15353-5-git-send-email-artemyko@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497249767-15353-5-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 09:42:46AM +0300, Artemy Kovalyov wrote:
> Add tag matching header (TMH) and rendezvous header (RVH) definitions
> to infiniband/tm_types.h
> 
> Change-Id: I35a2088190ff4a1776f77b43a4564bb6f65ca83c
> Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  libibverbs/tm_types.h | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>  create mode 100644 libibverbs/tm_types.h
> 
> diff --git a/libibverbs/tm_types.h b/libibverbs/tm_types.h
> new file mode 100644
> index 0000000..7626787
> +++ b/libibverbs/tm_types.h

There is no cmake stuff for this file, and it is never used in this
series - what is the intention here?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
