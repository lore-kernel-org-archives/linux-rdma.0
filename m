From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Thu, 1 Sep 2016 20:52:22 +0300
Message-ID: <20160901175222.GF21847@leon.nu>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <1471987907-6336-7-git-send-email-leon@kernel.org>
 <1472738739.16467.8.camel@intel.com>
 <20160901164624.GC6479@obsidianresearch.com>
 <20160901165552.GE21847@leon.nu>
 <20160901170742.GA20098@obsidianresearch.com>
 <1472749767.16467.25.camel@intel.com>
 <20160901171129.GB19982@obsidianresearch.com>
 <1472750241.16467.29.camel@intel.com>
 <20160901173320.GB20472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901173320.GB20472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 01, 2016 at 11:33:20AM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2016 at 05:17:26PM +0000, Dalessandro, Dennis wrote:
> > On Thu, 2016-09-01 at 11:11 -0600, Jason Gunthorpe wrote:
> > > On Thu, Sep 01, 2016 at 05:09:31PM +0000, Dalessandro, Dennis wrote:
> > >
> > > > > Dennis should use an internal definition in PSM if he wishes to
> > > > > continue to support the staging kernel ABI.
> > > >
> > > > It's not just the backward compatibility. PSM uses these command
> > > > definitions.So this breaks current support with current driver.
> > >
> > > How exactly? The HFI1_CMD_ASSIGN_CTXT constant is never used in the
> > > kernel?
> >
> > This is used in PSM library. Agree it's not used in the kernel, so I
> > can see the argument to get rid of it, or not care.
>
> Lets get rid of all the #defines. Leon you should just inline the
> ioctl numbers into the ioctl definition like normal and get rid of
> this extra layer of macros.

Ohh, it looks like you returned to us filled with positive energy :)

I tried to follow DRM subsystem [1] while converted these names with
minimal impact on the current implementation.


> This way Dennis will get a build failure when PSM is build with these
> headers instead of subtle runtime breakage. He can import the required
> definitions to support the staging compat ABI into PSM, where they
> belong, and make a new release to build with new kernel headers. Lots
> of time to do that before these headers hit the distros.
>
> Upstream is not the place to carry that stuff, and keeping strange
> subtleness with __NUM is just going to risk future breakage.

I would love to go in this direction, to get rid of unused defines
(especially in UAPIs).

Let's wait till Sunday, maybe we will see more discussions on the topic.

[1] http://lxr.free-electrons.com/source/include/uapi/drm/i915_drm.h

>
> Jason

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyGrWAAoJEORje4g2clinCdIP/34150r+1nYsArh6Dz+t/tkt
aOs0Pp9z7n6dcBqt195XTpBH87sKam1Pg5+3tpxoBYex3XbhS1zI6v8CK4kVj5iR
rJsXA0sh8mVcc5/odu2dhvw8HISqSJcUGa9szuvzipRRVblNawjNu5//IqgvWt23
ClLbDesx3CtgLrxMz7beuenz1np6SsWpJi3z68NOjw/PCEobd8m+It5EJN5GL0nO
Ip6ntz8ekbuWccjtG6+oSVMJRMB5FTAdJrq0ltNDScztKNvo58wNc19m/iLqXS0Y
mdriUb3RVac8gh6b27FPq16HeJxfzShV5PI3wuMOnVoRirPu5u1zsYefGOFvYw/R
AfnPxaCuynJHKQoXmLXucWSkcAcYAvMKJy+mcnJil3EGLlkdowfs3uQe+/xfZJqk
3JQvrQuZXaGrEU8L+/+1clCnaPHGmLn5v/aWqlNhpr7JkpMNhMZrNDundef1NxNV
4rp0IKcB40bNe2A5VxeqC03U0eTlRxEz43jOaJV1HpEErEEclF02esDXV0BX8AHj
k6gtTQhYN/AISaMG8wLOAN1rzCUsKoiRDg1qd/vcCVH9M2kABmAlj25F4PhF5k0S
fYjiBFfDMQn8gmmd6xXYERFZjNws2BYvqs3udKGSKznjmaR4ouATS5JKY8U/Ox6t
zB/TpeKDeCQT/bTUt1/n
=PPiG
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
