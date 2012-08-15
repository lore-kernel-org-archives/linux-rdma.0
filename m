From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Trust model for raw QPs
Date: Wed, 15 Aug 2012 14:06:32 +0000
Message-ID: <000001392a9b6b2a-ba67aaa6-b7b8-4c80-90db-03f0172aef6e-000000@email.amazonses.com>
References: <502BA406.2060409@mellanox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502BA406.2060409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 15 Aug 2012, Or Gerlitz wrote:

> Currently, for an app to open a raw QP from user space, we (verbs) require
> admin permission, for which we (Mellanox) got customer feedback saying this is
> problematic on some of the environments.

Well yes it is but the kernel mod is a one line to get rid of this
problem.

> Suppose we allow to user to provide source mac+vlan when creating the QP or
> when modifying its state, and the HW can enforce that -- in that case I think
> its OK to remove that restriction e.g ala what is allowed today with user
> space UD QPs when the fabric is IB.

Well yes that would mean that the source mac and vlan are configured with
admin permissions and then the app would run without within the
constraints established in priviledged moded.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
