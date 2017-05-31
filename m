From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 31 May 2017 21:20:50 +0300
Message-ID: <20170531182050.GL5406@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
 <20170531040437.GE5406@mtr-leonro.local>
 <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
 <03c501d2da35$d10a22f0$731e68d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z9sQuz+HmDh2hVO4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03c501d2da35$d10a22f0$731e68d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Shiraz Saleem' <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Mustafa Ismail' <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--z9sQuz+HmDh2hVO4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 31, 2017 at 12:46:22PM -0500, Steve Wise wrote:
> >
> > > 4. Reverting is a common practice in Linux kernel. Patches are not
> > > carved in stones.
> >
> > Reverting a patch that's introduced during RC cycle is fine, introducing
> > regression is NOT and that is what you are doing by simply proposing to revert
> > this patch.  Reverting this patch will introduce a REGRESSION error with
> respect to
> > port mapping functionality for all iWARP vendors.
> >
> > > 5. I proposed a solution -> go and fix your user space program.
> > This is a kernel patch you are trying to revert, you are breaking existing
> > kernel functionality.  Nothing to do with user space.
> >
> > Bottom line, come up with a solution that will address both port mapper
> > functionality and your issue.
>
> Hey Leon,
>
> I would hate to introduce an iwarp regression vs solving your issue w/o
> reverting.  If I recall, the flow control is need so as to not drop messages
> flowing from the kernel to the iwpmd.  I'm not sure how that could be fixed in
> the user daemon?

Assume that netlink is unreliable and set socket timeout.

Thanks

>
> Steve.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--z9sQuz+HmDh2hVO4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkvCYIACgkQ5GN7iDZy
WKfaUQ//espWy2WtDpV4pR2kqKaW0NOb2bkOHO7C8bP+2jh7eB0MRa3pF9rGfMr5
DfQ+IWOoNuhvWWl3Oe0sHSp05pRyxveMBnBJUh3SxBmw5o+7CgJFnixeTXOgpbFy
L41Yek/4iREXvMY64Ddpz0fr33t9x0ZoYN8A6OxKNZpTAVSFgRYtK2uQkXQulUFc
znrcEWfE90eX32YueNgE6V89WJQr1KE2KcTrglvCTMjsB/FWiFtqGc29wFbv4fVt
uuu83PfDlFwqX1elrK1A11Q4jCKc1xQpL28GkMipwUe5FFaLaQyHsJFKPr+lsESf
VI2LZo1RQDG+oMa/putHR+vvGwk+GhM0xhGvrg0mq2dwtOjISt81CcasBMw1m64d
uYmAgFSnnNQDTqrT/Shbnr79GzmbxTZ+D6dk7alOKYsw9gUUIoI0NLaGOUxCSnRP
cIwUTa/GQZFWEtrFdQ+nbQ7WJQQVvHoWT2AHFPD460RRu/D/88bL+m/5onrWrHTE
RIsT4ZQqDCpBb4PLYRxxYoFKvF4RF2OsVEQhZccVHJa2Yc+pGzdhBKufptdNyObz
cPzTRQRXhX71dE7D4Ry31Y9WIpmqavTygedqoLgupH2haqSRkM7rlm0nQT0nzQ75
fuXqVUIUU9jzgw+vSEq9h2f6dRFn2FUxB5DXiWSKJNFzChZtavQ=
=v2l7
-----END PGP SIGNATURE-----

--z9sQuz+HmDh2hVO4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
