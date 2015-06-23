From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] x86/mm/pat, drivers/media/ivtv: replace WARN() with
 pr_warn()
Date: Tue, 23 Jun 2015 09:39:12 +0200
Message-ID: <20150623073911.GB21872@gmail.com>
References: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
 <1435012318-381-3-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435012318-381-3-git-send-email-mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Cc: bp-l3A5Bk7waGM@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


* Luis R. Rodriguez <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:

> From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
> 
> On built-in kernels this will always splat. Fix that.
> 
> Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [0-day test robot]
> Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/media/pci/ivtv/ivtvfb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> index 4cb365d..6f0c364 100644
> --- a/drivers/media/pci/ivtv/ivtvfb.c
> +++ b/drivers/media/pci/ivtv/ivtvfb.c
> @@ -38,6 +38,8 @@
>      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/fb.h>
> @@ -1266,8 +1268,8 @@ static int __init ivtvfb_init(void)
>  	int err;
>  
>  #ifdef CONFIG_X86_64
> -	if (WARN(pat_enabled(),
> -		 "ivtvfb needs PAT disabled, boot with nopat kernel parameter\n")) {
> +	if (pat_enabled()) {
> +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
>  		return -ENODEV;
>  	}

So why should a built-in kernel bzImage with this driver enabled but the driver 
not present print this warning?

Why not only print in a code path where we know the hardware is present? 

allyesconfig bootups are noisy enough as-is ...

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
