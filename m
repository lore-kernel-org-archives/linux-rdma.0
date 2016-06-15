From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Wed, 15 Jun 2016 19:05:40 -0400 (EDT)
Message-ID: <1525975255.42437742.1466031940651.JavaMail.zimbra@redhat.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com> <1167916510.42202925.1465929678588.JavaMail.zimbra@redhat.com> <a524c577-cfb1-4072-da12-01d0d9ab9c38@sandisk.com> <109658870.42286330.1465988279277.JavaMail.zimbra@redhat.com> <794983323.42297890.1465992133003.JavaMail.zimbra@redhat.com> <cb6f8f42-1f4f-cf9d-42d0-12ba5e90ab86@sandisk.com> <1925675172.42312868.1465996772507.JavaMail.zimbra@redhat.com> <868111008.42313561.1465997038399.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <868111008.42313561.1465997038399.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Wednesday, June 15, 2016 9:23:58 AM
> Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in swiotlb_alloc_coherent()
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Wednesday, June 15, 2016 9:19:32 AM
> > Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
> > swiotlb_alloc_coherent()
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Yishai Hadas" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
> > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Sent: Wednesday, June 15, 2016 8:51:18 AM
> > > Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
> > > swiotlb_alloc_coherent()
> > > 
> > > On 06/15/2016 02:02 PM, Laurence Oberman wrote:
> > > > We are missing something here
> > > 
> > > The source code excerpts in my previous e-mail came from the latest
> > > Linux kernel (v4.7-rc3). Maybe older kernels behave in a different way.
> > > 
> > > BTW, did you run into the "swiotlb buffer is full" error messages while
> > > testing 4MB I/O? Have you already considered to reduce the memory that
> > > is needed for RDMA queues by reducing the queue depth? I ran my SRP
> > > tests with default swiotlb buffer size and with the following in
> > > srp_daemon.conf:
> > > 
> > > a queue_size=32,max_cmd_per_lun=32,max_sect=8192
> > > 
> > > Bart.
> > > 
> > 
> > Hi Bart
> > 
> > All my testing here has been 4MB I/O while restarting controllers.
> > This is a customer requirement to be doing large sequential 4MB, buffered
> > and
> > O_DIRECT.
> > 
> > I have 128, but will reduce to 32 and test it.
> > 
> > My config is as follows per customer requirements.
> > 
> > [root@jumptest1 ~]# cat /etc/ddn/srp_daemon.conf
> > a      queue_size=128,max_cmd_per_lun=128,max_sect=8192
> > 
> > Interestingly, I have absolutely no issue with ib_srp and testing all types
> > of I/O on this very large array.
> > Its rock solid upstream now since all the fixes we have now in ib_srp.
> > 
> > The swiotlb seems, as already mentioned, to be only in reconnects and does
> > NOT affect behavior of regular I/O.
> > 
> > I will make this observation in the patch I will be sending for ib_srp*
> > Documentation
> > 
> > Thanks!!
> > Laurence
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Hi Bart,
> 
> I should add that it does not even affect the reconnects, they increment each
> time until the SM sees the controller come back and the controller is ready
> to receive the reconnects.
> All paths are successfully recovered.
> 
> I am thinking we should remove the dump_stack and leave the message in as a
> warning
> Customers seeing messages as warnings will be less concerend than seeing
> kernel stack dumps.
> 
> Let me know if you want me to submit a patch for that.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Bart

Confirming reducing queue_depth max to 32 prevents the swiotlb errors.

I will document this

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
