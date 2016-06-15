From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Wed, 15 Jun 2016 08:02:13 -0400 (EDT)
Message-ID: <794983323.42297890.1465992133003.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com> <20160614131552.GP5408@leon.nu> <1531921470.42169965.1465912634165.JavaMail.zimbra@redhat.com> <1296246237.42197305.1465926035162.JavaMail.zimbra@redhat.com> <1167916510.42202925.1465929678588.JavaMail.zimbra@redhat.com> <a524c577-cfb1-4072-da12-01d0d9ab9c38@sandisk.com> <109658870.42286330.1465988279277.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <109658870.42286330.1465988279277.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Wednesday, June 15, 2016 6:57:59 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> 
> 
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Cc: "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Wednesday, June 15, 2016 3:40:23 AM
> > Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
> > swiotlb_alloc_coherent()
> > 
> > On 06/14/2016 08:41 PM, Laurence Oberman wrote:
> > > This may be a data point here
> > > After each change I have rebooted the host as its required.
> > > I am at swiotlb=16 and after the first reboot with maxed out tuning I had
> > > no alerts.
> > > On the second controller restart without a system reboot I got them
> > > again.
> > >
> > > Again, I never see these other than when I am in  the reconnect loop, and
> > > they seem to be non-intrusive as each time I recover fully.
> > >
> > > When I first changed to 4 and had not increased the ib_srp paramaters I
> > > had
> > > two restarts with no messages so that was what led me to report that this
> > > seems to have worked.
> > > I can see now that this was not the case and already mentioned, the claim
> > > that the change fixed this was wrong.
> > > Apologies for that.
> > >
> > > I am continuing to research and debug now.
> > 
> > Hello Laurence,
> > 
> > In the kernel source tree I found the following:
> > 
> >  From include/linux/swiotlb.h:
> > 
> > #define IO_TLB_SHIFT 11
> > 
> >  From lib/swiotlb.c:
> > 
> > #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
> > [ ... ]
> > #define IO_TLB_DEFAULT_SIZE (64UL<<20)
> > [ ... ]
> > static int __init
> > setup_io_tlb_npages(char *str)
> > {
> > 	if (isdigit(*str)) {
> > 		io_tlb_nslabs = simple_strtoul(str, &str, 0);
> > 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
> > 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> > 	}
> >          [ ... ]
> > }
> > early_param("swiotlb", setup_io_tlb_npages);
> > [ ... ]
> > void  __init
> > swiotlb_init(int verbose)
> > {
> > 	size_t default_size = IO_TLB_DEFAULT_SIZE;
> > 	[ ... ]
> > 
> > 	if (!io_tlb_nslabs) {
> > 		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
> > 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> > 	}
> > 	[ ... ]
> > }
> > 
> > I think this means that the swiotlb parameter has to be set to a value
> > above 32768 to increase the number of swiotlb buffers above the default.
> > 
> > Bart.
> > 
> > 
> > 
> Hello Bart
> 
> I will try that.
> When I looked at the code I saw it being set to 1 as a default, and read the
> Doc comments as a slab count so figured its an int and would be calculated
> as n x slabs.
> I guess that's another Document update needed for kernel docs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

We are missing something here

I set it to double 266240 given the message below where its says we are full at 266240.

I will instrument kernel and see what it gets set to to make sure we see whats happening.

BOOT_IMAGE=/vmlinuz-4.7.0-rc1.bart.swiotlb+ root=/dev/mapper/rhel-root ro crashkernel=auto rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap console=ttyS1,115200n8 scsi_mod.use_blk_mq=1 swiotlb=532480

dmesg | grep -i swio
[    0.000000] Linux version 4.7.0-rc1.bart.swiotlb+ (loberman@jumptest1) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-4) (GCC) ) #5 SMP Mon Jun 13 21:09:50 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.7.0-rc1.bart.swiotlb+ root=/dev/mapper/rhel-root ro crashkernel=auto rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap console=ttyS1,115200n8 scsi_mod.use_blk_mq=1 swiotlb=532480
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.7.0-rc1.bart.swiotlb+ root=/dev/mapper/rhel-root ro crashkernel=auto rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap console=ttyS1,115200n8 scsi_mod.use_blk_mq=1 swiotlb=532480

[    4.663794] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)           **** Note

[    4.917998] usb usb1: Manufacturer: Linux 4.7.0-rc1.bart.swiotlb+ ehci_hcd
[    4.954666] usb usb2: Manufacturer: Linux 4.7.0-rc1.bart.swiotlb+ uhci_hcd
[    5.083110] usb usb3: Manufacturer: Linux 4.7.0-rc1.bart.swiotlb+ uhci_hcd
[    5.111634] usb usb4: Manufacturer: Linux 4.7.0-rc1.bart.swiotlb+ uhci_hcd
[    5.240089] usb usb5: Manufacturer: Linux 4.7.0-rc1.bart.swiotlb+ uhci_hcd
[    5.373986] usb usb6: Manufacturer: Linux 4.7.0-rc1.bart.swiotlb+ uhci_hcd
[ 1403.045092] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1403.045095] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1403.075632] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1403.075634] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1404.091624] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1404.091627] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1404.207057] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1404.207060] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1404.673154] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1404.673157] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1414.717610] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1414.779978] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1415.016524] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1415.073408] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1415.143262] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1415.204337] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff


[ 1414.717610] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1414.758355] RHDEBUG: wrap=56 index=56
[ 1414.779978] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1415.016524] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1415.053908] RHDEBUG: wrap=56 index=56
[ 1415.073408] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
[ 1415.143262] mlx5_core 0000:08:00.0: swiotlb buffer is full (sz: 266240 bytes)
[ 1415.183465] RHDEBUG: wrap=56 index=56
[ 1415.204337] RHDEBUG: SWIOTLB_MAP_ERROR ffffffffffffffff
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
