From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] srp_daemon: handle SM lid change
Date: Tue, 19 Dec 2017 07:46:47 +0200
Message-ID: <20171219054647.GI18894@mtr-leonro.local>
References: <dba1097c-8ab9-7086-a976-46e6d3c4a165@suse.com>
 <0ca80873-0eb0-9c64-f813-dee94b82eea6@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YrlhzR9YrZtruaFS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0ca80873-0eb0-9c64-f813-dee94b82eea6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YrlhzR9YrZtruaFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 13, 2017 at 06:32:30AM -0500, Dennis Dalessandro wrote:
> On 12/12/2017 9:08 AM, Nicolas Morey-Chaisemartin wrote:
> > When srp_daemon was running and the master SM host changes,
> >   srp_daemon output these errors at every scan:
> > srp_daemon[25394]: No response to inform info registration
> > srp_daemon[25394]: Fail to register to traps, maybe there is no opensm
> >   running on fabric or IB port is down
> >
> > This was introduced by commit 4952e5f Fix a memory leak.
> > A side effect of this patch was that create_ah was only called when the
> >   port lid changes. Which meant register_to_traps used an older, obsolete,
> >   version of sm_lid and failed to connect to it.
> >
> > This patch fixes this behaviour by checking for both local lid changes and
> >   SM lid changes, and calling create_ah on any of these events.
> >
> > Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> > Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v14, v15, v16

There is no need to mention all versions, it is enough to write first one.

Thanks

--YrlhzR9YrZtruaFS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo4p8cACgkQ5GN7iDZy
WKflsQ/+IAirL3lgxlJPxEI1QypX+3vy6zUbfHWj52uh8l2esDOuteYBPdtob/Xh
bWio0HPEaPWk2H9rh2RhUGA4N4r2ZtJyGi8Km/EKSehiVRsCUQxCLMHCwsA/5CAm
QxLgrrhZoiOAEhCx0tPbCQBq6wCDBP5gbLgq1QanQVa9BXONMTJ/B1TuINugSAPL
NeY1PrD9ifPOqHWUryjLq+eplP/akNXRB4E5I8YvqVx5CuYLaw5VOduIW57ZadUm
uOJHeqwyYKyhhf7iv58ObKS3fyW0nK1HeKJRMuqcYv7OguqsE1d+2VccRAC956hy
4sdCFs/P91cQj0ew3/g5BDKFGktydR1hp4EoIWVcq++GA+GSQk4b1+dpmkRTkc1c
Cj52UUQjowGo6RgL0NUrsW6rFifpHTqXBl1etAm4Cat671P0MtYVZCBK+Dl4+oeF
Kmk3uyUVZX8Vr945xaNgK9exj4Dbaq7Zf8I0k3WZO/M3bRJljtakCv7p21PKh0cP
gG6h/5ZjqGrIEpgs/h/2VyKR1R/gUBRsB0/lzMCrXpUCpc4AHoits3NWNd1s4mmC
WDQu40f7tc/qjvTePbyNYF0cpcLhgWOCJghqs9QnMvHzfMKeDQJeLfpZu7AZLvJz
d1iYsuKQxaRVeKWTJYwbTLNS0skVHYSbTtLyTdqWO4E4cuBtAYk=
=0i52
-----END PGP SIGNATURE-----

--YrlhzR9YrZtruaFS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
