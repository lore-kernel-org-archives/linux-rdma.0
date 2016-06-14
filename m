From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Tue, 14 Jun 2016 09:10:22 -0400 (EDT)
Message-ID: <863757614.42161496.1465909822899.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <946373818.41993264.1465827597452.JavaMail.zimbra@redhat.com> <887623939.42004497.1465831339845.JavaMail.zimbra@redhat.com> <450384210.42057823.1465857004662.JavaMail.zimbra@redhat.com> <1964187258.42093298.1465869387551.JavaMail.zimbra@redhat.com> <11e680c4-84b3-1cd6-133c-36f71bd853d0@sandisk.com> <20160614120833.GO5408@leon.nu> <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe7c9713-2864-7b6c-53ec-f5d1364d65d8-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, June 14, 2016 8:25:15 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> On 06/14/2016 02:08 PM, Leon Romanovsky wrote:
> > On Tue, Jun 14, 2016 at 11:24:28AM +0200, Bart Van Assche wrote:
> >> On 06/14/2016 03:56 AM, Laurence Oberman wrote:
> >>> Tracing [ ... ]
> >>
> >> Can you try to set the kernel command line parameter swiotlb to a value
> >> that
> >> is a multiple of its default (64MB), reboot and see whether that helps?
> >> See
> >> also Documentation/kernel-parameters.txt in the kernel tree.
> >
> > Do you think that 64MB is not enough for this scenario?
> 
> Hello Leon,
> 
> Does this mean that you think that the "swiotlb buffer is full" messages
> reported by Laurence could be caused by something else than hitting the
> swiotlb limit?
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Trying this today and will report back.
Its interesting to me that I am burying this host in I/O testing, both reads and writes and never have issues with the swiotlb space.
Its only on the reconnect that this happens when I test the path loss and controller reboots.

Back later with results of the tuning of the swiotlb buffers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
