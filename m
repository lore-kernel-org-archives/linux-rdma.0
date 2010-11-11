From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband: core: fix information leak to userland
Date: Wed, 10 Nov 2010 16:01:08 -0800
Message-ID: <ada39r8ohiz.fsf@cisco.com>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289054481-18145-1-git-send-email-segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Vasiliy
	Kulikov's message of "Sat, 6 Nov 2010 17:41:20 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Kulikov <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Structure ib_uverbs_qp_attr is copied to userland with allmost all
 > fields uninitialized (140 bytes on x86).  It leads to leaking of
 > contents of kernel stack memory.

I don't think most of the fields are uninitialized... we have:

 	memset(&qp_attr, 0, sizeof qp_attr);

and then later on,

	ib_copy_qp_attr_to_user(&resp, &qp_attr);

which actually does initialize almost all of the fields in resp.  The
things that are missing are clearing out the reserved fields in the
structures, and also resp.qp_state never gets set.

I would suggest adding code to clear the reserved fields of structures
to ib_copy_qp_attr_to_user() and ib_copy_ah_attr_to_user(), since this
will fix what looks to be the same problem in ucma_init_qp_attr() (in
drivers/infiniband/core/ucma.c).

Sean, what is intended for qp_state handling here?  It seems
ib_copy_qp_attr_to_user() should either clear it or set it to something
sensible.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
