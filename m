From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Mon, 10 May 2010 14:12:58 -0700
Message-ID: <adawrvbxxyd.fsf@roland-alpha.cisco.com>
References: <alpine.DEB.2.00.1005101607580.17916@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1005101607580.17916-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org> (Christoph
	Lameter's message of "Mon, 10 May 2010 16:08:53 -0500 (CDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Is there any work on multiqueue support for IPoIB going on?

No, although one could view connected mode as an even better place to
start, since you already get perfect classification by remote peer for
free.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
