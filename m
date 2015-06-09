From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v6 1/3] ivtv: use arch_phys_wc_add() and require PAT
 disabled
Date: Mon, 8 Jun 2015 21:56:25 -0300
Message-ID: <20150608215625.39544c82@recife.lan>
References: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>
	<1433809222-28261-2-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433809222-28261-2-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: bp@suse.de, tomi.valkeinen@ti.com, bhelgaas@google.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Andy Walls <awalls@md.metrocast.net>, Doug Ledford <dledford@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Dave Hansen <dave.hansen@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Bader <stefan.bader@canonical.com>, Ville =?UTF-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidl
List-Id: linux-rdma@vger.kernel.org

Em Mon, 08 Jun 2015 17:20:20 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> escreveu:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>=20
> We are burrying direct access to MTRR code support on
> x86 in order to take advantage of PAT. In the future we
> also want to make the default behaviour of ioremap_nocache()
> to use strong UC, use of mtrr_add() on those systems
> would make write-combining void.
>=20
> In order to help both enable us to later make strong
> UC default and in order to phase out direct MTRR access
> code port the driver over to arch_phys_wc_add() and
> annotate that the device driver requires systems to
> boot with PAT disabled, with the nopat kernel parameter.
>=20
> This is a worthy comprmise given that the hardware is
> really rare these days, and perhaps only some lost souls
> in some third world country are expected to be using this
> feature of the device driver.
>=20
> Acked-by: Andy Walls <awalls@md.metrocast.net>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Provided that you fix the issues below:
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Suresh Siddha <sbsiddha@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Antonino Daplas <adaplas@gmail.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Stefan Bader <stefan.bader@canonical.com>
> Cc: Ville Syrj=C3=A4l=C3=A4 <syrjala@sci.fi>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Davidlohr Bueso <dbueso@suse.de>
> Cc: konrad.wilk@oracle.com
> Cc: ville.syrjala@linux.intel.com
> Cc: david.vrabel@citrix.com
> Cc: jbeulich@suse.com
> Cc: toshi.kani@hp.com
> Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org
> Cc: xen-devel@lists.xensource.com
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  drivers/media/pci/ivtv/Kconfig  |  3 +++
>  drivers/media/pci/ivtv/ivtvfb.c | 58 ++++++++++++++++---------------=
----------
>  2 files changed, 26 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/=
Kconfig
> index dd6ee57e..b2a7f88 100644
> --- a/drivers/media/pci/ivtv/Kconfig
> +++ b/drivers/media/pci/ivtv/Kconfig
> @@ -57,5 +57,8 @@ config VIDEO_FB_IVTV
>  	  This is used in the Hauppauge PVR-350 card. There is a driver
>  	  homepage at <http://www.ivtvdriver.org>.
> =20
> +	  If you have this hardware you will need to boot with PAT disabled
> +	  on your x86 systems, use the nopat kernel parameter.
> +

Hmm... FB_IVTV is not hardware... it is framebuffer support for IVTV.
It is optional to use FB API for the video output port of this board,
instead of using V4L2 API.

I would say, instead, something like:=20

	"In order to use this module, you will need to boot with PAT disabled
	  on x86 systems, using the nopat kernel parameter."

