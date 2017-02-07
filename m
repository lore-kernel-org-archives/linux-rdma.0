From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 13:59:30 -0700
Message-ID: <20170207205930.GA28922@obsidianresearch.com>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
 <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
 <20170207183538.GT6005@mtr-leonro.local>
 <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207201428.GV6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 07, 2017 at 10:14:28PM +0200, Leon Romanovsky wrote:

> > > Compile the library to build/lib/libibverbs-dv-mlx5.so.1.0.13
> > > and setup a symlink build/lib/libmlx5-rdmav2.so -> libibverbs-dv-mlx5.so.1.0.13
> >
> > Just as a note, I'm calling it libmlx5 and not libibverbs-dv-mlx5.

That will clash with the legacy providers, don't recommend it.

> > > For install, use realpath like this:
> > >
> > >  execute_process(COMMAND "realpath --relative-to ${VERBS_PROVIDER_DIR} ${CMAKE_INSTALL_LIBDIR}/libmlx5.so.1.0.13" OUTPUT_VARIBALE LINK_PATH)
> >
> > It doesn't work for me :(

Ah realpath needs the paths to exist.. Sigh

Another alternative is this:

python -c "import os; print(os.path.relpath('/usr/lib64/libmlx4.so','/usr/lib64/libibverbs'));"

>   add_custom_target(share_link ALL DEPENDS "${DEST}"  COMMAND ${CMAKE_COMMAND} -E create_symlink "lib${DEST}.so.${VERSION}"
> 	  "${BUILD_LIB}/lib${DEST}-rdmav2.so")
>   add_dependencies(share_link ${DEST})

The doesn't need a build time, just do:

    execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
                 "lib${DEST}.so.${VERSION}"
		 "${BUILD_LIB}/lib${DEST}-rdmav2.so")

It creates a dangling link until compilation, which is fine..
 
>   install(FILES "${BUILD_LIB}/lib${DEST}-rdmav2.so" DESTINATION "${CMAKE_INSTALL_LIBDIR}")

This line isn't needed, it is part of the next function

>   rdma_install_symlink("${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION}" "${VERBS_PROVIDER_DIR}/libmlx5-rdmav2.so")

Should be

   rdma_install_symlink("${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so.${VERSION}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")

And most distros will not allow an absolute link under /usr which is
why you need to make a relpath work and use that instead of
${CMAKE_INSTALL_LIBDIR}

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
