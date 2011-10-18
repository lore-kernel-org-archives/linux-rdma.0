From: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Tue, 18 Oct 2011 10:14:49 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1110181013090.687@router.home>
References: <alpine.DEB.2.00.1110140852210.6411@router.home> <CAJZOPZJVNiwU-YA6KteOoFYX5M=BzPEZJsvRoFOz170O11qgeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJVNiwU-YA6KteOoFYX5M=BzPEZJsvRoFOz170O11qgeA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 17 Oct 2011, Or Gerlitz wrote:

> Could you try that again with small msg size e.g use "-s 100", if that
> doesn't help
> can you send the output of "ibv_devinfo" from both nodes. Also please
> specify the exact top commit of the two libraries (libibverbs and I
> assume libmlx4 if you use Mellanox ConnectX) in case you built them
> from the git trees, or the library version if you're using official
> release, thanks,

-s 100 fixes the issue.

The one side has OFED 1.5.3.1 kernel modules and libraries from the same
tarball.

The kernel ib side has

Libibverbs_git from a mirror of kernel.org

commit d0ebae72223298d6dbd7a2e2c812c529bf4d4a1d
Author: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Date:   Sun Aug 7 18:01:48 2011 +0000

    Makefile.am: Fix an automake warning

    Fix the following automake warning message:

        Makefile.am:1: `INCLUDES' is the old name for `AM_CPPFLAGS' (or `*_CPPFLAGS')

    A quote from the automake manual:

        INCLUDES
            This does the same job as AM_CPPFLAGS (or any per-target _CPPFLAGS variable
            if it is used). It is an older name for the same functionality. This
            variable is deprecated; we suggest using AM_CPPFLAGS and er-target
            _CPPFLAGS instead.

    Signed-off-by: Bart Van Assche bvanassche-HInyCGIudOg@public.gmane.org

Mlx4_git from the same place.

commit 60dade7a5e97da3b2eedf5839169c044f67577b3
Author: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Date:   Thu Aug 11 09:35:20 2011 -0700

    Add "foreign" option to AM_INIT_AUTOMAKE

    Switch to the modern form of the AM_INIT_AUTOMAKE macro and tell
    automake that the libmlx4 package does not follow the GNU standards.
    This change makes it possible to use 'autoreconf' for libmlx4.

    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
