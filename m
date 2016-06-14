From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Tue, 14 Jun 2016 09:57:14 -0400 (EDT)
Message-ID: <1531921470.42169965.1465912634165.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <887623939.42004497.1465831339845.JavaMail.zimbra@redhat.com> <450384210.42057823.1465857004662.JavaMail.zimbra@redhat.com> <1964187258.42093298.1465869387551.JavaMail.zimbra@redhat.com> <11e680c4-84b3-1cd6-133c-36f71bd853d0@sandisk.com> <20160614120833.GO5408@leon.nu> <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com> <20160614131552.GP5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160614131552.GP5408-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, June 14, 2016 9:15:52 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> On Tue, Jun 14, 2016 at 02:25:15PM +0200, Bart Van Assche wrote:
> > On 06/14/2016 02:08 PM, Leon Romanovsky wrote:
> > >On Tue, Jun 14, 2016 at 11:24:28AM +0200, Bart Van Assche wrote:
> > >>On 06/14/2016 03:56 AM, Laurence Oberman wrote:
> > >>>Tracing [ ... ]
> > >>
> > >>Can you try to set the kernel command line parameter swiotlb to a value
> > >>that
> > >>is a multiple of its default (64MB), reboot and see whether that helps?
> > >>See
> > >>also Documentation/kernel-parameters.txt in the kernel tree.
> > >
> > >Do you think that 64MB is not enough for this scenario?
> > 
> > Hello Leon,
> > 
> > Does this mean that you think that the "swiotlb buffer is full" messages
> > reported by Laurence could be caused by something else than hitting the
> > swiotlb limit?
> 
> I don't have enough knowledge in that area to answer if message "swiotlb
> buffer is full" is correctly explain current situation and I will be
> glad to get input from you about it.
> 
> Thanks.
> 
> > 
> > Bart.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hello Bart and Leon

Set to swiotlb=4, I no longer have the swiotlb issue. 
Its no longer taking the error path so I confirm that increasing the swiotlb slab count solves this issue.

BOOT_IMAGE=/vmlinuz-4.7.0-rc1.bart.swiotlb+ root=/dev/mapper/rhel-root ro crashkernel=auto rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap console=ttyS1,115200n8 scsi_mod.use_blk_mq=1 swiotlb=4

I am in the process of preparing a Doc patch for IB/srp and IB/srpt where I have captured all the tuning work I have done with Bart.
I will add this to the Doc patch priot to sending it.

Many Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
