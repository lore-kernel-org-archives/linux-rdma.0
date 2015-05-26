From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Tue, 26 May 2015 15:11:14 -0600
Message-ID: <20150526211114.GB4502@obsidianresearch.com>
References: <1432226406.28905.22.camel@redhat.com>
 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
 <1432242708.28905.73.camel@redhat.com>
 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
 <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <1432659226.28905.151.camel@redhat.com>
 <20150526181336.GD11800@obsidianresearch.com>
 <1432672378.28905.178.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432672378.28905.178.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 04:32:58PM -0400, Doug Ledford wrote:

> Not so much ethernet world as netdevice world.  The iproute2 program is
> used to configure any and all netdevices, ethernet or otherwise.  Right
> now, we can abuse it to do the same here, but it uses the netdevice ndo_
> ops, not rtnetlink to accomplish what it does, so we are limited in how
> we do thing if we want to maintain tool usage.

Hmm? iproute2 does it over rtnetlink?

> > The LLADDR for IPoIB *is* 20 bytes.
> > 
> > Truncating it down is *broken userspace*:
> >  - DHCP: Not sending the full 20 bytes in the client request means the
> >    server cannot unicast the reply. This causes all sorts of problems
> >    and is discouraged in the RFCs these days.
> 
> Reference?  The RFCs I've read (4390 -> 4361 -> 3315) list a number of
> options (three at the moment), but the LLADDR options all call for using

I'm talking about this part from RFC 4390:

   As described above, the link-layer address is unavailable to the DHCP
   server because the link-layer address is larger than the "chaddr"
   field length.  As a result, the server cannot unicast its reply to
   the client.  Therefore, a DHCP client MUST request that the server
   send a broadcast reply by setting the BROADCAST flag when IPoIB
   Address Resolution Protocol (ARP) is not possible, i.e., in
   situations where the client does not know its IP address.

AFAIK, nobody ever solved this, and it actually does cause real world
problems for cloud stuff as there is limited randomness in the
TID. This is the network side of DHCP.

> a LLADDR from a device that is a permanent part of the machine (not
> common with add in cards), so the option most commonly used in IB is
> option 2, DUID Assigned by Vendor, aka GUID.  According to that,
> truncating to 8 bytes is precisely what you are supposed to do.  And, at
> least in all current Red Hat products, that's exactly how dhcp client
> creates the client-id.

Using the GUID as the client-id is sort of OK from a policy
perspective (ie what IP should I use), but it doesn't help the network
side, and it breaks down completely when you create child interfaces.

Basically, the dhcp server not having the LLADDR at all is a pretty
big hack.. No other network I know of runs DHCP like that.

> >  - ifcfg/udev/networkmanager: So what happens when I do
> >     ip link add link ib0 name ib0.1 type ipoib
> >    And get two IPoIB interfaces with the same GUID? I doubt any sane
> >    user would want to apply the same config to those two interfaces.
> 
> No, they probably don't want to apply the same rules to both interfaces.
> I'm not entirely sure I agree with the argument though.  I fully
> expected this to fail without a pkey argument on the ip command
> line.

Does that matter to the above tools? Are they using PKey,GUID as their
key?

> The net stack doesn't allow users to do the same thing with Ethernet
> devices, so I'm not sure we shouldn't be disallowing this as opposed to
> creating duplicate devices that are identical in all ways except name.

The netstack doesn't allow it for ethernet because it would create a
2nd identical LLADDR, and LLADDRs must be unique.

Because the QPN is part of the LLADDR IB can create two interfaces on
the same physical port that are completely separated by hardware. Read
Haggi's email, he explains how they plan to use this to create
interfaces that can be delegated to namespaces. It is not a bad idea
really.. 

So prepare for a world where each namespace has a child IPoIB
interface with a unique QPN, but the same Pkey and GUID as the
host. The breakage from assuming GUID == unique will become a problem.

> > Unbreaking it is a UAPI change, not impossible, but do we really care
> > enough about 8 or 20 to push for that?
> 
> In truth, at least right now, it's all moot.  Since we can't set the
> subnet prefix, the qpn, or the flags, anything above 8 bytes is
> immutable regardless of how many bytes we pass in.  So even if we say we
> aren't going to change the UAPI and for everything to 20, the real world
> result is that 8 works exactly the same and has no functional
> difference.

Not quite, in the 20 byte format the 8 bytes of the GUID are in the
last 8/20 bytes, so the app would have to place 12 zeros and then the
GUID to follow the 20 byte format (or 4 zeros, the prefix, then the GUID)

This is why the question of 'what is ILFA_VF_MAC' is so important,
every option presented (MAC,GUID,LLADDR) are incompatible with each
other.

> > What does get return? If we accept 8 or 20, then get must return 20.
> 
> The get has to return 20 regardless.  It's the only accepted means of
> getting all 20 bytes of the LLADDR.

You are conflating IFLA_ADDRESS and IFLA_VF_MAC.

IFLA_VF_MAC could be 8 byte and IFLA_ADDRESS could be 20, I think that
makes no sense, but it wouldn't break existing stuff.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
