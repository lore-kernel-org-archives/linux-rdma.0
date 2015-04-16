From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Thu, 16 Apr 2015 20:44:10 +0000
Message-ID: <DB4PR05MB0863F49028F5E0E252278A6BB1E40@DB4PR05MB0863.eurprd05.prod.outlook.com>
References: <DB4PR05MB0863248FC7422B05765DD8E5B1E40@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB4PR05MB0863248FC7422B05765DD8E5B1E40-xsq7jzH2t6llkovD9u25SNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean (sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Somnath Kotur (Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org)" <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > RoCE v2 is really Infiniband over UDP over IP.  Why don't we just
> > > call
> > it IBoUDP like it is?
> > RoCEv2 is the name in the IBTA spec (Annex 17)
> 
> We call RoCE IBoE in the kernel, because that's what it is.  RoCE is an IBTA
> marketing name.
> 
> Looking through the Annex, I don't see where Ethernet is even a requirement
> for this technology to work.  The IB transport is layered over a standard UDP
> header.  I do see where the spec calls out updating the IP header, but that's it.
> 
> Regardless of what it's called, it replaces the underlying network and
> transport protocols, versus IB-classic or IBoE/RoCE.  That should be captured
> properly, not by saying there's a new GID type.  RoCE v2 doesn't even use
> GIDs as part of its protocol.  It uses UDP/IP addresses.
> 
> 

The RoCE Verbs interface references the HCA GID table in QPs and AHs, for all RoCE versions.
The specification mandates that the Verbs consumer may use the following protocols over the same RoCE-capable HCA and the same physical port:
- RoCEv1 (L2, IB GRH, IB BTH+, payload)
- RoCEv2 using IPv4 (L2, IPv4, UDP, IB BTH+, payload)
- RoCEv2 using IPv6 (L2, IPv6, UDP, IB BTH+, payload)
The distinction (by spec) is done by associating a GID type attribute to each GID table entry, which is either IB, IPv4, or IPv6.
This is how apps can create different RC QPs using these different wire protocols, or a single UD QP that can send packets to all of these wire protocols.

Perhaps we could add another enum entry for RoCEv1 in the patch to make this clearer.

> > > IBoUDP changes the Ethertype, replaces the network header, adds a
> > > new
> > transport protocol header, and layers IB over that.  This change
> > should be exposed properly and not as just a new GID type.
> > I don't understand what do you suggest here. Can you give an example?
> 
> I don't have a solution here.  Please look at Michael Wang's patch series and
> see how this would fit into that model.  The introduction of iWarp required
> defining a new 'transport' type.  IBoE added a new link layer.  Based on those
> changes, this would warrant introducing a new network layer, so that it can
> be distinguished properly from the other options.  Maybe that's the right
> approach?
> 

The "new-transport" in Michael's patches doesn't refer to the network transport layer, but rather acts as a summary of the tuple <link, transport, node_type> (the network layer is indeed skipped).
The network transport layer of Infiniband and *all* RoCE types is the same: IB transport.
As I said earlier, the network layer (e.g., IPv4, IPv6, or GRH) cannot be a port attribute because RoCE HCAs support all of them over the same physical port.

Maybe we should change these patches to encode the port "summary" as a bit mask, and provide convenient masks for queries?
Alternatively, we could leave the port qualifiers as they are (i.e., with distinct <link, transport, node_type> qualifiers>) instead of introducing "new-transport", but provide convenient wrappers for ULPs to use.
For example:
- is_roce() /* returns true for all RoCE wire protocols */
- is_rocev1()
- is_rocev2()
- is_iwarp()
- ...

> Cisco's NIC reports a transport layer of 'USNIC_UDP', which should really just
> be 'UDP'.  That NIC supports UDP/IP/Ethernet, based on the rdma stack's
> model.
> RoCE v2 is also UDP/IP/Ethernet, it only layers IB over that.  (This makes the
> use of the term 'transport' confusing.  Maybe there should also be a 'session'
> protocol?)  It seems completely reasonable that a device which does
> IB/UDP/IP/Ethernet to someday expose the UDP/IP/Ethernet portion (if it
> doesn't already), and from the same port at the same time.

RoCEv2 uses UDP only as an encapsulation protocol (just like VXLAN).
The transport is well-defined: IBTA transport (just like Infiniband).
In the USNIC case, UPD is indeed the actual network transport.

> 
> Rather than continuing to try to make everything look like an IB-classic device
> because it's convenient, the stack needs to start exposing things properly.  I
> don't know what the right solution should be, but trying to capture this level
> of detail as a different GID type definitely looks like a step in the wrong
> direction.

As mentioned above, this is how Verbs consumers send traffic using the different wire-protocols over the same physical port.
This patch-set follows the specification, and cleanly provides all per-GID associations in 'struct ib_gid_attr'.

So basically, in RoCE, a GID entry represents a network interface (a netdev) to the HCA, and encompasses all information related with that interface: MAC, VLAN, MTU, IP address, namespace, etc.
This also makes it straight forward to add future extensions.

> 
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
