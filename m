From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 2/5] Extend create_ah in order to pass L2
 parameters to the provider
Date: Wed, 11 Jun 2014 09:05:41 -0600
Message-ID: <20140611150541.GA21346@obsidianresearch.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <1400405929-14313-3-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <20140521195549.GA26909@obsidianresearch.com>
 <537DBAC3.9090008@mellanox.com>
 <53983580.1080002@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53983580.1080002-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 11, 2014 at 01:54:56PM +0300, Or Gerlitz wrote:

> Can you please address  Matan's comments? we'd like this thread to
> converge...

I am waiting for your analysis as I mentioned in my last message to
this thread:

https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg19925.html

That is rather a larger question, and the answer may well be we don't
need two new extended verbs to do what you want...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
