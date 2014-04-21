From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Mon, 21 Apr 2014 23:44:41 +0300
Message-ID: <CAJZOPZJfdaZ7QzgffzY9Ps-1aUCU+q_dSrj4XfekyfxNa-k+hg@mail.gmail.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1404211308140.29240-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 21, 2014 at 9:09 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> We need this option for many hosts to avoid backflow of multicast
> packages. Could we get that merged?
[...]

> Currently, there's no way for user-space applications to specify
> the IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK QP creation flags
> defined by commit 47ee1b9 "IB/core: Add support for multicast loopback blocking".
> As a result, applications who send and recieve on the same QP over
> the same multicast group get all their packets bouncded back to them,
> which is bad..

Hi Christoph, I do see your P&F (Pain and Frustration), however, this
patch was only meant to be bandaid (*) for the fact that whole ~six
years elapsed since a basically proper patch that does the task was
posted http://lists.openfabrics.org/pipermail/general/2008-July/053021.html
and we still don't have uverbs support for QP creation flags!!

Roland, how you prefer to move on here? we can come up with quick
patch that just uses the reserved field of struct ib_uverbs_create_qp
and would allow to support upto 8 creation flags, this would not
require new uverbs command, OK?

Roland, we must fix this lack of user space to provide creation flags.
The bandaid I did after a whole production system was successfully
rebased to the upstream kernel sans this PITA which I has to solve
quickly in this uglish way.

Or.

(*) this is just bandaid and not for upstream since it touches just
one HW driver, i.e a similar patch you would need for every other HW
driver, and deals with only one QP creation flag.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
