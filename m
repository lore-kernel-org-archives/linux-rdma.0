From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 11:18:14 -0700
Message-ID: <20170207181814.GA13368@obsidianresearch.com>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
 <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207180642.GQ6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 07, 2017 at 08:06:42PM +0200, Leon Romanovsky wrote:
> On Tue, Feb 07, 2017 at 10:27:52AM -0700, Jason Gunthorpe wrote:
> > On Tue, Feb 07, 2017 at 11:19:59AM -0600, Steve Wise wrote:
> > > >
> > > > Hm, possibly yes. ibverbs first checks the new location, if the
> > > > provider is not there then it will fall back to a naked dlopen which
> > > > could find providers in the system library path if there was a .driver
> > > > file for it.
> > >
> > > Hmm, so it will load the provider libraries directly specifying the
> > > full path?  IE 'ldconfig -p' doesn't matter?
> >
> > As the first try, yes. That is the usual way to locate
> > plugins. Typically you don't want the system linker searching plugin
> > directories.
> 
> Jason,
> I have a slightly different question, but it is still in context of
> plugins and linkers.
> 
> In v0 of DV, you asked from us to create normal shared library for mlx5,
> e.g. libmlx5.so. In order to be visible to "gcc -lmlx5"i command, it should be
> placed in the same directory as libibverbs.so, while plugins should be placed
> in libibverbs folder.
> 
> I did it by using symlinks
> $l /usr/lib64/libibverbs
> lrwxrwxrwx    1 root root   10 Feb  7 18:09 libmlx5-rdmav2.so -> ../libmlx5.so
> $l /usr/lib64 | grep mlx5
> lrwxrwxrwx    1 root root   12 Feb  7 18:09 libmlx5.so -> libmlx5.so.1
> lrwxrwxrwx    1 root root   17 Feb  7 18:09 libmlx5.so.1 -> libmlx5.so.1.0.13
> 
> It works, but I don't know if it is right approach from distro/packaging
> perspective. Is it ok?

I think this is basically OK. The symlink should point to the real
file (libmlx5.so.1.0.13) though.

Also, make sure that cmake computes the .. properly, something like

execute_process("realpath --relative-to ${VERBS_PROVIDER_DIR} ${CMAKE_INSTALL_LIBDIR}/libmlx5.so.1.0.13" OUTPUT_VARIBALE LINK_PATH)

You'll want to create a new rdma_dv_provider function to handle all of
this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
