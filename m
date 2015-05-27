From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Wed, 27 May 2015 11:11:43 -0600
Message-ID: <20150527171143.GB9909@obsidianresearch.com>
References: <1432242708.28905.73.camel@redhat.com>
 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
 <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <1432659226.28905.151.camel@redhat.com>
 <20150526181336.GD11800@obsidianresearch.com>
 <1432672378.28905.178.camel@redhat.com>
 <20150526211114.GB4502@obsidianresearch.com>
 <1432736046.28905.215.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432736046.28905.215.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 10:14:06AM -0400, Doug Ledford wrote:
> > Because the QPN is part of the LLADDR IB can create two interfaces on
> > the same physical port that are completely separated by hardware. Read
> > Haggi's email, he explains how they plan to use this to create
> > interfaces that can be delegated to namespaces. It is not a bad idea
> > really.. 
> 
> Yes, it is actually.  The whole reason we went to GUID matching long ago
> was because of this exact issue.

I reflected on this some more last night, and yes, I am leaning toward
'bad idea' direction too.

Too much stuff breaks if you create multiple children with the same
pkey/guid:
 - RDMA CM cannot disambiguate CM packets between them
 - DHCP cannot tell them apart
 - Net scripts/network manager won't work
 - IPv6 becomes totally broken

That means the namespace stuff will have to create children using GUID
aliases..

> The *only* way this will ever be a workable item is if we A) reserve a
> number of queue pairs from the driver specifically for IPoIB use and B)
> specify which queue pairs go to which IPoIB devices at IPoIB module
> load

This basic idea is exactly why I think we should stick with the 20
byte LLADDR for ILFA_VF_MAC. It gives a route for the PF to tell the
VF what QPN to use for IPoIB (if we ever see HW support to implement that)

If we use 8 bytes then that route is closed off forever.

> > Not quite, in the 20 byte format the 8 bytes of the GUID are in the
> > last 8/20 bytes, so the app would have to place 12 zeros and then the
> > GUID to follow the 20 byte format (or 4 zeros, the prefix, then the GUID)
> > 
> > This is why the question of 'what is ILFA_VF_MAC' is so important,
> > every option presented (MAC,GUID,LLADDR) are incompatible with each
> > other.
> 
> For Ethernet devices, it's the MAC.  The equivalent of MAC on IB is the
> GUID.  I would leave it at that.

Yes, both arguments can be made:
  - Our netlink end point is targetting an IPoIB interface, and
    the equivelent to an Ethernet MAC in IPoIB language is the LLADDR.
  - Our netlink interface is targetting the hardware under the IPoIB
    interface and that MAC equivilent is the GUID

> IPoIB devices are constructs on top of
> the GUID/link, and you can have 10 IPoIB interfaces between the parent
> and children, but we don't need to specify all of those LLADDRs, we just
> need to give a unique GUID and allow the guest OS to create their own
> IPoIB devices on top of that.

As I've said, I would like to see netdev review that idea before we
merge any patches..

There are pragmatic downsides to the 8 byte choice: Userspace
completely looses the ability to size the address without a table
based on link type. That is terrible in the context of netlink's
design. For instance iproute2 would need IB specific code to format
the 'ip link show' (review print_vfinfo in iproute2) and to length
check 'ip link set vf mac'

If we do use 8, then it would be ideal (and my strong preference) to
also fix the IFLA_VF_MAC message to have a working length. I think
that could be done compatibly with a bit of work. At least that way
iproute2 can be kept clean when it learns to do IB, and we could have
the option again of using 20 someday if we need.

So to be clear, to go with the 8 byte option I suggest:
 - Engage netdev/iproute and confirm they are philosophically OK
   with IFLA_VF_MAC != IFLA_ADDRESS
 - Make a kernel patch to properly size the IFLA_VF_MAC message
 - Make a iproute patch to use the IFLA_VF_MAC size in print_vfinfo
   instead of hardcoded ETH_ALEN (using len == 32 mean len 6 for compat)
 - Drop in the IB patch
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
