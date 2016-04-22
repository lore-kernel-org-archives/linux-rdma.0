From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Fri, 22 Apr 2016 14:38:45 -0400
Message-ID: <20160422183844.GB21996@phlsvsds.ph.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com> <20160414164550.GC6247@obsidianresearch.com> <20160414175243.GA9310@phlsvsds.ph.intel.com> <20160420203616.GA28991@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420203616.GA28991-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 20, 2016 at 02:36:16PM -0600, Jason Gunthorpe wrote:
>On Thu, Apr 14, 2016 at 01:52:44PM -0400, Dennis Dalessandro wrote:
>> The eprom device is for low level programming of the eprom on the
>> chip. We do not use i2c for this because the eprom is directly
>> attached to the chip and not accessible via i2c, requires register
>> access.
>
>Okay, but the twsi.c is still not acceptable in a driver, use the i2c
>subsystem to talk to the qsfps. Open coding i2c is not OK.

Yeah, I mentioned this at OFA. We are looking at reworking this.

>The char dev(s) are also done wrong, there is no set to 'kobj.parent'
>and there are empty release functions. There are certainly
>use-after-free bugs between close and device removal, someone needs to
>audit all of this carefully.
>
>The patch forgets compat_ioctl.

We will take a look at this.

>Stuff like this should be a build bug:
> /* NOTE: assumes unsigned long is 8 bytes */

Our Kconfig depends on X86_64. Should we add a BUILD_BUG_ON or something?

>The 'goto on success' in hfi1_cdev_init is an anti-pattern, don't do it.

Can fix.

>Even if the char dev stays, creating two whole sysfs classes seems
>really unnecessary. Surely there is a better place to attach the cdev.
>
>And this is just outrageous:
>
>        if (atomic_inc_return(&user_count) == 1) {
>                ret = hfi1_cdev_init(0, class_name(), &hfi1_file_ops,
>                                     &wildcard_cdev, &wildcard_device,
>                                     true);
>                if (ret)
>
>I can see an argument for a per-device char dev (as Christoph says,
>that is not entirely uncommon) but this is a multi-device char dev????

We are discussing what can be done about this internally. On that note we 
are also looking at what we can do about the twsi as mentioned above, also 
the eprom, ui, and snoop. We'll send the actual plan for each issue to 
linux-rdma for feedback soon. 

We are certainly not opposed to improving these areas of the code. So long 
as we can maintain the same functionality, which seems doable. It's just 
that no one has spoken up about these things in the 9+ months since the 
driver was added. We need a bit of time to get it all sorted out.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
