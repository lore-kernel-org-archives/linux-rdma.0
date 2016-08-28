From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Sun, 28 Aug 2016 21:35:00 +0300
Message-ID: <20160828183500.GQ594@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828171758.GA11719@obsidianresearch.com>
 <20160828182613.GP594@leon.nu>
 <20160828182813.GB12783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ngPZezdD7QsvFaqQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828182813.GB12783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ngPZezdD7QsvFaqQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 28, 2016 at 12:28:13PM -0600, Jason Gunthorpe wrote:
> On Sun, Aug 28, 2016 at 09:26:13PM +0300, Leon Romanovsky wrote:
> > On Sun, Aug 28, 2016 at 11:17:58AM -0600, Jason Gunthorpe wrote:
> > > On Sun, Aug 28, 2016 at 10:58:32AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > By Mellanox HW design and SW implementation poll_cq never
> > > > fails and returns errors, so all these prints are to catch ULP bugs.
> > >
> > > Eh? How can a ULP cause poll_cq to get errors?
> > >
> > > Are you sure these are not driver bugs?
> > >
> > > Why can't you just print and discard the broken CQ entry?
> > >
> > > What should use ULP do when it get EINVAL? You say poll again is
> > > not correct, so you suggest a full QP tear down?
> >
> > See patches 4 and 6, they completely removed these EINVALs.
>
> So the commit message is still wrong.
>
> Why do we need this revert? Just squash it and mark it fixup the
> original.

We need this revert, because the original commit is wrong and as was presented
by Sasha Levin in his talk about automatic creation of stable trees [1], he needs
this information to ensure that this commit won't be in stable tree by mistake.

[1]
https://lcccna2016.sched.org/event/7JW4/automating-the-creation-of-stable-trees-sasha-levin-verizon-labs

>
> Jason

--ngPZezdD7QsvFaqQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwy7UAAoJEORje4g2clinOLwP/RDfXJSEFgV5ejxivS8CZWhT
3lFtm9Ejd7YAtD576wupTyW2sfbWuyWrJ0rzoxrqkt6kr8kAv+USZKwbq8rMGXyw
Vl040q4nWXNsACw6/nmyFTH7Riu435jonnkaSSz2tjX2b8Y7BKEVjf3BCNGkg4MC
TmzWGd2wf4zJE4/4g1IVfLNbH4aIll7PaaB36kb+Aeu4/YEOBXJqTPNOT9irMvy4
Fh7u2zTCphkTbohay6c/0rei233uJk/5n3WmZqS4bth3w2yvpJShw/7tvFTTbKgz
gMWUhF0VWdbpaKUwVT88sy9wxVooo8JA+I7SOfvUC/nWVGaONHl3oBAhg/oll6GG
P+jAkMmIbiJgV5pDt+WupiMerg0nMbW2Qr7YFI6ICN3HEs/BfjiAKj5xt0GbRQ4J
K+zBX+V/VVP3PYOy+VpXrtC2/BfgGSbExPs0O2iW0wrzn/bQUxRLDHLih8EDN7Qu
jVgvME8Z82BzJ+2m+XBmvq9FmgbaZb6bP+HXmjHj//i7FA78uhruz9utB2W78Ea8
gYc9h1+EHxHfCkSJAzRPjtgOe+O+vJdJBpnDtxn58A3n/aHKDJIskmBAXVACsgOn
deCdOaLP3eydxyTjfWdgz3KXtt6Eob/N8iad/aNkfFBTnPyyyJZMtDGdQdVOf0XT
TpfhCc1tnkgW5ZeWPUvh
=Y/gl
-----END PGP SIGNATURE-----

--ngPZezdD7QsvFaqQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
