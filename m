From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Optimized path for kernel post_send/post_recv
Date: Thu, 24 Mar 2011 12:56:23 -0700
Message-ID: <AANLkTikUBm8VD3y6amAAmGCAeQRa=Y2AvtpwsYB0j-3m@mail.gmail.com>
References: <20110324123937.19461.56781.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110324123937.19461.56781.stgit-dAdtdUp2yJRU7keBU/FxOFDQ4js95KgL@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Overall, looks pretty sane and non-intrusive.  I would like to see
patches for at least one driver using it before we merge this.

> + =A0 =A0 =A0 if (file->ucontext->use_shpage_for_rxtx) {

Why do we attach this flag to the entire ucontext rather than
an individual QP?  It seems more awkward to require two
contexts if a process wants to use both bypass and non-bypass QPs.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
