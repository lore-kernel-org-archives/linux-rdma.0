From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 15:17:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1005111516500.1500@router.home>
References: <alpine.DEB.2.00.1005101607580.17916@router.home> <adawrvbxxyd.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005110851530.1500@router.home> <adawrvawhyc.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adawrvawhyc.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 11 May 2010, Roland Dreier wrote:

>  > I am mostly interested in multicast traffic. Connected mode is not
>  > relevant to that usage scenario.
>
> As I said, I don't think anyone is working on it.  However it wouldn't
> be that hard to get something pretty good for multicast, since the
> InfiniBand multicast join mechanism would let you have essentially a
> perfect filter for steering individual multicast groups to whichever QP
> (ring) you wanted to.

Right but then would each individual QP need its own IP address?

> Of course you could also implement the equivalent thing in userspace and
> probably get even better performance.

Start a QP listening to IPoIB mc traffic?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
