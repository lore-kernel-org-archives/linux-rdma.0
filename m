From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Tue, 3 May 2016 14:23:57 -0700
Message-ID: <572916ED.5080206@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <571AA5C8.4080502@sandisk.com> <20160502151535.GA520@lst.de>
 <5727A5C7.1090009@sandisk.com> <20160503143104.GA30342@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503143104.GA30342-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/03/2016 07:31 AM, Christoph Hellwig wrote:
>> But running xfstests triggered the following (mlx4
>> hardware; SRP initiator and LIO target running on the same server and
>> communicating over loopback):
>
> I can reproduce this, thanks.  The issue was that my implementation
> of keeping the MRs around when getting an -EAGAIN for setting up new
> RDMA R/W contexts wasn't correct.  To make it properly work we'd need
> a pointer to the send ioctx from the recv ioctx.  I don't feel safe
> to make this change at this point, and given that force_mr is only
> a debug option for the SRP target until RDMA/CM support goes in I
> think we should be fine without it.  I'll resend the series once I
> get feedback from the buildbot, and I'd be happy if you could review
> it quickly.

Thanks for the analysis. I'm fine with this patch series going upstream.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
