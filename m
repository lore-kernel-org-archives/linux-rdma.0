From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core] suse: switch fully to the new udev mechanism
Date: Tue, 29 Aug 2017 17:38:08 +0200
Message-ID: <8f9bf129-d600-9fb5-64fa-e5cca4018bab@suse.de>
References: <20170827214704.GC14542@obsidianresearch.com>
 <71835edf-cb2a-d4f8-627e-0f60ee772fb7@suse.de>
 <20170828151609.GA7867@obsidianresearch.com>
 <b4b35cf1-ed07-dbee-37cc-15c00480ad04@suse.de>
 <20170828153146.GC7867@obsidianresearch.com>
 <84031eb6-9ae5-71c6-8ba3-252204c3688d@suse.de>
 <20170829150329.GA26051@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829150329.GA26051-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 29/08/2017 à 17:03, Jason Gunthorpe a écrit :
> On Tue, Aug 29, 2017 at 09:59:34AM +0200, Nicolas Morey-Chaisemartin wrote:
>
>> I looked around to all the scripts and I'm going some time to go through all these and decide which we need and which we don't.
>> Some of those were all upstreamed at once and I'm not sure what the
>> bug they were fixing and if it is still needed.
> Basically none of it is necessary today from a 'bug fix'
> perspective, the bug fix stuff is all ancient history.
>
> Here is my perspective on the RH directory:
>
> rdma.conf
>  - Obsoleted by /etc/rdma/modules/rdma/modules
>    Except for 'tech preview' which is a RH concept.
> rdma.fixup-mtrr.awk
>  - Obsolete, supports ancient hardware, done in kernel now
> rdma.ifdown-ib
> rdma.ifup-ib
>  - Looks like this supports RH's old 'network-scripts' system?
>    Is it even compatible with suse?
> rdma.kernel-init
> rdma.service
> rdma.udev-rules
>  - This is the implementation of rdma.conf, it is obsoleted.
>    The bug fix stuff is all for ancient hardware or done in
>    the kernel now.
> rdma.mlx4-setup.sh
> rdma.mlx4.conf
> rdma.mlx4.sys.modprobe
>  - Mellanox says they now prefer it if the device's EEPROM is
>    configured, instead of this approach. So this is old
> rdma.modules-setup.sh
>  - Dracut support to include more stuff in the initrd.
> rdma.sriov-init
> rdma.sriov-vfs
>  - This creates SRIOV instances at boot. Maybe it should move
>    to kernel-boot, but also unclear why we need it? doesn't
>    libvirt do this nowadays?
> rdma.udev-ipoib-naming.rules
>  - This is a user example for udev rules..
>    Could go into kernel-boot
>
> If suse never shipped this stuff before then there is no reason
> to rush to add it now..

We did for SLE12SP3 because it was a rushed job and we pretty much copied the redhat spec and fixed to match our packaging rules.
It appears we should be able to drop all these. We just need a new dracut file with the instmods but without all the redhat files.
It makes sense to keep the ipoib udev example too.
Not sure about the SRIOV files.



>> I contacted Doug on the side. It would make sense to work with Red
>> Hat to migrate to the udev system (vs rdma.service) and "cleanup"
>> those scripts so they can be shared more easily.  This also means
>> this won't be done before v15 is out. We should keep SUSE spec as is
>> (it works) and work on the cleanup for v16.
> rdma.service is replaced by the stuff in kernel boot, and by my
> eye the remainder is highly RH specific or I'm not certain what it is
> for.. suse will probably need some distro specific things as well.

It may come to that but we have nothing pending yet

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
