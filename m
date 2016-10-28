From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs
 from kernel space
Date: Fri, 28 Oct 2016 08:37:25 -0700
Message-ID: <20161028153725.GA14166@infradead.org>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-8-git-send-email-matanb@mellanox.com>
 <20161028065943.GA10418@infradead.org>
 <20161028151606.GN3617@leon.nu>
 <20161028152138.GA16421@infradead.org>
 <20161028153306.GO3617@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028153306.GO3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 28, 2016 at 06:33:06PM +0300, Leon Romanovsky wrote:
> Just to summarize, to be sure that I understood you correctly.
> 
> ---------    --------------------
> | write | -> | conversion logic | ---
> ---------    --------------------   |      ----------------------
>                                     -----> | internal interface |
> ---------                           |      ----------------------
> | ioctl | ---------------------------
> ---------
> 
> Am I right?

Yes, as long as the write and ioctl boxes do the copy_{from,to}_user.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
