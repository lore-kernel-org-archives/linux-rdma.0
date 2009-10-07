From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Thu, 8 Oct 2009 00:23:13 +0200
Message-ID: <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>
	 <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>
	 <4ACAF913.3050909@voltaire.com>
	 <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AA7E7C8FC2A04B9688CD69CEB7355DF8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:

> From user space, the call sequence does not change. =A0The user calls
> rdma_resolve_addr, rdma_resolve_route, rdma_connect, etc. =A0It is up=
 to the
> librdmacm to perform the resolution. =A0Today, the resolution request=
 is simply
> passed down to the kernel, which restricts how the resolution can be =
performed.

good, fair-enough

> I kept resolving the address and route separate. =A0rdma_set_ib_path,=
 which has
> always existed btw, simply sets the route/path. =A0 The new call,
> rdma_set_ib_dest, sets the address mapping. =A0To use rdma_set_ib_des=
t, the user
> must have called rdma_bind_addr first, which covers steps 1 & 2 that =
you
> mentioned above. =A0The rdma_bind_addr call can be done internally to=
 the
> librdmacm as part of the rdma_resolve_addr implementation.

I understand that rdma_bind_address covers the local device and vlan
resolutions, but I we should also --keep-- supporting also
applications that use an explicit source address in rdma_resolve_addr
or that don't do bind, provide src=3DNULL to resolve_addr and rely on
the rdma-cm to use route lookup (as the rdma_resolve_addr man page
indicates) for the device/vlan resolution.

> If a user sets the wrong address mapping or route, they should only a=
ffect themselves

I wasn't sure to follow this comment, can you elaborate a bit more?

> (FYI - I have not yet implemented the librdmacm to call rdma_bind_add=
r as part
> of rdma_resolve_route on linux. =A0I did not see an easy way to conve=
rt a
> destination IP address to a source IP address. =A0If anyone knows how=
, please let
> me know.)

I assume you was referring rdma_resolve_addr, correct? there should be
a way to do that from user space and if not, you can go down to the
kernel, resolve the device/vlan and then call ACM to resolve the
destination. It seems that you must resolve the dev/vlan for issuing
the ACM ARP replacement...

> >I would prefer to have a solution where the app flow isn't touched,
> >something like the kernel rdma-cm to communicate with the user space=
 ACM
> >daemon to get address and route resolutions. =A0Does such a design m=
akes
> >sense to you?

> Long term, this is exactly the type of flow that I envision. =A0I'd l=
ike to have
> real data to show that the ACM implementation scales first, which is =
part of my
> problem. =A0I do not have the ability to easily change kernel drivers=
 on any
> larger sized clusters. =A0My approach is to allow user space to perfo=
rm the
> address and route resolution and pass the data to the kernel. =A0This=
 way, we have
> the freedom to test multiple solutions, until we can settle on what w=
orks.

I am not sure to fully follow on the easily-change-kernel-drivers
claim, isn't some change to the kernel rdma-cm being a must for the
ACM + librdmacm solution to work? suppose you have a way to fully do
the addr+route resolutions from user space, will the kernel rdma-cm
state machine will be willing to issue

rdma_create_id
rdma_set_ib_path (you said this exists today?)
rdma_create_qp
rdma_connect

???

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
