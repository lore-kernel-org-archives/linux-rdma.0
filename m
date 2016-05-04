From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Wed, 4 May 2016 09:17:03 -0700
Message-ID: <572A207F.6030307@sandisk.com>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
 <20160503093307.GL19931@lst.de> <5729147C.5000904@sandisk.com>
 <20160504090908.GA14787@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504090908.GA14787-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/04/2016 02:09 AM, Christoph Hellwig wrote:
> Either way, limited hardware on the initiator side is
> something totally normal that happens all the time especially with
> SCSI HBAs, so I'd prefer to not spew a warning about it.

OK, I will change the shost_printk() into a pr_debug(). That will ensure 
that this message doesn't show up in the system log without enabling 
that message explicitly through configfs.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
