From: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Mon, 12 Sep 2016 12:40:43 +0800
Message-ID: <20160912044043.GE3042@linux-kyyb.suse>
References: <1473232990-22766-1-git-send-email-dchang@suse.com>
 <20160908140752.GN18398@leon.nu>
 <20160909025527.GC3042@linux-kyyb.suse>
 <20160910074719.GG6415@leon.nu>
 <20160911071542.GH6415@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160911071542.GH6415-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 11, 2016 at 10:15:42AM +0300, Leon Romanovsky wrote:
> On Sat, Sep 10, 2016 at 10:47:19AM +0300, Leon Romanovsky wrote:
> > On Fri, Sep 09, 2016 at 10:55:27AM +0800, David Chang wrote:
> > > On Thu, Sep 08, 2016 at 05:07:52PM +0300, Leon Romanovsky wrote:
> > > > On Wed, Sep 07, 2016 at 03:23:10PM +0800, David Chang wrote:
> > > > > When using MAD_IFC command, we should also consider avoiding in
> > > > > ISSI > 0 mode, otherwise most of the MAD_IFC command features
> > > > > are deprecated and cannot be used.
> > > > >
> > > > > Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
> > > > > Reported-by: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>
> > > > > Signed-off-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
> > > >
> > > > NAK,
> > > > It is wrong, the deprecation is removed from programming manual.
> > > >
> > >
> > > Without the patch, we got the following message.
> > > [    8.456327] mlx5_core 0000:03:00.0: firmware version: 12.12.780
> > > ...
> >
> > This command is supported only for physical function (PF) drivers
> > and only when physical port is IB without relation to ISSI.
> >
> > When I'll return to office (next week), I'll check that we are checking
> > this requirement correctly.
> >
> > Thanks for providing dump and FW version to reproduce it.
> 
> Hi David,
> 
> Please find this UNTESTED patch. We will do formal testing during the
> coming work week and will properly submit it for inclusion for 4.8.
> From 9147fabc9b189e09a982de8ac30f01f04468f6ce Mon Sep 17 00:00:00 2001
> From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Sun, 11 Sep 2016 10:00:27 +0300
> Subject: [PATCH rdma-rc] IB/mlx5: Enable MAD_IFC commands for IB ports only
> 

Ok! Will test the patch later.

Thanks,
David Chang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
