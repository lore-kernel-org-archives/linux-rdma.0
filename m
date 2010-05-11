From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 08:53:38 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1005110851530.1500@router.home>
References: <alpine.DEB.2.00.1005101607580.17916@router.home> <adawrvbxxyd.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adawrvbxxyd.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 10 May 2010, Roland Dreier wrote:

>  > Is there any work on multiqueue support for IPoIB going on?
>
> No, although one could view connected mode as an even better place to
> start, since you already get perfect classification by remote peer for
> free.

I am mostly interested in multicast traffic. Connected mode is not
relevant to that usage scenario.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
