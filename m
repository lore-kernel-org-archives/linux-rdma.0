From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] suse: switch fully to the new udev mechanism
Date: Tue, 29 Aug 2017 11:12:20 -0600
Message-ID: <20170829171220.GA28687@obsidianresearch.com>
References: <20170827214704.GC14542@obsidianresearch.com>
 <71835edf-cb2a-d4f8-627e-0f60ee772fb7@suse.de>
 <20170828151609.GA7867@obsidianresearch.com>
 <b4b35cf1-ed07-dbee-37cc-15c00480ad04@suse.de>
 <20170828153146.GC7867@obsidianresearch.com>
 <84031eb6-9ae5-71c6-8ba3-252204c3688d@suse.de>
 <20170829150329.GA26051@obsidianresearch.com>
 <1504020051.52034.51.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504020051.52034.51.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 29, 2017 at 11:20:51AM -0400, Doug Ledford wrote:

> > rdma.fixup-mtrr.awk
> >  - Obsolete, supports ancient hardware, done in kernel now
> 
> Yeah, this is droppable.  It was needed back in the SDR days for qib
> hardware.

PR #199 deletes this file

> > rdma.mlx4-setup.sh
> > rdma.mlx4.conf
> > rdma.mlx4.sys.modprobe
> >  - Mellanox says they now prefer it if the device's EEPROM is
> >    configured, instead of this approach. So this is old
> 
> Right, but it still needs to stick around for now.  Even though the
> EEPROM approach is preferred, not all mlx4 level devices support it,
> and given that mlx4 is still very much in use, we need to keep it.

The modprobe approach is not compatible with hotplug.  Instead, we
really want this to run from a udev rule, but the mlx4 driver does not
create a kobject from mlx_core, so there is nothing to trigger the
rule on :|

I guess a kernel patch will be needed here..

> >  Maybe it should move
> >    to kernel-boot, but also unclear why we need it? doesn't
> >    libvirt do this nowadays?
> 
> It needs to die.  For a very long time libvirt has not been smart
> enough to deal with the dual ports on mlx4 hardware.  There has been
> work upstream in libvirt to make this work.  The scripts here are
> useless for any guests that are open to migration as they preconfigure
> the devices and then you attach the device to the guest more or less
> unmanaged.  Libvirt/qemu can never migrate the host because it doesn't
> know how to set up the card on the new host the same way.  It's my hope
> that the rdma tool will be expanded to support the different SRIOV
> configuration methods (mlx4 and mlx5 are totally different)
> transparently.  If/when that happens, it will be easy for libvirt to
> standardize on that method and move this to "fully supported" status. 
> Right now, this support is just to allow people to statically configure
> SRIOV for use, but I don't consider something that can't migrate guests
> production ready IMO.

Okay, lets leave that as redhat/, but I thought Mellanox sorted this
all out with the ipoib netlink patches related to sriov? Sigh.

> > rdma.udev-ipoib-naming.rules
> >  - This is a user example for udev rules..
> >    Could go into kernel-boot
> 
> Right.  This is a totally generic udev consistent device naming
> support.

Done in PR #199

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
