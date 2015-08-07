From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Remove some sysfs files
Date: Fri, 7 Aug 2015 09:57:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1508070948510.14626@east.gentwo.org>
References: <20150807133610.12421.73468.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150807133610.12421.73468.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 7 Aug 2015, Mike Marciniszyn wrote:

>  {
> @@ -599,25 +581,21 @@ static ssize_t show_tempsense(struct device *device,
>  /* start of per-unit file structures and support code */
>  static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
>  static DEVICE_ATTR(board_id, S_IRUGO, show_hfi, NULL);
> -static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
>  static DEVICE_ATTR(nctxts, S_IRUGO, show_nctxts, NULL);
>  static DEVICE_ATTR(nfreectxts, S_IRUGO, show_nfreectxts, NULL);
>  static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
>  static DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);
>  static DEVICE_ATTR(tempsense, S_IRUGO, show_tempsense, NULL);
> -static DEVICE_ATTR(localbus_info, S_IRUGO, show_localbus_info, NULL);
>  static DEVICE_ATTR(chip_reset, S_IWUSR, NULL, store_chip_reset);

AFAICT the remaining are also provided by generic APIs (aside from nctxt,
nfreectxts). I really want our management appss for device etc not to crap out.

Could you get some experienced engineers to look at the driver
internally to Intel before publishing? There are numerous other drivers in
the kernel by Intel that do the right thing.

That this is duplicated and the other things show issues with kernel
basics. The driver in its entirety probably does not follow the quality
that we are used to from other developers at Intel. Its likely that
structural changes need to be made to the driver. Significant portions may
be duplicating functionality that the kernel already provides as generic
functionality. Also we have already established that there is
significantly duplication of other drivers in the infiniband tree.

Should this not go into staging instead? If this is merged then the push
to clean these issues up goes away like it did with the earlier
incarnations of this hardware.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
