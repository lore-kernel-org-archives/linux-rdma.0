From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86/mm/pat, drivers/infiniband/ipath: replace WARN()
 with pr_warn()
Date: Tue, 23 Jun 2015 09:39:59 +0200
Message-ID: <20150623073959.GC21872@gmail.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
 <1435012318-381-2-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435012318-381-2-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com, fengguang.wu@intel.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-rdma@vger.kernel.org


* Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> On built-in kernels this will always splat. Fix that.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
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

Same observation as for the other patch: please only warn if the hardware is 
present and the driver tries to activate. No need to annoy others.

Thanks,

	Ingo
