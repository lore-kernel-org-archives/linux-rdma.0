From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 14:52:16 -0700
Message-ID: <adahbmew1gv.fsf@roland-alpha.cisco.com>
References: <alpine.DEB.2.00.1005101607580.17916@router.home>
	<adawrvbxxyd.fsf@roland-alpha.cisco.com>
	<alpine.DEB.2.00.1005110851530.1500@router.home>
	<adawrvawhyc.fsf@roland-alpha.cisco.com>
	<alpine.DEB.2.00.1005111516500.1500@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1005111516500.1500-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org> (Christoph
	Lameter's message of "Tue, 11 May 2010 15:17:36 -0500 (CDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > As I said, I don't think anyone is working on it.  However it wouldn't
 > > be that hard to get something pretty good for multicast, since the
 > > InfiniBand multicast join mechanism would let you have essentially a
 > > perfect filter for steering individual multicast groups to whichever QP
 > > (ring) you wanted to.

 > Right but then would each individual QP need its own IP address?

No, that's the beauty of multicast -- you just join the multicast group
for a given IP address, and you get the traffic.  Doing multiqueue for
unicast traffic would require some form of flow steering (RSS) in the
adapter (which some have).

 > > Of course you could also implement the equivalent thing in userspace and
 > > probably get even better performance.

 > Start a QP listening to IPoIB mc traffic?

Yes, I believe there have have several proprietary userspace libraries
that essentially do UDP IPoIB multicast in userspace.  There are a few
funky hooks in the IPoIB driver related to that IIRC.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
