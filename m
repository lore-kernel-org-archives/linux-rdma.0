From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 25/29] net/mlx4_core: Adjustments to SET_PORT
 for SRIOV-IB
Date: Mon, 9 Jul 2012 06:02:22 +0300
Message-ID: <CAJZOPZ+v281NB2chwQemY32xRYxnVuTPCFe0LQuuNveqD8SZgg@mail.gmail.com>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
	<1340094121-14858-26-git-send-email-jackm@dev.mellanox.co.il>
	<CAL1RGDW093B0p1caO2CHKQiAGtxLGR97h1tFd7W4QY8_31MfTg@mail.gmail.com>
	<CAJZOPZKhV=rcGF0duJLkGFBhD3_tG-JgW+hkVH51KX6uokVEiA@mail.gmail.com>
	<CAL1RGDUg+fhPDHBfXywaW2AaPfarM3vcx-UV0648hLSmT9s1Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUg+fhPDHBfXywaW2AaPfarM3vcx-UV0648hLSmT9s1Fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Zahavi <eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 6, 2012 at 6:09 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> So I can't run a SM in a guest?
[...]
>>> I can't run an SRP target in a guest?

> Seems like an unfortunate set of limitations, especially if I want a
> completely virtualized environment.  In my case I might want to
> test the same OS image that I deploy on physical HW inside a VM,
> and both running an SM and having a storage target seem like things
> I would want to do. Is it planned to fix this with more complete paravirtualization?

Re SM - in the SRIOV implementation for ConnectX, VFs are identified
by their GUIDs. Consequently, in the general case, any request or
unsolicited MAD must have a GRH.
However, the SM cannot be reached by MADs with GRH by remote nodes
because the IBTA PortInfo only provides the SM LID - the SM GID cannot
be discovered. Additionally, the Trap messages sent by many existing
IB elements do not comprise a GRH.
As a result, the SM can only be run on a function that is specifically
designated for default (GRH-less) forwarding of SMPs. Currently, this
is the PF, but a specific VF could be selected just the same in the
future. Note that SMP access should be restricted to designated &&
*trusted* VFs, as SMPs are agnostic to partitioning and allow nodes to
take over ports before the SM. A trust model for VF should be
developed.

Re. device management - currently, SRP targets cannot be discovered in
SRIOV, as the IsDeviceManagementSupported port capability is a
property of the physical port rather than of each VF. To implement
this some standardization should take place.

All in all, it is possible to extend the current impl. such that the
issues you brought arer addressed with more complete
paravirtualization, we will follow on that. Still, I don't see
something in the grounds of the submitted code that contradicts these
extensions, its matter of more work.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
