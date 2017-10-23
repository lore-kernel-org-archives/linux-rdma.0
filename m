From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Mon, 23 Oct 2017 09:04:36 +0300
Message-ID: <20171023060436.GD2106@mtr-leonro.local>
References: <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
 <20171017081837.GA19107@obsidianresearch.com>
 <20171017102121.GM2106@mtr-leonro.local>
 <20171019061100.GB6555@obsidianresearch.com>
 <20171019061405.GW2106@mtr-leonro.local>
 <c2f3b529-cc53-aef0-fdcf-e86e99360db0@mellanox.com>
 <20171021194215.GA4094@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bLzFIlwpOfW+4Y/z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171021194215.GA4094-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bLzFIlwpOfW+4Y/z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 21, 2017 at 01:42:15PM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2017 at 09:28:31AM +0300, Alex Vesker wrote:
> > On 10/19/2017 9:14 AM, Leon Romanovsky wrote:
> > >On Thu, Oct 19, 2017 at 12:11:00AM -0600, Jason Gunthorpe wrote:
> > >>On Tue, Oct 17, 2017 at 01:21:21PM +0300, Leon Romanovsky wrote:
> > >>>>Yes, we should add a deprecation one shot printk to the kernel for the
> > >>>>sysfs interface to encourage people to use ip
> > >>>Please don't do that, it won't help for anyone, and especially for the people
> > >>>who didn't hear about "ip" in 2017.
> > >>This is the standard kernel way to encourage people to use the new
> > >>interfaces...
> > >>
> > >>>IPoIB netlink doesn't support enhanced IPoIB device because child
> > >>>device in netlink code was not allocated with rdma_alloc_netdev call
> > >>>as it was done for other flows.
> > >>I don't understand, isn't this just a (bad) bug to be fixed?
> > >Yes and we want to fix it BEFORE adding discouraging warnings.
>
> > We plan to block ipoib_netlink in the meanwhile until we fix it.
>
> That isn't a good idea, don't break APIs for performance reasons..

It is not "performance", but simple attempt to prevent kernel panic,
while calling that function, because I'm unsure if we success to provide
proper fix till merge window.

>
> > The fix is a little tricky since the netdev is allocated in
> > rtnl_newlink and it should be allocated with the new logic
> > introduced in enhanced IPoIB, setting rn_ops, allocating an
> > rdma_netdev if possible.
>
> Should get on it then .. :)
>
> Jason

--bLzFIlwpOfW+4Y/z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnthnQACgkQ5GN7iDZy
WKdUPhAAnGy0YjayK/wL1zpycwhbacyDYGlBHlKeiZaGBQYoOkycj3sS+xqpP+c8
fW3dOpZjK4LqvHvLo7URSwDY2D2Fcelpn2VitFEWshjtzDea+hHI5qzOTlmVEsZ8
5lPwIq8MrHW2eSJFcw2l1yI3vYqBBTN5Bw/37bHqknOyM0EhVwFkVuFEcTQCzYV/
Sv8cr6DLCgRk4aZdL2Pul+r8iKOED9xrOA4cNJLf3YqwkKmxEFRqxTahSgTODYKB
pMUY9qlfo6MIF2R1C96x8ffrqsjuT8J4iSVUS+pfON/z3pNrrLkZntYhhuVkcnEf
aBmRoE7FReUpEwpNe7SuhJ/eAF+KLOWCoVpG71d07IHtTfL02Xg1/AdYr3UxjShz
/bzpd+KILEIEOwXPOZJ7OTDYEDOdGw6wllrXE3yLsA/5ktZ0bivA1dBe9iQq1X3J
rOI86ogsGp+oTbr0+5DndoM5So5faY8Zp1VsIWzSeQRsxMeYNJjOpfPNpW4Xo+fp
in7DwhXmLH/87gNjZQEr9Aor4cTj0plGiaEpSq6wVvcu28+6+0nQjbb6lE7wi08w
tqhYQoELVZ5Zh4wXBwUgJ4pz4iicT5NPnyhWR5kU7r4THv7lWBgUOYX7MfqKWGTd
58nGWIS7A2y2OKZbPFxE9aID5IIEKTtnfhxvZh2z8Qe75gg4IVA=
=RKrk
-----END PGP SIGNATURE-----

--bLzFIlwpOfW+4Y/z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
