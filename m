From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
Date: Thu, 12 May 2016 13:02:07 -0400 (EDT)
Message-ID: <114005964.35537363.1463072527180.JavaMail.zimbra@redhat.com>
References: <573278D9.4050908@sandisk.com> <57334E35.3010403@sandisk.com> <688520061.35288974.1462980673444.JavaMail.zimbra@redhat.com> <573352B3.4030908@sandisk.com> <1821483712.35493025.1463070514224.JavaMail.zimbra@redhat.com> <2086883286.35494019.1463071093121.JavaMail.zimbra@redhat.com> <1037308880.35509753.1463071803556.JavaMail.zimbra@redhat.com> <5734B6A4.5070205@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5734B6A4.5070205-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Sagi Grimberg"
> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Or Gerlitz" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Sent: Thursday, May 12, 2016 1:00:20 PM
> Subject: Re: [PATCH 4/6] IB/core: Enhance ib_map_mr_sg()
> 
> On 05/12/2016 09:50 AM, Laurence Oberman wrote:
> > Tuning ib_srp and I am back to full 4MB as expected so now we should be all
> > set.
> >
> > Bart, and all, thanks for all the assistance with this.
> > Awesome work Bart on your part as always.
> 
> Hello Laurence,
> 
> Thank you for having tested this patch series so quickly. I assume that
> this means that I can add your Tested-by when I repost this patch series?
> 
> Bart.
> 

Hello Bart

Absolutely.
And in fact now I am running with options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048 and it singing along
I have never reached that before without issues.
Its rock solid from what I can see.
Thanks!!!
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
