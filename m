From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/53] IB/qib: add
Date: Mon, 23 Nov 2009 19:52:29 -0800
Message-ID: <adar5ro37gi.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233655.30356.57433.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 19 Nov 2009 15:36:56 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So I tried actually building this, and CONFIG_INFINIBAND_IPATH=y +
CONFIG_INFINIBAND_QIB=y ends up with:

    drivers/infiniband/hw/qib/built-in.o: In function `signal_ib_event':
    drivers/infiniband/hw/qib/qib_intr.c:72: multiple definition of `signal_ib_event'
    drivers/infiniband/hw/ipath/built-in.o:drivers/infiniband/hw/ipath/ipath_intr.c:248: first defined here
    drivers/infiniband/hw/qib/built-in.o: In function `teardown_sdma':
    drivers/infiniband/hw/qib/qib_sdma.c:475: multiple definition of `teardown_sdma'
    drivers/infiniband/hw/ipath/built-in.o:drivers/infiniband/hw/ipath/ipath_sdma.c:508: first defined here

etc.

I think it's a good idea to prefix any symbols with non-static scope
with the driver name, so these should become qib_xxx to avoid conflicts
(and fixing the too-generic names in ipath wouldn't hurt either).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
