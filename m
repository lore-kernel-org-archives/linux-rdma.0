From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Make the provider facing libibverbs interface
 private
Date: Mon, 30 Jan 2017 22:30:11 +0200
Message-ID: <20170130203011.GN6005@mtr-leonro.local>
References: <20170126230813.GA7149@obsidianresearch.com>
 <20170130135959.GL6005@mtr-leonro.local>
 <20170130170341.GB29502@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ljn2+zwPkKedfiv/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170130170341.GB29502-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ljn2+zwPkKedfiv/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2017 at 10:03:41AM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 30, 2017 at 03:59:59PM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 26, 2017 at 04:08:13PM -0700, Jason Gunthorpe wrote:
> > > The first part is to remove the header files that define the
> > > prototypes for these symbols from the set of packaged headers.
> > > This ensures that nothing can compile and use these symbols.
> > >
> > > Next we move the symbols into a new symbol version stanza only
> > > for the private ABI. This breaks every existing out of-tree provider,
> > > but the earlier change to ibv_cmd_create_ah already did that.
> > >
> > > There are a few symbols that are still private by virtue of not being
> > > in public headers, but these are used internally by the other libraries.
> > > For distribution sanity continue to treat them as public ABI.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >  Documentation/versioning.md   |  22 ++++++++
> > >  debian/control                |   2 +-
> > >  debian/libibverbs-dev.install |   3 --
> > >  debian/libibverbs1.symbols    |  44 +--------------
> > >  libibverbs/CMakeLists.txt     |   9 ++--
> > >  libibverbs/libibverbs.map     | 122 +++++++++++++++++++++---------------------
> > >  6 files changed, 93 insertions(+), 109 deletions(-)
> >
> > How is it connected to ABI soname versioning?
> > https://github.com/linux-rdma/rdma-core/blob/master/Documentation/versioning.md
>
> Not sure I follow..
>
> Those guidelines continue to apply to the public symbols.
>
> > libibverbs.map's ABI version was 1.4 before and it was synced with
> > CmakeList, but now, it won't.
>
> The map file will have two sections now, one for public symbols that
> will continue to use the 1.3/1.4/etc system

But you removed IBVERBS_1.4. Do we introduce IBVERBS_1.4 again?

> (Ah, Yishai forgot to update CMakeLists when he added the 1.4 symbols,

Yeah, I spotted it too while reviewed your patch and worked on direct
verbs improvements.

> oops, we need a travis check for this I guess..)
>
> The other is the private symbol section that basically just tracks the
> release number. There will only ever be one PRIVATE section since we
> don't provide compat. We do not attempt to reflect the PRIVATE symbols
> in the filename.

I understand rationale behind this and agree with you regarding the
change.

>
> The file name will continue to be 1.3.${PACKAGE_VERSION} but it is
> largely irrelevant..

It is better to keep in sync these numbers in CmakeLists and map file.

>
> Jason

--ljn2+zwPkKedfiv/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliPolIACgkQ5GN7iDZy
WKcozA/+MVH8GGs95LLQv2kRxj2trc6FB6oeS6+1JKCQ27tL1GvgkG8WzFSSL1GM
TJG8uEJPJ3hKp4JeyfXXb8it6FqFLgGMFELh4ypG5PrrMbQaqIeuPBsFgn/iAPHb
ApF7GKlwDuVL3jdsY6df5NWVy7Dw0D0g0e6cd6jSA/nNouf0A135/X4CsQISVQxw
eA1PTZ4koVT6tcP0jAJgJiomK6ypyazIZwCoVx8K356qC7XRZn/w3UMNpthNMPK4
fCzFGMt+MKSvrfWiz6XHqdDhb/AFhZCnDqd7FjYWdDlmrbnJPMssCS7flc73kUvw
0rpiU17JyJjUEKVoMdV7jjaWonalF2jVHD93bs//78lefs0SdvezQKaa84ja/FBP
t6jXWU4TK47YmKvxb2IClSlV21krF7l6sf4ueDlCoVG5tshuXMLfNbyoDaUXHSYg
relteR8ecoS8i5/2puOsRBbTtqzKOBm+cSDpGHjbK1XcBXp5jj9EQOkechKvihch
0axmY9PPs1IsMw9yE37xJGYOB9KcGoffg3yRsNf/xiCNHgWHNhRoscb8USMj7t6C
fb/9LNWIDHNi0GFq2pmlGKxcSBB6rUhLPIvqaTWQRdRxGnZbJEjPgVLY2wijMD6Y
+x52Ldb8mgk1hudOarele1pN3SK19pTRfGTLMZqyBxvIuJKvjVw=
=TInS
-----END PGP SIGNATURE-----

--ljn2+zwPkKedfiv/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
