From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 8/8] IB/srp and direct IO: patches for testing large indirect
 tables
Date: Thu, 20 Jan 2011 12:07:07 +0200
Message-ID: <4D38094B.9090101@voltaire.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov> <1295411242-26148-9-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295411242-26148-9-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> Fix direct IO when doing more than 1 MB IOs -- proper patch to fix is
> floating in the ether as well, now landed in Andrew Morton's tree.

So what was the behavior without this patch? also can you send pointer
to that tree and mailing list this patch was submitted, I'd like to follow
on the discussion there, thanks,

Or.

> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -583,6 +583,7 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
>  		goto out;
>  	sector = start_sector << (dio->blkbits - 9);
>  	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
> +	nr_pages = min(nr_pages, BIO_MAX_PAGES);
>  	BUG_ON(nr_pages <= 0);
>  	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
>  	dio->boundary = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
