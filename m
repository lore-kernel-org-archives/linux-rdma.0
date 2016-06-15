From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Wed, 15 Jun 2016 06:57:59 -0400 (EDT)
Message-ID: <109658870.42286330.1465988279277.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <20160614120833.GO5408@leon.nu> <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com> <20160614131552.GP5408@leon.nu> <1531921470.42169965.1465912634165.JavaMail.zimbra@redhat.com> <1296246237.42197305.1465926035162.JavaMail.zimbra@redhat.com> <1167916510.42202925.1465929678588.JavaMail.zimbra@redhat.com> <a524c577-cfb1-4072-da12-01d0d9ab9c38@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a524c577-cfb1-4072-da12-01d0d9ab9c38-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Wednesday, June 15, 2016 3:40:23 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> On 06/14/2016 08:41 PM, Laurence Oberman wrote:
> > This may be a data point here
> > After each change I have rebooted the host as its required.
> > I am at swiotlb=16 and after the first reboot with maxed out tuning I had
> > no alerts.
> > On the second controller restart without a system reboot I got them again.
> >
> > Again, I never see these other than when I am in  the reconnect loop, and
> > they seem to be non-intrusive as each time I recover fully.
> >
> > When I first changed to 4 and had not increased the ib_srp paramaters I had
> > two restarts with no messages so that was what led me to report that this
> > seems to have worked.
> > I can see now that this was not the case and already mentioned, the claim
> > that the change fixed this was wrong.
> > Apologies for that.
> >
> > I am continuing to research and debug now.
> 
> Hello Laurence,
> 
> In the kernel source tree I found the following:
> 
>  From include/linux/swiotlb.h:
> 
> #define IO_TLB_SHIFT 11
> 
>  From lib/swiotlb.c:
> 
> #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
> [ ... ]
> #define IO_TLB_DEFAULT_SIZE (64UL<<20)
> [ ... ]
> static int __init
> setup_io_tlb_npages(char *str)
> {
> 	if (isdigit(*str)) {
> 		io_tlb_nslabs = simple_strtoul(str, &str, 0);
> 		/* avoid tail segment of size < IO_TLB_SEGSIZE */
> 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> 	}
>          [ ... ]
> }
> early_param("swiotlb", setup_io_tlb_npages);
> [ ... ]
> void  __init
> swiotlb_init(int verbose)
> {
> 	size_t default_size = IO_TLB_DEFAULT_SIZE;
> 	[ ... ]
> 
> 	if (!io_tlb_nslabs) {
> 		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
> 		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> 	}
> 	[ ... ]
> }
> 
> I think this means that the swiotlb parameter has to be set to a value
> above 32768 to increase the number of swiotlb buffers above the default.
> 
> Bart.
> 
> 
> 
Hello Bart

I will try that.
When I looked at the code I saw it being set to 1 as a default, and read the Doc comments as a slab count so figured its an int and would be calculated as n x slabs.
I guess that's another Document update needed for kernel docs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
