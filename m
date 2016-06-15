From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Wed, 15 Jun 2016 14:51:18 +0200
Message-ID: <cb6f8f42-1f4f-cf9d-42d0-12ba5e90ab86@sandisk.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com>
 <fe7c9713-2864-7b6c-53ec-f5d1364d65d8@sandisk.com>
 <20160614131552.GP5408@leon.nu>
 <1531921470.42169965.1465912634165.JavaMail.zimbra@redhat.com>
 <1296246237.42197305.1465926035162.JavaMail.zimbra@redhat.com>
 <1167916510.42202925.1465929678588.JavaMail.zimbra@redhat.com>
 <a524c577-cfb1-4072-da12-01d0d9ab9c38@sandisk.com>
 <109658870.42286330.1465988279277.JavaMail.zimbra@redhat.com>
 <794983323.42297890.1465992133003.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <794983323.42297890.1465992133003.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/15/2016 02:02 PM, Laurence Oberman wrote:
> We are missing something here

The source code excerpts in my previous e-mail came from the latest 
Linux kernel (v4.7-rc3). Maybe older kernels behave in a different way.

BTW, did you run into the "swiotlb buffer is full" error messages while 
testing 4MB I/O? Have you already considered to reduce the memory that 
is needed for RDMA queues by reducing the queue depth? I ran my SRP 
tests with default swiotlb buffer size and with the following in 
srp_daemon.conf:

a queue_size=32,max_cmd_per_lun=32,max_sect=8192

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
