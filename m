From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCHv2 net-next 29/31] iw_cxgb4: minor fixes/cleanup.
Date: Mon, 03 Mar 2014 21:55:13 +0300
Message-ID: <5314D011.7090104@cogentembedded.com>
References: <1393828875-13452-1-git-send-email-hariprasad@chelsio.com> <1393828875-13452-30-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1393828875-13452-30-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Hariprasad Shenai <hariprasad@chelsio.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, kumaras@chelsio.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, santosh@chelsio.com, nirranjan@chelsio.com
List-Id: linux-rdma@vger.kernel.org

Hello.

On 03/03/2014 09:41 AM, Hariprasad Shenai wrote:

> From: Steve Wise <swise@opengridcomputing.com>

> Added some missing debug stats.

> Use uninitialized_var().

> Rate limit warning printks.

    Wasn't it already rate-limited?

> Initialize reserved fields in a FW work request.

    I don't think it's a great idea to mix several fixes and worse, cleanups 
in the same patch.

> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
[...]

> diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
> index cdef4d7..69e57d0 100644
> --- a/drivers/infiniband/hw/cxgb4/resource.c
> +++ b/drivers/infiniband/hw/cxgb4/resource.c
[...]
> @@ -322,8 +326,8 @@ u32 c4iw_rqtpool_alloc(struct c4iw_rdev *rdev, int size)
>   	unsigned long addr = gen_pool_alloc(rdev->rqt_pool, size << 6);
>   	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size << 6);
>   	if (!addr)
> -		printk_ratelimited(KERN_WARNING MOD "%s: Out of RQT memory\n",
> -		       pci_name(rdev->lldi.pdev));
> +		pr_warn_ratelimited(KERN_WARNING MOD "%s: Out of RQT memory\n",

    You forgot to remove KERN_WARNING.

WBR, Sergei
