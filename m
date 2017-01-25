From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/8] mlx4: Add ability to poll CQs through
 iterator's style API
Date: Wed, 25 Jan 2017 10:15:40 -0700
Message-ID: <20170125171540.GA30733@obsidianresearch.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
 <1485355791-27646-6-git-send-email-yishaih@mellanox.com>
 <20170125170413.GC16579@obsidianresearch.com>
 <20170125171112.GR6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170125171112.GR6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 25, 2017 at 07:11:12PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 25, 2017 at 10:04:13AM -0700, Jason Gunthorpe wrote:

> > Also move all the copies of these into util/compiler.h instead of
> > adding more.
> 
> I tried once :)
> https://www.spinics.net/lists/linux-rdma/msg43086.html

I thought I rememered this had been done..

All things considered, if you are not going to make the ccan debug
facility work, I'd just add the trivial macros to util/compiler.h, the
ccan version has nothing else special about it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
