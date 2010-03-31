From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 13/51] IB/qib: Add qib_driver.c
Date: Wed, 31 Mar 2010 16:23:33 -0700
Message-ID: <ada4ojn43mm.fsf@roland-alpha.cisco.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190413.29507.17962.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +DEFINE_MUTEX(qib_mutex);	/* general driver use */

Rather than having this ill-defined mutex that I think is going to make
it hard to understand the locking and get the lock ordering right, would
it be better to have well-defined locking rules?  AFAICT this mutex is
used in only two places, qib_diag.c and qib_file_op.c.  Are those two
uses protecting the same thing?  Or could we have two static mutexes,
one in each file, that protects what each file needs protected?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
