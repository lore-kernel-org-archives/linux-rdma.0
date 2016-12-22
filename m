From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
Date: Thu, 22 Dec 2016 21:17:59 +0200
Message-ID: <20161222191759.GF18935@mtr-leonro.local>
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1a61e971-4944-b8db-0fd5-b73118b578db@redhat.com>
 <20161222171323.GC18935@mtr-leonro.local>
 <ed8ea5d4-9cb2-465d-88a8-bdca848efcfd@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ed8ea5d4-9cb2-465d-88a8-bdca848efcfd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2016 at 01:19:35PM -0500, Doug Ledford wrote:
> On 12/22/2016 12:13 PM, Leon Romanovsky wrote:
> > On Thu, Dec 22, 2016 at 11:53:20AM -0500, Doug Ledford wrote:
> >> On 12/19/2016 3:31 PM, Tatyana Nikolova wrote:
> >>> RQ WQE size other than 128B is not supported.
> >>> Correct RQ size calculation to use 128B only.
> >>>
> >>> Since this breaks ABI, add code to provide
> >>> compatibility with V4 kernel driver, i40iw.
> >>>
> >>> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >> Thanks, applied.
> >
> > Hi Doug,
> >
> > Please can you clarify a process here?
> >
> > In previous discussions, you mentioned that the reason of not accepting
> > some code to rdma-core was because it is part of next kernel and we
> > patiently waited for release. This code is definitely not relevant for
> > current kernel, but you are already took it before we ever released first
> > version of rdma-core.
> >
> > So why are we waiting with libpvrdma and RoCE address handle?
>
> You're right, that was a mistake on my part.  I'll probably have to
> revert this patch, then reapply it for the next version since the 4.10
> kernel is the first one to provide the abi field to the user space library.

I assume that you are waiting for RHEL spec fixes to do actual release, but
maybe we should release it anyway now (replace rc3 with actual release)?

We are preparing fixes for Debian package which is not in perfect shape too,
and I don't want to let people wait till all these packages are finalized.

What do you think?

>
> >>
> >> --
> >> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>     GPG Key ID: B826A3330E572FDD
> >>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> >>
> >
> >
> >
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhcJuYACgkQ5GN7iDZy
WKf/OA/+OJxqMLbFzZAWn009cZEYthHq3PEZvLqlZqMQIZZ0HQcqHs5mADIv+/ZE
ukenx0VOZL7AbRNCmWnvGIt8GVBy+eK/wujSDl88A5hYn7iw0cpZODcD5Sgrs4P+
ltv7eeg3iNiJtjAQ3RawU/gntgoRkRMzi67IlGqjqMIlQ3fZVITIhn+Hm67PDiuM
fBwBxR5+4op16ZKedxoWEH3R/mzZB8qE8YIjXdBiSIkFiTXRmPSSDbk8YN2KWayg
wq2Ms1yDbiTAaYCSEJWF5H/3Ip8tQTRpFnmd3N6QTMjPENmhoeBY146eekd9PovJ
VDTAhFwvjPkxc/3ctaC/rvI524n7Iro/lLjLnDnEIs38PRM+t1DrJUJ5q5pRt0R0
/xVm9OX2fC38qXzk74jN54Mn1L87bjcn12eTWR7qUFWcbq/ux8ida7ao6r+dpf8W
EARSFGFW+6lHMkkDKKjKWl1igFk20qX3pAfdyqaqeoYPwaGgcKxcBiAYOhnc1H3X
mphnlpa9F0rHbzSnxivLusTq2e2XvFn1aqi+SRCWtaCOah4silOQQS8kI8AcVKPM
RY2e+mGXN48g1EXCL/51w6H+3uWqtNY8ndQDNW2K0SxFLAd4MEQ+puSnSTXKB/Fd
eR3GyprceevdcsWJZgETXRTf7NFi33TR766tfHVkKJhJwGIdNJ0=
=pRox
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
