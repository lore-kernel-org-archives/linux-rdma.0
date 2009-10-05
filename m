From: Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [ANNOUNCE] libcxgb3 1.2.5 released
Date: Mon, 5 Oct 2009 18:31:15 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0910051830400.30237@gentwo.org>
References: <4ACA68C0.8030301@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ACA68C0.8030301-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If it just would support multicasting... Sigh.

On Mon, 5 Oct 2009, Steve Wise wrote:

> Sorry for yet another libcxgb3 so soon, but:
>
> The libcxgb3 package is a userspace driver for Chelsio T3 iWARP RNICs.   It is
> a plug-in module for libibverbs that allows programs to use Chelsio RDMA
> hardware directly from userspace.
>
> A new release, libcxgb3-1.2.5, is available from
>
> http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.2.5.tar.gz
>
> with md5sum
>
> ed2eaf99bc7cce401dd0549505febdd1 libcxgb3-1.2.5.tar.gz
>
> This minor release fixes a bug where the qp wasn't being correctly RESET
> causing dapltest failures.
>
>
> Vlad: Please pull this into ofed-1.5 before RC1.
>
>
> Thanks,
>
>
> Steve.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
