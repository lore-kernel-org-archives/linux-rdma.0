From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-rdma] IB/mlx5: Allow mapping the free running counter
 on PROT_EXEC
Date: Thu, 14 Apr 2016 07:29:21 -0700
Message-ID: <20160414142921.GA31641@infradead.org>
References: <1460641930-5118-1-git-send-email-matanb@mellanox.com>
 <20160414135651.GA18711@infradead.org>
 <570FA3B6.20301@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570FA3B6.20301-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 05:05:42PM +0300, Matan Barak (External) wrote:
> On 14/04/2016 16:56, Christoph Hellwig wrote:
> >And why the hack do we set PROT_EXEC on a mapping of device resources?
> >
> 
> Of course we don't (there's no good reason to do that).
> However, as written in the commit message, when READ_IMPLIES_EXEC is set in
> current->personality (mm/mmap.c):
> 
> if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
> 	if (!(file && path_noexec(&file->f_path)))
> 		prot |= PROT_EXEC;
> 
> So, we don't want to fail in these cases.

Uh, ok - that's nasty.  I somehow only remembered and exec implies read
in x86.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
