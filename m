From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Tue, 14 Jun 2016 11:24:28 +0200
Message-ID: <11e680c4-84b3-1cd6-133c-36f71bd853d0@sandisk.com>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com>
 <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com>
 <20160613140747.GL5408@leon.nu>
 <946373818.41993264.1465827597452.JavaMail.zimbra@redhat.com>
 <887623939.42004497.1465831339845.JavaMail.zimbra@redhat.com>
 <450384210.42057823.1465857004662.JavaMail.zimbra@redhat.com>
 <1964187258.42093298.1465869387551.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1964187258.42093298.1465869387551.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/14/2016 03:56 AM, Laurence Oberman wrote:
> Tracing [ ... ]

Hello Laurence,

Can you try to set the kernel command line parameter swiotlb to a value 
that is a multiple of its default (64MB), reboot and see whether that 
helps? See also Documentation/kernel-parameters.txt in the kernel tree.

Thanks,

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
