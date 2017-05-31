From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 31 May 2017 07:04:37 +0300
Message-ID: <20170531040437.GE5406@mtr-leonro.local>
References: <20170529082423.1180-1-leon@kernel.org>
 <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530212431.GA21008-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 04:24:31PM -0500, Shiraz Saleem wrote:
> On Mon, May 29, 2017 at 11:24:23AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
> >
> > The commit cea05eadded0 ("IB/core: Add flow control to the portmapper netlink calls")
> > changed netlink to be blocked for all RDMA clients. This workaround
> > worked perfectly for portmapper, but is not correct for the whole
> > NETLINK_RDMA family.
> >
> > The request/response should always be blocking and asynchronous
> > notification should always be non-blocking.
> >
> > It is library and user-space application to chose how to handle recvmgs,
> > as an example see nl_recvmsgs() and nl_socket_set_nonblocking() calls of
> > libnl library.
> >
> > Send timeout is not needed too and can be configured with SO_SNDTIMEO socket
> > option.
> >
> > This reverts commit cea05eadded0d4eb59f7be6e1f1560eb6bfde2bf.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> This commit was accepted with much feedback from you.
>
> https://patchwork.kernel.org/patch/9235137/
>
> Not clear from your description to determine what your trying to fix.
>
> Simply reverting a commit that solves a real problem is not acceptable.
>
> Please come up with a solution without breaking portmapper.

1. It was cosmetic comments, I didn't give my reviewed-by tag, so please
don't put blame on me,
2. The commit cea05eadde broke NETLINK semantics for whole RDMA.
3. The commit cea05eadde made libnl library (basic block of user-space part of netlink)
to work incorrectly and not according to _blocking/_nonblocking semantics.
4. Reverting is a common practice in Linux kernel. Patches are not
carved in stones.
5. I proposed a solution -> go and fix your user space program.

Thanks
>
> Shiraz

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkuQNUACgkQ5GN7iDZy
WKf/wQ/5AUQ87xgD6ov25fYuQzfOgOpxpzK05kDRFJaPNYHuErLE4H9mNlrtTHQY
TsmRjr+QGGNnTXjFNr7F9jByeLuI9oYcKTz6uwpTAyxlhp1GjEoCt0qSR7at+suq
R6Cg8ZZ/70ElTMdmg4afsDEXlLzPbU5A503xXD5eA3rfDgyV7Eq45j0n8SYbrcf4
M30Fo82sfOtR8TpUZVY7KM37tBoBddF4P+t/ms3dLNoFpm+2+RDT25CcXd65/RZf
BlVxDNu/wC4638erpfa6UC9KiA09X1u4enboVJOyktiw+FAugx6Rper2adb6gs0i
gMiRHLonO6/6nvaXvSfKqFiNJxCcPkwG34YpIscuzF0t8BFUu5AO4roM+wQ8+Ul1
987r/FT1NSeiR1k/i9Ou3I1EeiEh7qK2TPyPqdlupHzoN8zQFpLwMJ0vu/5DFPqr
Bygi3VHbB093Ia3iOpkjN5pHPrkbp/ccaMRzh5trD3QXQKwsAGmzzNg0jDe9et36
rSlU/iW/cqP9DUzc5X/q9rzlMi4G+7V7r94Scr1BLWBj8JqnKEaD9l1jrXiVIwJk
YwWCzjnCvkeyYJCjyTjK658je0NcIYvdE8mc6CLq5Rq4KSKt/dkTsQ8+JgkcYmoF
i3ZSPPWUnuRRkw6EyR5XjmG4B4yBANoPwX23aAXHxOMtxhHBNwA=
=RRHl
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
