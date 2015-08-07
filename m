From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/hfi1: Remove some sysfs files
Date: Fri, 7 Aug 2015 16:43:52 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577B0B5@fmsmsx120.amr.corp.intel.com>
References: <20150807133610.12421.73468.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1508070948510.14626@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1508070948510.14626-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >  {
> > @@ -599,25 +581,21 @@ static ssize_t show_tempsense(struct device
> > *device,
> >  /* start of per-unit file structures and support code */  static
> > DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);  static
> > DEVICE_ATTR(board_id, S_IRUGO, show_hfi, NULL); -static
> > DEVICE_ATTR(version, S_IRUGO, show_version, NULL);  static
> > DEVICE_ATTR(nctxts, S_IRUGO, show_nctxts, NULL);  static
> > DEVICE_ATTR(nfreectxts, S_IRUGO, show_nfreectxts, NULL);  static
> > DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);  static
> > DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);  static
> > DEVICE_ATTR(tempsense, S_IRUGO, show_tempsense, NULL); -static
> > DEVICE_ATTR(localbus_info, S_IRUGO, show_localbus_info, NULL);  static
> > DEVICE_ATTR(chip_reset, S_IWUSR, NULL, store_chip_reset);
> 
> AFAICT the remaining are also provided by generic APIs (aside from nctxt,
> nfreectxts). I really want our management appss for device etc not to crap
> out.
> 

All of these remaining files are provided by hardware specific CSRs.  There is no Vital Product Data in the hardware as you provided in the prior Mellanox example.

I will see if I can release an lspci -vv.

What specific management apps would be broke?

Do those apps work with qib?

At any rate I was a bit presumptive on removing the TODO.  I have removed that and I have also updated sysfs.txt to reflect this patch's end state in a v2.

> Could you get some experienced engineers to look at the driver internally to
> Intel before publishing? There are numerous other drivers in the kernel by
> Intel that do the right thing.
> 

I will try to get a review from internal engineers.

> That this is duplicated and the other things show issues with kernel basics.
> The driver in its entirety probably does not follow the quality that we are
> used to from other developers at Intel. Its likely that structural changes need
> to be made to the driver. Significant portions may be duplicating
> functionality that the kernel already provides as generic functionality. Also
> we have already established that there is significantly duplication of other
> drivers in the infiniband tree.
> 

We already know about the transport duplication and we are starting to scope that effort.

> Should this not go into staging instead? If this is merged then the push to
> clean these issues up goes away like it did with the earlier incarnations of
> this hardware.

The driver IS in staging.   The TODO should reflect the rework.

Mike


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
