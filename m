From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Wed, 7 Sep 2016 08:55:19 +0300
Message-ID: <20160907055519.GT21847@leon.nu>
References: <1472738739.16467.8.camel@intel.com>
 <20160901164624.GC6479@obsidianresearch.com>
 <20160901165552.GE21847@leon.nu>
 <20160901170742.GA20098@obsidianresearch.com>
 <1472749767.16467.25.camel@intel.com>
 <20160901171129.GB19982@obsidianresearch.com>
 <1472750241.16467.29.camel@intel.com>
 <20160901173320.GB20472@obsidianresearch.com>
 <20160901175222.GF21847@leon.nu>
 <20160906210313.GA24527@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aeKQ3o3ktSNpH7mO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160906210313.GA24527-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aeKQ3o3ktSNpH7mO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 06, 2016 at 05:03:14PM -0400, ira.weiny wrote:
> On Thu, Sep 01, 2016 at 08:52:22PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 01, 2016 at 11:33:20AM -0600, Jason Gunthorpe wrote:
> > > On Thu, Sep 01, 2016 at 05:17:26PM +0000, Dalessandro, Dennis wrote:
> > > > On Thu, 2016-09-01 at 11:11 -0600, Jason Gunthorpe wrote:
> > > > > On Thu, Sep 01, 2016 at 05:09:31PM +0000, Dalessandro, Dennis wrote:
> > > > >
> > > > > > > Dennis should use an internal definition in PSM if he wishes to
> > > > > > > continue to support the staging kernel ABI.
> > > > > >
> > > > > > It's not just the backward compatibility. PSM uses these command
> > > > > > definitions.So this breaks current support with current driver.
> > > > >
> > > > > How exactly? The HFI1_CMD_ASSIGN_CTXT constant is never used in the
> > > > > kernel?
> > > >
> > > > This is used in PSM library. Agree it's not used in the kernel, so I
> > > > can see the argument to get rid of it, or not care.
> > >
> > > Lets get rid of all the #defines. Leon you should just inline the
> > > ioctl numbers into the ioctl definition like normal and get rid of
> > > this extra layer of macros.
> >
> > Ohh, it looks like you returned to us filled with positive energy :)
> >
> > I tried to follow DRM subsystem [1] while converted these names with
> > minimal impact on the current implementation.
>
> I like the idea of borrowing from the DRM subsystem but that is not quite what
> I see here.

"followed" != ("borrowed" || "copy-pasted")

To make long story short.

1. You took 0xE0 as a base for HFI while claimed to take 0xF0. There is
nothing about 0x80 as a base. See commit 8d970cf991a6c38a5566572979487b906d643740

+/*
+ * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
+ */
+#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)

2. In new ABI, you will define your special objects, mark them as a
vendor specific and the driver will be called immediately. IMHO, there
is no need in special ioctl.

3. The Jason's point do not pollute code with defines/code which not in
use has very solid background. It is right time to stop misuse of UAPI
which you did. I'm pretty sure that you was supposed to update your PSM
library when you moved from staging and converted from write to ioctl.
I didn't hear complains about it.

Thanks.

--aeKQ3o3ktSNpH7mO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXz6vHAAoJEORje4g2clinBoMP/1dtVA93+1fLNFDslCIaQBa+
pxwH3xw5zNRb0928wig8ItfPkckaH6sicv/cNDZ9vAcokJcv30OViscCTn5/8yT/
tcBZlweR6kWQl8dcpXKHTivu3D2BmDFOnDZqupYzY/+zVjktTx8ZQDABidrl7wqf
NmSvdvHuFSds9Nbh3ksE9Er2iuAEcx85vy55qxIUaJDm8+cxTTZhatNkciNOSP8p
g5ulr6nOFRvfVaID+FSdEPMPwJ6ZT3mlSNpKw88XHj8UDEsUPYVwrjsLJkIAshN4
bJfHRk4U3zO7pR4CTKg/JAZG7aiIVADF0/rU1gJK1p7o5sArlkEpHBbaEtvd4Hr2
PaAP4LpH7NBoQ0ZrKY+DvqLVjpmm88zYSdOenfQxSgdkrdgM8fAO9rn8ZuaE567X
q0pDmEshFSycrMoK9DUn3vQzhUvXzeA/4sx66TUvOBXTpee6InK7dRzsDK3BNhrh
ohGmLpXbSu36MrHCHQ+JZ79XmgeOW69h3VeS3GYKYt0fvjQ/W/TuBbY6dJz85DGr
1X32QqyTFsXZWAsNFMnG6JTn3xyqBa7pc159NEC9OmnpCHJAhQJ8PpGR1yNMicRv
S43Sq/e9GXFYVXR10/Hz1WWWcc4dsb/SV4uX3PaccMablndA1zNrDJKbGyZCtagd
+B+apAqf8JrsnMaia9E2
=csK4
-----END PGP SIGNATURE-----

--aeKQ3o3ktSNpH7mO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
