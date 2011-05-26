From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Thu, 26 May 2011 09:24:18 +0300
Message-ID: <4DDDF212.4080700@mellanox.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com> <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com> <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com> <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com> <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA@mail.gmail.com> <BANLkTi=NkZQX2JFa99qkVpLAchRjNoYOhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=NkZQX2JFa99qkVpLAchRjNoYOhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> I mean set the MTU port-by-port with the module loaded, the same way
> we are supposed to be able to do for the port type.  Rather than having
> one global module parameter.

The HCA has set of per port buffers, from which comes the dependency 
between VLs to MTU. So with this code running for each IB hca/port, 
we're actually doing that logic port-by-port. I assume you didn't mean 
let the user specify a desired MTU for each hca/port... or I'm still not 
fully with you?

Anyway, I'd be happy to provide at least the folks that use torus/mesh 
and/or sophisticated QoS schemes an ability to use eight VLs with the 
current HW, so how about keeping the module param but with default value 
turned on?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
