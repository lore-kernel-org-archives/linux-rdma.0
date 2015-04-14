From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 2/2] IB/core: don't disallow registering region starting
 at 0x0
Date: Tue, 14 Apr 2015 12:20:22 +0300
Message-ID: <552CDBD6.1020205@dev.mellanox.co.il>
References: <cover.1428929103.git.ydroneaud@opteya.com> <ca0fad20f6eff1dae5c4c8cd92fccad188d685c4.1428929103.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <ca0fad20f6eff1dae5c4c8cd92fccad188d685c4.1428929103.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>, Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, Shachar Raindel <raindel@mellanox.com>, Jack Morgenstein <jackm@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 4/13/2015 3:56 PM, Yann Droneaud wrote:
> In a call to ib_umem_get(), if address is 0x0 and size is
> already page aligned, check added in commit 8494057ab5e4
> ("IB/uverbs: Prevent integer overflow in ib_umem_get address
> arithmetic") will refuse to register a memory region that
> could otherwise be valid (provided vm.mmap_min_addr sysctl
> and mmap_low_allowed SELinux knobs allow userspace to map
> something at address 0x0).
>
> This patch allows back such registration: ib_umem_get()
> should probably don't care of the base address provided it
> can be pinned with get_user_pages().
>
> There's two possible overflows, in (addr + size) and in
> PAGE_ALIGN(addr + size), this patch keep ensuring none
> of them happen while allowing to pin memory at address
> 0x0. Anyway, the case of size equal 0 is no more (partially)
> handled as 0-length memory region are disallowed by an
> earlier check.
>
> Link: http://mid.gmane.org/cover.1428929103.git.ydroneaud@opteya.com
> Cc: <stable@vger.kernel.org> # 8494057ab5e4 ("IB/uverbs: Prevent integer overflow in ib_umem_get address arithmetic")
> Cc: Shachar Raindel <raindel@mellanox.com>
> Cc: Jack Morgenstein <jackm@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>   drivers/infiniband/core/umem.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 9ac4068d2088..38acb3cfc545 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -106,8 +106,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>   	 * If the combination of the addr and size requested for this memory
>   	 * region causes an integer overflow, return error.
>   	 */
> -	if ((PAGE_ALIGN(addr + size) <= size) ||
> -	    (PAGE_ALIGN(addr + size) <= addr))
> +	if (((addr + size) < addr) ||
> +	    PAGE_ALIGN(addr + size) < (addr + size))

If you do change the first statement to be: (addr + size) <= addr
wouldn't it cover patch #1?

Sagi.
