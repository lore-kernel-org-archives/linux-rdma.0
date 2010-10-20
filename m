From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: What is the best way to time RDMA over IB code segments?
Date: Wed, 20 Oct 2010 09:08:35 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1010200908150.23605@router.home>
References: <20101019090650.afxa4dwis40sgssw@peddycoart.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101019090650.afxa4dwis40sgssw-6c4oY0qWgKW61VtY7fu8aA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Oct 2010, ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org wrote:

> What is the best way to time RDMA over IB code segments?  Are there timers
> included in the RDMA libs?

The kernel has a clock? And some cpus have fancy timer registers.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
