From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 10:47:05 -0600
Message-ID: <20170731164705.GB28204@obsidianresearch.com>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501513246.2466.1.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2017 at 03:00:47PM +0000, Bart Van Assche wrote:
> On Mon, 2017-07-31 at 14:36 +0300, Leon Romanovsky wrote:
> > I would like to propose the discussion about ability to add
> > persistent device naming to RDMA subsystem.
> > 
> > Right now, the devices receive their names by simple addition of new free
> > index to the name (mlx5_0, mlx5_1 ...). Such naming scheme depends on the
> > PCI probing and in case of device reset can rename device.
> > 
> > Such situation doesn't help to provide constant udev rules, reliable
> > ibverbs hotplug and advanced "set command" of RDMAtool which at some
> > point of time will require reinit of ib_device.
> > 
> > In this discussion, I want to present netdev implementation of such
> > feature, talk about implications on libibverbs and suggest possible
> > device name convention.
> 
> Hello Leon,
> 
> Does this mean that there is user space software that depends on these names?
> Shouldn't all user space software be independent of the device names assigned
> by the kernel? For e.g. SCSI disks this was solved a long time ago by making
> /dev/disk/by-id/${name derived from persistent ID} soft links available. An
> example:
> 
> $ ls -l /dev/disk/by-id/scsi-35001b44c698c2947
> lrwxrwxrwx 1 root root 9 Jul 31 07:53 /dev/disk/by-id/scsi-35001b44c698c2947 -> ../../sda

The problem with RDMA is it relies heavily on sysfs, and the sysfs
path name is what is being proposed to be changable.

The best fix is going to be to consistently use the new stable index
to access all information, which means effectively obsoleting sysfs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
