From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 1/3] nvme-rdma: don't suppress send completions
Date: Mon, 20 Nov 2017 10:32:05 +0100
Message-ID: <20171120093205.GB29719@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-2-sagi@grimberg.me> <20171109091858.GA16966@lst.de> <921c4331-9456-3783-423a-9c5c5e405131@grimberg.me> <20171120081809.GB27552@lst.de> <4ac0bc2e-498b-0fc1-4e30-7ff76bd036f1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ac0bc2e-498b-0fc1-4e30-7ff76bd036f1-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 10:33:02AM +0200, Sagi Grimberg wrote:
>> I don't really like having a special case just for this slow path
>> special case.  So if we can avoid it without too much overhead let's
>> do it, otherwise we can keep it as-is.
>
> Saving the state of the request completions adds complication in
> general, and we don't even have a request for AENs so it would mean to
> keep it under the queue, and we don't really race anything because we
> don't have inline data there. So I think its simpler to keep it as is.

Ok, let's keep it.  But please add a comment explaining why the
non-signalled completions are fine for the AER but no one else.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
