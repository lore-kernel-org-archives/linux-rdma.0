From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] SRP initiator fixes for kernel v4.7
Date: Fri, 3 Jun 2016 14:58:11 -0400 (EDT)
Message-ID: <178183518.40193929.1464980291652.JavaMail.zimbra@redhat.com>
References: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
> "Mike Marciniszyn" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Friday, June 3, 2016 2:38:57 PM
> Subject: [PATCH 0/2] SRP initiator fixes for kernel v4.7
> 
> Hello Doug,
> 
> It would be appreciated if you could apply the two patches in this
> series at your earliest convenience. These patches are what I came up
> with while testing the SRP initiator in kernel v4.7-rc1. The names of
> these patches are as follows:
> 
> 0001-IB-srp-Always-initialize-use_fast_reg-and-use_fmr.patch
> 0002-IB-srp-Fix-srp_map_sg_dma.patch
> 
> Thanks,
> 
> Bart.
> 

I will pull and test this weekend.

Thanks!!
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
