From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 26/51] IB/qib: Add qib_mr.c
Date: Tue, 06 Apr 2010 21:15:09 -0700
Message-ID: <adapr2b6gqa.fsf@roland-alpha.cisco.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190521.29507.6261.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203190521.29507.6261.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 03 Dec 2009 11:05:21 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
 > +			     struct ib_fmr_attr *fmr_attr)

Instead of the crufty old FMR API, I think it would be preferable to
implement the real IB spec fast registration through a work queue
stuff.  I understand that it might take some effort to do that but if we
end up with our newest driver stuck with FMRs, we'll never be able to
move away from that.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
