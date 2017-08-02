From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 21:54:05 +0300
Message-ID: <20170802185405.GE13672@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <1501696661.109555.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ka8pmxPp9qZnI4DD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501696661.109555.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ka8pmxPp9qZnI4DD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 02, 2017 at 01:57:41PM -0400, Doug Ledford wrote:
> On Tue, 2017-08-01 at 17:10 +0300, Leon Romanovsky wrote:
> > On Tue, Aug 01, 2017 at 08:38:32AM -0500, Chien Tin Tung wrote:
> > > On Tue, Aug 01, 2017 at 03:05:04PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > The commit cea05eadded0 ("IB/core: Add flow control to the
> > > > portmapper netlink calls")
> > > > changed netlink to be blocked for all RDMA clients. This
> > > > workaround
> > > > worked perfectly for portmapper, but is not correct for the whole
> > > > NETLINK_RDMA family.
> > >
> > > Leon,
> > >
> > > I've already told you I'm opposed to the revert.  There is a patch
> > > that will work
> > > with your usage of ibnl_unicast() but you chose to abandon that
> > > discussion on June 29, 2017
> > > (RDMA/core: Add wait/retry version of ibnl_unicast).  Either you
> > > step up with good sound
> > > technical evidence to convince me that patch won't work for you or
> > > you stop trying to
> > > break existing functionality with this revert.
> >
> > Chien,
> >
> > You never explained us what exactly your original patch fixed and why
> > it
> > should be fixed in kernel and not in user space. I saw that our
> > discussion wasn't useful and brought bad blood instead of good will,
> > so I stepped out in waited for RDMA maintainer (Doug) step in.
> >
> > I never heard anything from Doug on the matter, so proceeded and
> > resubmitted it.
>
> What makes you think *I* want to be in the middle of a school yard
> squabble like this?

It is not "I" want, but "I" expect and "I" demand from the maintainer.
It is his responsibility to drive to the resolution for the important
core patches.

This revert was discussed for something like month+, as an outcome of
it, Chien reviewed and sent much more improved version of their original
patch, without socket timeout and with minimal blocking places.

So please, don't say "school yard", especially after your silence.

Thanks

--ka8pmxPp9qZnI4DD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmCH80ACgkQ5GN7iDZy
WKcnsBAAgfzdbL/VkGMtW6GCk0ZCMIwy9RzRQNwH+vAFTbjbfe9I8Ut3Fg2dMcIC
tyCkvGo5lruTD3++ccm68raOJb+97IxpaeSehasqBg290rXxRMIrxodl+mOys+zr
yQWFwwkqRs4Z2Z5gD23gtNY8ybblcbHrNOxC36OYvZ+NuvgmnFcyiwV+qoZ9muE5
a97rP1kHI65ELNC+ly0zmwQtRFl7i5rq3lLCet514oepFEZZ3Ord5aCigCUsKzbv
+6wuLN7cBYc1UJX2rvaSDPSH6Pc+LAkM3EIn1ZD6U1sdxfhdNk9HGCeNzbbX6AHU
1vRURtUV8Zc51x9+WCVJsn+oeiQMCOYvOqSRQYryK/T4Q65Od2P31KeztVZVL9bC
SzfAsHm+eNNMNkP7dc3E3glrz0MBncNUcCFb8DHYrEfCK6bquRmIaT6l06U2MWz8
IARJXZZLLijYTSIruZzTQO3tqMEXWJO/LlTuNfPe++BevBtI+IfIUyWhhLOGF7iL
HjyVVthg+cOohMrDAYdi2tW8Ej5deon2PZN8pI16Lm1Xmhxx4zLCVW6pMB54i97e
7WNF+MRXIU52Rq+gzOXZRH44YjjHdWQ+nY/wkMBHLgoQ+z6nyR9Knf7uhlR6aWk7
wnF7BKDHSpkiPztLmHLiqEcQVWY16hCsfFv41uy+aqpYEf74IP8=
=dPyw
-----END PGP SIGNATURE-----

--ka8pmxPp9qZnI4DD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
