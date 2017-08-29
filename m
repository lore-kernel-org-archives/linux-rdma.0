From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] suse: switch fully to the new udev mechanism
Date: Tue, 29 Aug 2017 11:20:51 -0400
Message-ID: <1504020051.52034.51.camel@redhat.com>
References: <20170827214704.GC14542@obsidianresearch.com>
         <71835edf-cb2a-d4f8-627e-0f60ee772fb7@suse.de>
         <20170828151609.GA7867@obsidianresearch.com>
         <b4b35cf1-ed07-dbee-37cc-15c00480ad04@suse.de>
         <20170828153146.GC7867@obsidianresearch.com>
         <84031eb6-9ae5-71c6-8ba3-252204c3688d@suse.de>
         <20170829150329.GA26051@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829150329.GA26051-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-29 at 09:03 -0600, Jason Gunthorpe wrote:
> On Tue, Aug 29, 2017 at 09:59:34AM +0200, Nicolas Morey-Chaisemartin
> wrote:
> 
> > I looked around to all the scripts and I'm going some time to go
> > through all these and decide which we need and which we don't.
> > Some of those were all upstreamed at once and I'm not sure what the
> > bug they were fixing and if it is still needed.
> 
> Basically none of it is necessary today from a 'bug fix'
> perspective, the bug fix stuff is all ancient history.
> 
> Here is my perspective on the RH directory:
> 
> rdma.conf
>  - Obsoleted by /etc/rdma/modules/rdma/modules
>    Except for 'tech preview' which is a RH concept.

Sounds right.

> rdma.fixup-mtrr.awk
>  - Obsolete, supports ancient hardware, done in kernel now

Yeah, this is droppable.  It was needed back in the SDR days for qib
hardware.

> rdma.ifdown-ib
> rdma.ifup-ib
>  - Looks like this supports RH's old 'network-scripts' system?
>    Is it even compatible with suse?

Yes, and probably not.  We have to keep it around because users have
the option of using the network scripts instead of NetworkManager.

> rdma.kernel-init
> rdma.service
> rdma.udev-rules
>  - This is the implementation of rdma.conf, it is obsoleted.
>    The bug fix stuff is all for ancient hardware or done in
>    the kernel now.

Correct.  The module loading should be obsoleted by the udev
autoloading work you just did and the PCI fixups in the script are even
more ancient and droppable than the MTRR fixups ;-)

> rdma.mlx4-setup.sh
> rdma.mlx4.conf
> rdma.mlx4.sys.modprobe
>  - Mellanox says they now prefer it if the device's EEPROM is
>    configured, instead of this approach. So this is old

Right, but it still needs to stick around for now.  Even though the
EEPROM approach is preferred, not all mlx4 level devices support it,
and given that mlx4 is still very much in use, we need to keep it.

> rdma.modules-setup.sh
>  - Dracut support to include more stuff in the initrd.

Right, which Red Hat (at least) must keep.

> rdma.sriov-init
> rdma.sriov-vfs
>  - This creates SRIOV instances at boot.

Correct.

>  Maybe it should move
>    to kernel-boot, but also unclear why we need it? doesn't
>    libvirt do this nowadays?

It needs to die.  For a very long time libvirt has not been smart
enough to deal with the dual ports on mlx4 hardware.  There has been
work upstream in libvirt to make this work.  The scripts here are
useless for any guests that are open to migration as they preconfigure
the devices and then you attach the device to the guest more or less
unmanaged.  Libvirt/qemu can never migrate the host because it doesn't
know how to set up the card on the new host the same way.  It's my hope
that the rdma tool will be expanded to support the different SRIOV
configuration methods (mlx4 and mlx5 are totally different)
transparently.  If/when that happens, it will be easy for libvirt to
standardize on that method and move this to "fully supported" status. 
Right now, this support is just to allow people to statically configure
SRIOV for use, but I don't consider something that can't migrate guests
production ready IMO.

> rdma.udev-ipoib-naming.rules
>  - This is a user example for udev rules..
>    Could go into kernel-boot

Right.  This is a totally generic udev consistent device naming
support.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
