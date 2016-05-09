From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Mon, 9 May 2016 18:50:06 -0400 (EDT)
Message-ID: <169904890.34764265.1462834206901.JavaMail.zimbra@redhat.com>
References: <571A936F.7040409@sandisk.com> <2102017158.34060891.1462478304470.JavaMail.zimbra@redhat.com> <572BA98F.4090109@sandisk.com> <572BAA6F.1060607@sandisk.com> <804753248.34153510.1462481756460.JavaMail.zimbra@redhat.com> <572BBDC0.5070205@sandisk.com> <1133135399.34245490.1462485666601.JavaMail.zimbra@redhat.com> <572BCD59.7010701@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <572BCD59.7010701-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, May 5, 2016 6:46:49 PM
> Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
> 
> On 05/05/2016 03:01 PM, Laurence Oberman wrote:
> > Yep, something has changed upstream here to bring this out.
> 
> I will modify the SRP initiator such that more mr's are allocated if
> max_sectors > max_sectors_per_mr. That should allow 4 MB I/O even with
> mlx4 and fast registration and without the risk of encountering a
> mapping failure.
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Bart

I spent the weekend testing the RHEL6 kernel + Mellanox Ofed. Its rock solid.

On both the latest upstream and the RHEL7.2 kernel we have mapping failures with 4MB max_sector_kb sizes.

In addition the latest RHEL 7.2 kernel + Mellanox Ofed sees the same mapping issues.
This seems to suggest its not confined to only code changes Mellanox has in Ofed ib_srp drivers

Are we looking at a combination of kernel changes and ib_srp changes here to correct this.
Or do you think this will be resolved in the end by just changes to the ib_srp driver code.

If there is any other data you want me to capture or debug please do let me know.

I have started investigating the full flow of I/O from the upper layers through the kernel to the ib_srp layer to see what is different in RHEL6 and why this 
issue is not apparent.

Thanks as always for your assistance here.

Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
