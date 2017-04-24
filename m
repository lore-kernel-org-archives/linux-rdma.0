From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 3/4] nvme: enable SG gaps support
Date: Mon, 24 Apr 2017 09:02:10 +0200
Message-ID: <20170424070210.GA8719@lst.de>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com> <1492098977-5231-4-git-send-email-maxg@mellanox.com> <2bd673ee-8455-32b7-1bad-34fa9eebb076@grimberg.me> <20170421064427.GB6095@lst.de> <9ff1a2e8-f84f-c772-e294-2339eee8e37d@grimberg.me> <20170423084553.GA24434@lst.de> <9fe3f5fa-4496-3819-0288-08a073dd1a1a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9fe3f5fa-4496-3819-0288-08a073dd1a1a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 23, 2017 at 12:45:39PM +0300, Sagi Grimberg wrote:
>> still would fit NVMe dword-alignment SGLs, though :)
>
> I would say its useful to have, but its only relevant to ioctls as
> normal io we explicitly on sub logical block size alignment.
>
> Anyways, I still think having ctrl->virt_boundary instead of
> ctrl->sg_gap_support is cleaner...

Ok, fine with me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
