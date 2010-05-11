From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 08:56:11 -0700
Message-ID: <adawrvawhyc.fsf@roland-alpha.cisco.com>
References: <alpine.DEB.2.00.1005101607580.17916@router.home>
	<adawrvbxxyd.fsf@roland-alpha.cisco.com>
	<alpine.DEB.2.00.1005110851530.1500@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1005110851530.1500-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org> (Christoph
	Lameter's message of "Tue, 11 May 2010 08:53:38 -0500 (CDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > I am mostly interested in multicast traffic. Connected mode is not
 > relevant to that usage scenario.

As I said, I don't think anyone is working on it.  However it wouldn't
be that hard to get something pretty good for multicast, since the
InfiniBand multicast join mechanism would let you have essentially a
perfect filter for steering individual multicast groups to whichever QP
(ring) you wanted to.

Of course you could also implement the equivalent thing in userspace and
probably get even better performance.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