>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ivtvfb.
> diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv=
/ivtvfb.c
> index 9ff1230..7685ae3 100644
> --- a/drivers/media/pci/ivtv/ivtvfb.c
> +++ b/drivers/media/pci/ivtv/ivtvfb.c
> @@ -44,8 +44,8 @@
>  #include <linux/ivtvfb.h>
>  #include <linux/slab.h>
> =20
> -#ifdef CONFIG_MTRR
> -#include <asm/mtrr.h>
> +#ifdef CONFIG_X86_64
> +#include <asm/pat.h>
>  #endif
> =20
>  #include "ivtv-driver.h"
> @@ -155,12 +155,11 @@ struct osd_info {
>  	/* Buffer size */
>  	u32 video_buffer_size;
> =20
> -#ifdef CONFIG_MTRR
>  	/* video_base rounded down as required by hardware MTRRs */
>  	unsigned long fb_start_aligned_physaddr;
>  	/* video_base rounded up as required by hardware MTRRs */
>  	unsigned long fb_end_aligned_physaddr;
> -#endif
> +	int wc_cookie;
> =20
>  	/* Store the buffer offset */
>  	int set_osd_coords_x;
> @@ -1099,6 +1098,8 @@ static int ivtvfb_init_vidmode(struct ivtv *itv=
)
>  static int ivtvfb_init_io(struct ivtv *itv)
>  {
>  	struct osd_info *oi =3D itv->osd_info;
> +	/* Find the largest power of two that maps the whole buffer */
> +	int size_shift =3D 31;
> =20
>  	mutex_lock(&itv->serialize_lock);
>  	if (ivtv_init_on_first_open(itv)) {
> @@ -1132,29 +1133,16 @@ static int ivtvfb_init_io(struct ivtv *itv)
>  			oi->video_pbase, oi->video_vbase,
>  			oi->video_buffer_size / 1024);
> =20
> -#ifdef CONFIG_MTRR
> -	{
> -		/* Find the largest power of two that maps the whole buffer */
> -		int size_shift =3D 31;
> -
> -		while (!(oi->video_buffer_size & (1 << size_shift))) {
> -			size_shift--;
> -		}
> -		size_shift++;
> -		oi->fb_start_aligned_physaddr =3D oi->video_pbase & ~((1 << size_s=
hift) - 1);
> -		oi->fb_end_aligned_physaddr =3D oi->video_pbase + oi->video_buffer=
_size;
> -		oi->fb_end_aligned_physaddr +=3D (1 << size_shift) - 1;
> -		oi->fb_end_aligned_physaddr &=3D ~((1 << size_shift) - 1);
> -		if (mtrr_add(oi->fb_start_aligned_physaddr,
> -			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr,
> -			     MTRR_TYPE_WRCOMB, 1) < 0) {
> -			IVTVFB_INFO("disabled mttr\n");
> -			oi->fb_start_aligned_physaddr =3D 0;
> -			oi->fb_end_aligned_physaddr =3D 0;
> -		}
> -	}
> -#endif
> -
> +	while (!(oi->video_buffer_size & (1 << size_shift)))
> +		size_shift--;
> +	size_shift++;
> +	oi->fb_start_aligned_physaddr =3D oi->video_pbase & ~((1 << size_sh=
ift) - 1);
> +	oi->fb_end_aligned_physaddr =3D oi->video_pbase + oi->video_buffer_=
size;
> +	oi->fb_end_aligned_physaddr +=3D (1 << size_shift) - 1;
> +	oi->fb_end_aligned_physaddr &=3D ~((1 << size_shift) - 1);
> +	oi->wc_cookie =3D arch_phys_wc_add(oi->fb_start_aligned_physaddr,
> +					 oi->fb_end_aligned_physaddr -
> +					 oi->fb_start_aligned_physaddr);
>  	/* Blank the entire osd. */
>  	memset_io(oi->video_vbase, 0, oi->video_buffer_size);
> =20
> @@ -1172,14 +1160,7 @@ static void ivtvfb_release_buffers (struct ivt=
v *itv)
> =20
>  	/* Release pseudo palette */
>  	kfree(oi->ivtvfb_info.pseudo_palette);
> -
> -#ifdef CONFIG_MTRR
> -	if (oi->fb_end_aligned_physaddr) {
> -		mtrr_del(-1, oi->fb_start_aligned_physaddr,
> -			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr);
> -	}
> -#endif
> -
> +	arch_phys_wc_del(oi->wc_cookie);
>  	kfree(oi);
>  	itv->osd_info =3D NULL;
>  }
> @@ -1284,6 +1265,13 @@ static int __init ivtvfb_init(void)
>  	int registered =3D 0;
>  	int err;
> =20
> +#ifdef CONFIG_X86_64
> +	if (WARN(pat_enabled(),
> +		 "ivtvfb needs PAT disabled, boot with nopat kernel parameter\n"))=
 {
> +		return EINVAL;

Errors are always negative. So:=20
		return -EINVAL

Or, perhaps, -ENODEV.

> +	}
> +#endif
> +
>  	if (ivtvfb_card_id < -1 || ivtvfb_card_id >=3D IVTV_MAX_CARDS) {
>  		printk(KERN_ERR "ivtvfb:  ivtvfb_card_id parameter is out of range=
 (valid range: -1 - %d)\n",
>  		     IVTV_MAX_CARDS - 1);
