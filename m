From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/mm/pat, drivers/infiniband/ipath: replace
 WARN() with pr_warn()
Date: Thu, 25 Jun 2015 08:49:22 +0200
Message-ID: <20150625064922.GA5339@gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-2-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435166600-11956-2-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: bp@suse.de, andy@silverblocksystems.net, mchehab@osg.samsung.com, dledford@redhat.com, fengguang.wu@intel.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-rdma@vger.kernel.org


* Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> WARN() may confuse users, fix that. ipath_init_one() is part the
> device's probe so this would only be triggered if a corresponding
> device was found.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
> index 2d7e503..871dbe5 100644
> --- a/drivers/infiniband/hw/ipath/ipath_driver.c
> +++ b/drivers/infiniband/hw/ipath/ipath_driver.c
> @@ -31,6 +31,8 @@
>   * SOFTWARE.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/sched.h>
>  #include <linux/spinlock.h>
>  #include <linux/idr.h>
> @@ -399,8 +401,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u32 bar0 = 0, bar1 = 0;
>  
>  #ifdef CONFIG_X86_64
> -	if (WARN(pat_enabled(),
> -		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
> +	if (pat_enabled()) {
> +		pr_warn("ipath needs PAT disabled, boot with nopat kernel parameter\n");
>  		ret = -ENODEV;
>  		goto bail;
>  	}

So driver init will always fail with this on modern kernels.

Btw., on a second thought, ipath uses MTRRs to enable WC:

        ret = ipath_enable_wc(dd);
        if (ret)
                ret = 0;

Note how it ignores any failures - the driver still works even if WC was not 
enabled.

So why don't you simply extend ipath_enable_wc() to generate the warning message 
and return -EINVAL - which still keeps the driver working on modern kernels?

Just inform the user about 'nopat' if he wants WC for this driver.

Thanks,

	Ingo
