From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Tue, 26 May 2015 12:13:36 -0600
Message-ID: <20150526181336.GD11800@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432226406.28905.22.camel@redhat.com>
 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
 <1432242708.28905.73.camel@redhat.com>
 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
 <20150525211433.GA9186@obsidianresearch.com>
 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
 <20150525223235.GA9858@obsidianresearch.com>
 <1432659226.28905.151.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432659226.28905.151.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 26, 2015 at 12:53:46PM -0400, Doug Ledford wrote:
> > I perfectly understand what you are trying to do.
> > 
> > I care about the design and consistency of netlink - and that means
> > there is one LLADDR definition for a net device, and every single netlink
> > message that touches a LLADDR uses that definition - for IPoIB that is 20
> > bytes.
> 
> So, here's my $.02.
> 
> First, 8 bytes is the right size for the data to be transferred.  The
> remaining 12 bytes of the IPoIB LLADDR are generated constructs at
> least

Today only 8 bytes are settable, but the GID prefix and QPN are both
logically something that *could* be set by the PF in some future.

> partially controlled by elements outside of this machine, and moreover,
> they are *not* the *actual* LLADDR of the underlying IB device and the
> 20 byte LLADDR never hits the wire.  So, it's an artificial construct.

Yes, it is ugly that we are using a IPoIB netdev to configure the RDMA
device.

If you want to suggest that we use the RDMA Netlink interface to do
this, that would make sense to me too. But I thought the whole point
was to provide something somewhat software compatible with the
ethernet world..

> The fact that the 20 byte LLADDR of IPoIB is problematic is born out by
> multiple facts:  we only use 8 bytes in DHCP requests and responses,
> only use 8 bytes in matching IPoIB netdevices against HWADDR entries in
> the sysconfig/ifcfg-* files, only use 8 bytes for matching the udev
> rules to rename IPoIB devices, etc.

The LLADDR for IPoIB *is* 20 bytes.

Truncating it down is *broken userspace*:
 - DHCP: Not sending the full 20 bytes in the client request means the
   server cannot unicast the reply. This causes all sorts of problems
   and is discouraged in the RFCs these days.
 - ifcfg/udev/networkmanager: So what happens when I do
    ip link add link ib0 name ib0.1 type ipoib
   And get two IPoIB interfaces with the same GUID? I doubt any sane
   user would want to apply the same config to those two interfaces.

There is a reason the kernel uses 20 byte - it is the unique LLADDR
for the interface, it is the value it stuffs in a ND packet. If
userspace takes the 20 byte LLADDR and mangles it so it is no longer
unique, then that is it's prerogative.

But that doesn't mean the kernel should ever accept the 8 byte value
for anything.

> This clearly demonstrates that attaching the netlink ndo points to the
> IPoIB netdevice is, let's just say, a shortcut.  The *real* device that
> we should be manipulating is not the IPoIB device, but the verbs
> device.

Yep.

> That leaves using the IPoIB device.  In which case, here's what I want:
> 
> If a user passes in a MAC addresses, please use the following checks:
> 
> if (mac_len != 8 && mac_len != 20)
> 	err out

As I've already said, this is not possible. The person who designed
this netlink extension screwed it up and 'mac_len' is fixed to 32
bytes.

Even if they didn't, the netlink common code should validate the input
length for the drivers and confirm it is dev->addr_len, as is done for
all other cases.

Unbreaking it is a UAPI change, not impossible, but do we really care
enough about 8 or 20 to push for that?

> If you have an app that queries a device, sees that it has a 20byte MAC,
> and then tries to set that MAC, it may have no specific knowledge of how
> IPoIB relates to the underlying verbs device and could just be trying to
> set a MAC blindly.  And that's ok, but we aren't going to honor the
> entire MAC they pass in, and that's likely to confuse the app (or the
> person running the app).

Yes, I agree with this, but no matter what we do, apps using this
feature need some kind of IB specific knowledge to format the set.

If that specific knoweldge is 'ignore the LL_ADDRESS size and use 8
byte' or 'specially format the 20 byte' seems pretty much equal to me.

> On the other hand, if we advertise a 20 byte MAC, and the app/person
> passes in an 8 byte MAC instead, then that implicitly denotes that the
> app/person *knows* this is an IPoIB device, and *knows* that we are
> actually setting the underlying GUID of the verbs device, and is aware
> of and prepared for the fact that the entire 20 byte MAC is not in fact
> settable.

Well, as above, this is unworkable, but even if we could specify the
length, I think this is goofy.

You've been concentrating on the set side, but there is a get side
too, and the response to set is a get packet.

What does get return? If we accept 8 or 20, then get must return 20.

Should get response to a set of 8 return 8 or 20? 

The kernel UAPI is much cleaner if there is one case: 20 byte LLADDR.

The kernel internal API is much cleaner if drivers don't have the
option to use two sizes for their LLADDR.

Just checking that the 20 byte address is sane (right GID prefix, 0
QPN, right flags) should be enough for the app to denote it knows what
it is doing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
