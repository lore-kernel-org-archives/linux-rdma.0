From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 1/3] nvme-rdma: don't suppress send completions
Date: Mon, 20 Nov 2017 09:18:09 +0100
Message-ID: <20171120081809.GB27552@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-2-sagi@grimberg.me> <20171109091858.GA16966@lst.de> <921c4331-9456-3783-423a-9c5c5e405131@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <921c4331-9456-3783-423a-9c5c5e405131-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 09, 2017 at 01:08:04PM +0200, Sagi Grimberg wrote:
> Probably only those that support in-capsule data (which I hear
> SRP does too these days).

SRP-2 adds inline data, and Bart's out of tree code has been supporting
that for a long time.

> There is one case I still don't want to signal send completion, thats
> the AEN request. It doesn't have a request structure, and preferred not
> to check on it for every send completion, and its not racing anything
> (mentioned this above).
>
> I can change that though if there is a strong desire.

I don't really like having a special case just for this slow path
special case.  So if we can avoid it without too much overhead let's
do it, otherwise we can keep it as-is.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
