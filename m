From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Wed, 8 Feb 2017 08:37:58 +0200
Message-ID: <20170208063758.GZ6005@mtr-leonro.local>
References: <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fRV/8oXcwT8XJKzJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207205930.GA28922-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fRV/8oXcwT8XJKzJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 01:59:30PM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2017 at 10:14:28PM +0200, Leon Romanovsky wrote:
>
> > > > Compile the library to build/lib/libibverbs-dv-mlx5.so.1.0.13
> > > > and setup a symlink build/lib/libmlx5-rdmav2.so -> libibverbs-dv-mlx5.so.1.0.13
> > >
> > > Just as a note, I'm calling it libmlx5 and not libibverbs-dv-mlx5.
>
> That will clash with the legacy providers, don't recommend it.

Is it real scenario? Will these legacy providers co-exists with
rdma-core library? I really don't like libibverbs-dv-mlx5 name, it is
too long and have feature name in the name.

>
> > > > For install, use realpath like this:
> > > >
> > > >  execute_process(COMMAND "realpath --relative-to ${VERBS_PROVIDER_DIR} ${CMAKE_INSTALL_LIBDIR}/libmlx5.so.1.0.13" OUTPUT_VARIBALE LINK_PATH)
> > >
> > > It doesn't work for me :(
>
> Ah realpath needs the paths to exist.. Sigha
>
> Another alternative is this:
>
> python -c "import os; print(os.path.relpath('/usr/lib64/libmlx4.so','/usr/lib64/libibverbs'));"

It prints to the screen, but doesn't update OUTPUT_VARAIBLE :(
115  execute_process(COMMAND python -c "import os; print(os.path.relpath('/usr/lib64/libmlx5.so','/usr/lib64/libibverbs'));"
116                 OUTPUT_VARIBALE LINK_PATH)
117   message(STATUS "link_path = ${LINK_PATH}")

..
-- Performing Test HAVE_C_WREDUNDANT_DECLS - Failed
../libmlx5.so
-- link_path =
-- Missing Optional Items:

>
> >   add_custom_target(share_link ALL DEPENDS "${DEST}"  COMMAND ${CMAKE_COMMAND} -E create_symlink "lib${DEST}.so.${VERSION}"
> > 	  "${BUILD_LIB}/lib${DEST}-rdmav2.so")
> >   add_dependencies(share_link ${DEST})
>
> The doesn't need a build time, just do:
>
>     execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
>                  "lib${DEST}.so.${VERSION}"
> 		 "${BUILD_LIB}/lib${DEST}-rdmav2.so")
>
> It creates a dangling link until compilation, which is fine..

In non-ninja builds, it doesn't create libmlx5-rdmav2.so symlink in
build/lib, because libmlx5.so is not created yet. This is why I ended
with custom target.

>
> >   install(FILES "${BUILD_LIB}/lib${DEST}-rdmav2.so" DESTINATION "${CMAKE_INSTALL_LIBDIR}")
>
> This line isn't needed, it is part of the next function

Not for build/lib

>
> >   rdma_install_symlink("${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION}" "${VERBS_PROVIDER_DIR}/libmlx5-rdmav2.so")
>
> Should be
>
>    rdma_install_symlink("${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")a

Thanks for catching this.

>
> And most distros will not allow an absolute link under /usr which is
> why you need to make a relpath work and use that instead of
> ${CMAKE_INSTALL_LIBDIR}

It was my desperate attempt to make it work.

>
> Jason

--fRV/8oXcwT8XJKzJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliavMQACgkQ5GN7iDZy
WKdOZhAAxl7sdjGyfrwCJj+daS45+GLAEwPo9Q6Bmb2+6Hs/5MckPU/I7hyMgY+T
AZTW3x6PDkO+lDoNfL+UWz/4c2HqhqQaSglF9B5xY+LkNvTIs/thp+mxPRdu88l/
okqeBBGgCIqKkf+J4Hf9yFe0SsVVb89urFZYd/9Ii6IVZEtXEW/hYWTWvIiMKOUM
tQuuENGEOCJnGYtpbKusqftt35fEcqCaqAI25rR8M4cbJ0muJAB4awiY9R43RoAH
BQBmWOQwrxJlZ1k/SQfMo30sHYi8XMjjJUpEvswA8RAhGp8fDQVaD2At0wUviLe5
/9l1zGpM0SWFig2u3zT3a7YzQCJdmtABzHsmt9lN8ESWHgap2QyhbLzDjAFCQ3wd
8/QqK4Ao4OCxH4pBk3qoDMgQl2ymgyg+7TpWSxNjghey3H/AZ7z3gSBC4Wr8RV/H
SgsYffxStFKYbVRhoZAiIe42yM3f/1Wmyp9T5N7I77glahMsiZ9oMQNC8YVEgUdM
5/mI+UbxDpdR9itNM3IW38VTlonD1ft1JfLwjcyvnBBDB0FvFvDojl2uTyg4eCYi
fJiPP0fVFI4dn1anH1q2iK4PVwNX9zq7wB7gRHVJUUj32XIxsTc4rokLOyXy+7kt
vlro8F6cK7wAJmMikGmfBN+366iurCwssbKRQeL4novjvYpGxsA=
=S7mY
-----END PGP SIGNATURE-----

--fRV/8oXcwT8XJKzJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
