From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Trust model for raw QPs
Date: Wed, 15 Aug 2012 08:40:29 -0500
Message-ID: <502BA6CD.9010308@opengridcomputing.com>
References: <502BA406.2060409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502BA406.2060409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/15/2012 8:28 AM, Or Gerlitz wrote:
> Currently, for an app to open a raw QP from user space, we (verbs) 
> require admin permission, for which we (Mellanox) got customer 
> feedback saying this is problematic on some of the environments.
>
> Suppose we allow to user to provide source mac+vlan when creating the 
> QP or when modifying its state, and the HW can enforce that -- in that 
> case I think its OK to remove that restriction e.g ala what is allowed 
> today with user space UD QPs when the fabric is IB.
>
> Or.

We have similar requirements from customers.   I don't understand how 
mac+vlan allows the driver to enforce anything?  Can you explain this 
further?

Stevo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
