From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: 4.5-rc iser issues
Date: Sun, 14 Feb 2016 07:22:23 -0800
Message-ID: <20160214152223.GA5323@infradead.org>
References: <20160214074119.GA24558@infradead.org>
 <56C04294.3090701@dev.mellanox.co.il>
 <56C05000.1040001@dev.mellanox.co.il>
 <56C066AF.6050901@dev.mellanox.co.il>
 <56C088EA.1050901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56C088EA.1050901-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lin-SSI <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding Ming to Cc.

But I don't think simply not cloning the biovecs is the right thing
to do in the end.  This must be something with the bvec iterators.

Full quote for Ming:

On Sun, Feb 14, 2016 at 04:02:18PM +0200, Sagi Grimberg wrote:
> 
> >>I'm bisecting now, there are a couple of patches from Ming in
> >>the area of the bio splitting code...
> >>
> >>CC'ing Ming, Linux-block and Linux-nvme as iser is identical to nvme
> >>wrt the virtual boundary so I think nvme will break as well.
> >
> >Bisection reveals that this one is the culprit:
> >
> >commit 52cc6eead9095e2faf2ec7afc013aa3af1f01ac5
> >Author: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >Date:   Thu Sep 17 09:58:38 2015 -0600
> >
> >     block: blk-merge: fast-clone bio when splitting rw bios
> >
> >     biovecs has become immutable since v3.13, so it isn't necessary
> >     to allocate biovecs for the new cloned bios, then we can save
> >     one extra biovecs allocation/copy, and the allocation is often
> >     not fixed-length and a bit more expensive.
> >
> >     For example, if the 'max_sectors_kb' of null blk's queue is set
> >     as 16(32 sectors) via sysfs just for making more splits, this patch
> >     can increase throught about ~70% in the sequential read test over
> >     null_blk(direct io, bs: 1M).
> >
> >     Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> >     Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >     Cc: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
> >     Cc: Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>
> >     Signed-off-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> >
> >     This fixes a performance regression introduced by commit 54efd50bfd,
> >     and allows us to take full advantage of the fact that we have
> >immutable
> >     bio_vecs. Hand applied, as it rejected violently with commit
> >     5014c311baa2.
> >
> >     Signed-off-by: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
> >--
> 
> Looks like there is a problem with bio_clone_fast()
> 
> This change makes the problem go away:
> --
> diff --git a/block/bio.c b/block/bio.c
> index dbabd48..5e93733 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1791,7 +1791,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
>          * Discards need a mutable bio_vec to accommodate the payload
>          * required by the DSM TRIM and UNMAP commands.
>          */
> -       if (bio->bi_rw & REQ_DISCARD)
> +       if (1 || bio->bi_rw & REQ_DISCARD)
>                 split = bio_clone_bioset(bio, gfp, bs);
>         else
>                 split = bio_clone_fast(bio, gfp, bs);
> --
> 
> Any thoughts?
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
