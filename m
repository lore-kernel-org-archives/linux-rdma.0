From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Mon, 25 May 2015 16:32:35 -0600
Message-ID: <20150525223235.GA9858@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432226406.28905.22.camel@redhat.com>
 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
 <1432242708.28905.73.camel@redhat.com>
 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
 <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 12:50:52AM +0300, Or Gerlitz wrote:
> On Tue, May 26, 2015 at 12:14 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Mon, May 25, 2015 at 11:04:41PM +0300, Or Gerlitz wrote:
> >
> >> OK, so rewinding a bit, the IB VF [1] identity is their 8 bytes port
> >> GUID, and as Jason noted the user/kernel API allows to deliver up to
> >> 32 bytes between user and kernel under the set_vf_mac flow
> >> (do_setvfinfo() in net/core/rtnetlink.c). Trying it out through
> >> **non-modified** ip tool and net/core/rtnetlink.c things just work -
> >> I can set eight bytes value to be the virtual port GUID :
> >
> > Was I not perfectly clear? You have to use the 20 byte LLADDR format here:
> >
> >> # ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff:11:22
> 
> Jason,
> 
> I am aiming to provision the VF IB end-node address == port GUID (vGUID)
> in the same manner that VF Eth end-node address is their MAC, not
> more, not less.

I perfectly understand what you are trying to do.

I care about the design and consistency of netlink - and that means
there is one LLADDR definition for a net device, and every single netlink
message that touches a LLADDR uses that definition - for IPoIB that is 20
bytes.

To violate that design invariant needs an incredibly strong argument,
and you haven't made it.

This allows generic code to work with the LLADDR - for instance 'ip
link set vf mac' should have checked the size of the IFLA_ADDRESS and
demanded that the address argument is the same number of bytes. It is
very broken the command happily accepts an 8 byte and 6 byte argument
for the same device.

Yes, it is ugly that the PF side's ndo_get_vf_config cannot return the
same 20 byte address of the VF's ipoib interface, but I think that is
less ugly than forcing a different address format just for the vf calls.

If you have doubts then *ask netdev*. Ask them if ndo_set_vf_mac must
follow the same address size and format as IFLA_ADDRESS, or if we can
use something else.

Such a netlink architecture choice is beyond the authority of
linux-rdma.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
