From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH RFC] hw/pvrdma: Proposal of a new pvrdma
 device
Date: Thu, 6 Apr 2017 22:42:20 +0300
Message-ID: <20170406194218.GA2170@yuval-lap>
References: <1490872341-9959-1-git-send-email-marcel@redhat.com>
 <20170330141314.GM20443@mtr-leonro.local>
 <5e952524-7c2d-b4da-4bd7-6437830a40d8@redhat.com>
 <f7f3fc0e-0a75-2fdc-b3c2-6c3d34ff2978@redhat.com>
 <20170403062314.GO20443@mtr-leonro.local>
 <aa400244-426a-ea62-0ccf-ac5adb76fdd1@redhat.com>
 <20170404160155.GA1750@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404160155.GA1750-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 04, 2017 at 10:01:55AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2017 at 04:38:40PM +0300, Marcel Apfelbaum wrote:
> 
> > Here are some thoughts regarding the Soft RoCE usage in our project.
> > We thought about using it as backend for QEMU pvrdma device
> > we didn't how it will support our requirements.
> > 
> > 1. Does Soft RoCE support inter process (VM) fast path ? The KDBR
> >    removes the need for hw resources, emulated or not, concentrating
> >    on one copy from a VM to another.
> 
> I'd rather see someone optimize the loopback path of soft roce than
> see KDBR :)

Can we assume that the optimized loopback path will be as fast as direct
copy between one VM address space to another VM address space?

> 
> > 3. Our intention is for KDBR to be used in other contexts as well when we need
> >    inter VM data exchange, e.g. backend for virtio devices. We didn't see how this
> >    kind of requirement can be implemented inside SoftRoce as we don't see any
> >    connection between them.
> 
> KDBR looks like weak RDMA to me, so it is reasonable question why not
> use full RDMA with loopback optimization instead of creating something
> unique.

True, KDBR exposes RDMA-like API because it's sole user is currently pvrdma
device.
But, by design it can be expand to support other clients for example virtio
device which might have other attributes, can we expect the same from
SoftRoCE?

> 
> IMHO, it also makes more sense for something like KDBR to live as a
> RDMA transport, not as a unique char device, it is obviously very
> RDMA-like.

Can you elaborate more on this?
What exactly it will solve?
How it will be better than kdbr?

As we see it - kdbr, when will be expand to support peers on external
hosts, will be like a ULP.

> 
> .. and the char dev really can't be used when implementing user space
> RDMA, that would just make a big mess..

The position of kdbr is not to be a layer *between* user space and device -
it is *the device* from point of view of the process.

> 
> > 4. We don't want all the VM memory to be pinned since it disable memory-over-commit
> >    which in turn will make the pvrdma device useless.
> >    We weren't sure how nice would play Soft RoCE with memory pinning and we wanted
> >    more control on memory management. It may be a solvable issue, but combined
> >    with the others lead us to our decision to come up with our kernel bridge (char
> 
> soft roce certainly can be optimized to remove the page pin and always
> run in an ODP-like mode.
> 
> But obviously if you connect pvrdma to real hardware then the page pin
> comes back.

The fact that page pin is not needed with Soft RoCE device but is needed
with real RoCE device is exactly where kdbr can help as it isolates this
fact from user space process.

> 
> >    device or not, we went for it since it was the easiest to
> >    implement for a POC)
> 
> I can see why it would be easy to implement, but not sure how this
> really improves the kernel..

Sorry, we didn't mean "easy" but "simple", and simplest solutions are
always preferred.
IMHO, currently there is no good solution to do data copy between two VMs.

> 
> Jason

Can you comment on the second point - migration? Please note that we need
it to work both with Soft RoCE and with real device.

Marcel & Yuval
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
