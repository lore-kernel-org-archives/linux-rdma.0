From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 00/20] On demand paging
Date: Thu, 13 Mar 2014 14:00:33 +0200
Message-ID: <53219DE1.4060408@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/03/2014 12:49, Haggai Eran wrote:
> The following set of patches implements on-demand paging (ODP) support
> in the RDMA stack and in the mlx5_ib Infiniband driver.

Hi Roland,

Did you get a chance to look at this patchset? I'll be happy to hear 
your comments or answers any questions you may have.

I also wanted to point out that some of the patches in the set may be 
picked up separately as fixes, and perhaps that would make the set 
shorter and easier to review.

Specifically, I think the following patches can be taken independently
today:
> IB/mlx5: Fix error handling in reg_umr
> IB/mlx5: Add MR to radix tree in reg_mr_callback
> mlx5: Store MR attributes in mlx5_mr_core during creation and after UMR
> IB/mlx5: Set QP offsets and parameters for user QPs and not just for kernel QPs
> IB/mlx5: Refactor UMR to have its own context struct

Best regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
