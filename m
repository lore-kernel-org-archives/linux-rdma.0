From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 09:38:34 +0300
Message-ID: <20160505063834.GH29160@leon.nu>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
 <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
 <20160504181509.GA20488@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o71xDhNo7p97+qVi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504181509.GA20488-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--o71xDhNo7p97+qVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2016 at 12:15:09PM -0600, Jason Gunthorpe wrote:
> On Wed, May 04, 2016 at 08:36:21AM -0400, Dennis Dalessandro wrote:
> > I think it's slightly more complicated than that. There are three optio=
ns
> > really: core, driver, or get it out of the kernel.
>=20
> From a core maintenance perspective, I think it is very simple, if
> someone wishes to add code to their driver to manipulate the EEPROM,
> then at this point the work to make a common uAPI falls on to their
> shoulders.

Agree,
And before rushing to code this functionality, please double check that
there is no already implemented such similar common functionality in other
subsystems.

I bet that you already did it.

>=20
> I'd also make a very clear message to driver submitters: Do not
> include uAPIs in your initial driver patch set. Those should follow on
> as dedicated well identified patches so that they attracted the proper
> review.

It is hard to agree with this point.
It contradicts to development model of submitting whole feature at once
and not unconnected piece of code, which someone will be needed to
maintain without any real user behind it.

>=20
> Jason

--o71xDhNo7p97+qVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKupqAAoJEORje4g2clinplcP/38gY70RlTl7emETfu5xX5Zu
X6+Eg7fAhzgwrg0ZuqHjpOgPxBw49sZDZm762KypwSS9zAf4ih8VcijLbtYRVzXv
nDQ5DDikFQI+LFbSJKQ2PfhFO+B2M1WqVk7kQusdStqfcxkAmnZQ/oN78kqaOaMm
hHScIXFgAPudPtJGMvNgAn/QE5sdddcMr715a1afZuXtXj2YfaMlAg03iFK77KRb
OsqOxn5euEnsaxJdymsNE0uEeg3R1GdxX/AquvwNbAeEVFRBv9naHncxcOO2UVkl
m2NLynwrZMF5/f+6tCiYCWPmdqKyI64zJPIIuM6X8otGgIQPFhMy1/oLn6i/y+FZ
1ww94vJ1BZUwEuxNbQIkZy8eA1L4KBiN3onr8DFv0tM9VigkcQauBDLIK1i0Kg3k
Ecy8N5QVpS2RZj6GKTK3zK1DvvQGtnMpLNAh3MQN/bQYdhGhz9ZRohKQKTFbUjST
8ofqzIQn/D1VGsVhDB12T0q2bp7N9+Ybpf30FZNB/mqv9AYVtZmdKQ8wSmCjlSow
7SEwMIIuDIrZ8ufzi6B/Tr59FzFdx1qHE22Fbkw65wuLx5MFKfxqpNWDrnPY+c8s
DD84821Ez/y7mHtaTYypAlhCN+2r0Nwz5B/QCSd4K5C1oCtGf9Y1ONLinrRPH/lM
bdoIrErqSC48DRyVCKIr
=5lvP
-----END PGP SIGNATURE-----

--o71xDhNo7p97+qVi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
