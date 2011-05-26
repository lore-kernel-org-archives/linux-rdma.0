From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Thu, 26 May 2011 08:53:51 -0700
Message-ID: <BANLkTimrm7bqTT8qAzxdf9tsJuv7+NPO+g@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
 <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com> <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
 <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com> <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA@mail.gmail.com>
 <BANLkTi=NkZQX2JFa99qkVpLAchRjNoYOhg@mail.gmail.com> <4DDDF212.4080700@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DDDF212.4080700-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2011 at 11:24 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> Roland Dreier wrote:
>>
>> I mean set the MTU port-by-port with the module loaded, the same way
>> we are supposed to be able to do for the port type. =A0Rather than h=
aving
>> one global module parameter.
>
> The HCA has set of per port buffers, from which comes the dependency =
between
> VLs to MTU. So with this code running for each IB hca/port, we're act=
ually
> doing that logic port-by-port. I assume you didn't mean let the user =
specify
> a desired MTU for each hca/port... or I'm still not fully with you?
>
> Anyway, I'd be happy to provide at least the folks that use torus/mes=
h
> and/or sophisticated QoS schemes an ability to use eight VLs with the
> current HW, so how about keeping the module param but with default va=
lue
> turned on?

What I'm trying to say is that a global module parameter is a pain for =
users.
Would it make sense to have a "port_type" module parameter where you co=
uld
set all the ports to IB or to ethernet, and have no way to have a mix o=
f port
types or change without reloading the module?

The obvious answer is no, and therefore we have mlx4_portX  attributes =
in
sysfs that are per port.  MTU is the same way.  For example, you sugges=
t
that CX3 won't have the same limitation of only 4 VLs with 4K MTU.  In
that case, think about a system with one CX2 and one CX3 -- should the
CX3 be limited to 2K MTU because of CX2 limitations?

Rather than having a completely different way of handling MTU, why can'=
t
we just handle it the same way as the port type, and have a sysfs attri=
bute
like "mlx4_mtuN" for each port?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
