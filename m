From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible use-after-free
Date: Tue, 11 Aug 2015 10:01:49 +0300
Message-ID: <55C99DDD.3080308@dev.mellanox.co.il>
References: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
 <55C8BB38.1060808@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55C8BB38.1060808-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> With which kernel version has this been observed ?

This was actually observed in RHEL 7.1 kernel (I think). But given its
not easy to reproduce and the same code path exists in upstream, I
thought I'd send it to you for review.

> scsi_remove_host() waits until all outstanding requests have finished. srp_free_ch_ib() is
> called either before a SCSI host is registered with the SCSI core or
> after scsi_remove_host() has finished. So I don't see how the above call
> trace could be triggered with a recent kernel ?

If this is the case, then I don't see any justification for having
srp_destroy_qp at all...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
