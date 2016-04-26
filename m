From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Wed, 27 Apr 2016 00:04:52 +0300
Message-ID: <571FD7F4.4090006@grimberg.me>
References: <571A936F.7040409@sandisk.com> <571A9472.5050202@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571A9472.5050202-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Avoid that running xfstests on top of the SRP initiator triggers
> the call trace below. This patch has been tested by running the
> following shell command on an initiator system that has access
> to 3200 SRP LUNs:

That's good to know, but the patch description needs to state where
the NULL deref originates i.e. when can req be NULL and why it is
OK to just assign to NULL and continue...

>   		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
>   		if (scmnd) {
>   			req = (void *)scmnd->host_scribble;
> -			scmnd = srp_claim_req(ch, req, NULL, scmnd);
> +			scmnd = req ? srp_claim_req(ch, req, NULL, scmnd) :
> +				NULL;
>   		}
>   		if (!scmnd) {
>   			shost_printk(KERN_ERR, target->scsi_host,
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
