From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Tue, 8 Nov 2011 15:02:10 +0200
Message-ID: <4EB92852.6020404@mellanox.com>
References: <1320166483-21817-1-git-send-email-roland@purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320166483-21817-1-git-send-email-roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/1/2011 6:54 PM, Roland Dreier wrote:
> Hi Linus, Please pull from
>      git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
> This will get the main batch of changes for 3.2.  One note: my tree is
> based on 3.1-rc9, and I have some changes to drivers/net/mlx4, but in
> your tree that driver has moved to drivers/net/ethernet/mellanox/mlx4.
> With a high enough merge.renamelimit, git handles this merge fine in my test
>

The following commit appears in the kernel "git log" but in not in "git 
log drivers/net/mlx4/main.c" nor "git log 
drivers/net/ethernet/mellanox/mlx4/main.c", looking on the latter code I 
see that the patch was actually applied on the code, just checking if this
missing log points to some other problem?

Or.

> commit cb29688aaa4caa4d54df2976118fe99a839bb433
> Author: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Sun Oct 16 10:26:21 2011 +0200
>
>     mlx4_core: Deprecate log_num_vlan module param
>
>     Enable the maximum size (128) supported by the device for the shadow
>     vlans table, ignoring the module parameter that overrides it.  This
>     table is only used by the IBoE control plane for setting a vlan index
>     into an RC/UC QP context or UD Address Handle.
>
>     Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
> diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
> index f0ee35d..0c0c7d9 100644
> --- a/drivers/net/mlx4/main.c
> +++ b/drivers/net/mlx4/main.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
