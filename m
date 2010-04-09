From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 26/51] IB/qib: Add qib_mr.c
Date: Fri, 9 Apr 2010 12:04:45 -0700
Message-ID: <1270839885.2278.44.camel@chromite.mv.qlogic.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	 <20091203190521.29507.6261.stgit@chromite.mv.qlogic.com>
	 <adapr2b6gqa.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapr2b6gqa.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-04-06 at 21:15 -0700, Roland Dreier wrote:
> > +struct ib_fmr *qib_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
>  > +			     struct ib_fmr_attr *fmr_attr)
> 
> Instead of the crufty old FMR API, I think it would be preferable to
> implement the real IB spec fast registration through a work queue
> stuff.  I understand that it might take some effort to do that but if we
> end up with our newest driver stuck with FMRs, we'll never be able to
> move away from that.

It looks like the IB_WR_FAST_REG_MR operation isn't too hard to
implement so I will add this support.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
