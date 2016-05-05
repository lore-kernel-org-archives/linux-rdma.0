From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Thu, 5 May 2016 14:40:16 -0700
Message-ID: <572BBDC0.5070205@sandisk.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
 <20160503093307.GL19931@lst.de> <572A8975.9060606@sandisk.com>
 <20160505140616.GA15000@lst.de>
 <2102017158.34060891.1462478304470.JavaMail.zimbra@redhat.com>
 <572BA98F.4090109@sandisk.com> <572BAA6F.1060607@sandisk.com>
 <804753248.34153510.1462481756460.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <804753248.34153510.1462481756460.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/05/2016 01:56 PM, Laurence Oberman wrote:
> Set at 1025, rebuilt ib_srp module, rebooted client and:
>
> Still get:
>
> [root@srptest ~]# dmesg | grep Reducing
> [  227.076550] scsi host4: ib_srp: Reducing max_sectors from 8192 to 4080
> [  235.316995] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
> [  245.726223] scsi host5: ib_srp: Reducing max_sectors from 8192 to 4080
> [  253.197573] scsi host6: ib_srp: Reducing max_sectors from 8192 to 4080
>
> And then of course we are constrained

Sorry. I forgot that the maximum FR page list length for mlx4 is 511. I 
will come up with another solution.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
