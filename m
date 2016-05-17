From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 1/1] IB/mlx4: Unaligned access in send_reply_to_slave
Date: Tue, 17 May 2016 11:07:33 -0600
Message-ID: <20160517170733.GD19976@obsidianresearch.com>
References: <1463462198-15674-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20160517073940.GF4662@leon.nu>
 <20160517083710.GA14673@shamir-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160517083710.GA14673-wNzywhU3BCWJbeQQAEUYZUB3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 17, 2016 at 11:37:11AM +0300, Shamir Rabinovitch wrote:

> Comments are more then welcome..

Something like this should fix it with less overhead:

struct ib_sa_mcmember_data {
[..]
} __packed __aligned(4);

Which tells the compiler the structure is only aligned on dword
boundaries. It will then emit the proper architecture dependent
unaligned read for the 8 byte values.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
