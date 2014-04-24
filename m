From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 00/20] On demand paging
Date: Thu, 24 Apr 2014 17:10:44 +0300
Message-ID: <53591B64.3000307@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/03/2014 12:49, Haggai Eran wrote:
> The following set of patches implements on-demand paging (ODP) support
> in the RDMA stack and in the mlx5_ib Infiniband driver.
>

I've placed the latest cut of the ODP patches on my public git tree @

git://beany.openfabrics.org/~ogerlitz/linux-2.6.git odp

this is actually V0.1 with the following changes:

- Rebase against v3.15-rc2
- Removed dependency on patches that were accepted upstream
- Changed use of compound_trans_head to compound_head as the latter was 
removed in 3.14


f5d7fc1 IB/mlx5: Implement on demand paging by adding support for MMU 
notifiers
09eae22 IB/mlx5: Add support for RDMA write responder page faults
ca84a78 IB/mlx5: Handle page faults
302a6ea IB/mlx5: Page faults handling infrastructure
df792a8 IB/mlx5: Add function to read WQE from user-space
1b4f69b IB/mlx5: Add mlx5_ib_update_mtt to update page tables after creation
bc5a6b0 IB/mlx5: Changes in memory region creation to support on-demand 
paging
335c8ef IB/mlx5: Implement the ODP capability query verb
5a67390 net/mlx5_core: Add support for page faults events and low level 
handling
11450c4 IB/mlx5: Refactor UMR to have its own context struct
51deb37 IB/mlx5: Enhance UMR support to allow partial page table update
107bc64 IB/mlx5: Set QP offsets and parameters for user QPs and not just 
for kernel QPs
e91a314 mlx5: Store MR attributes in mlx5_mr_core during creation and 
after UMR
894f946 IB/mlx5: Add MR to radix tree in reg_mr_callback
9283891 IB/mlx5: Fix error handling in reg_umr
467f4e7 IB/core: Implement support for MMU notifiers regarding on demand 
paging regions
c98a42e IB/core: Add support for on demand paging regions
8fb5241 IB/core: Add umem function to read data from user-space
16c9cf0 IB/core: Replace ib_umem's offset field with a full address
9f0d8b5 IB/core: Add flags for on demand paging support

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
