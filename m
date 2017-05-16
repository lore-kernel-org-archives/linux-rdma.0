From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 16 May 2017 07:42:56 +0200
Message-ID: <20170516054256.GA4013@lst.de>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net> <20170515145757.GI3616@mtr-leonro.local> <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com> <20170515170021.GJ3616@mtr-leonro.local> <AE3152CC-B7C8-4C51-ADDE-C3822533BB94@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AE3152CC-B7C8-4C51-ADDE-C3822533BB94-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 15, 2017 at 01:22:59PM -0400, Chuck Lever wrote:
> In this case, the module parameter is global: one has to take
> some care when there are multiple HCAs in a system and they
> each have different MEMMGT capabilities. Instead of removing
> the setting altogether, one might replace it with a driver-
> mediated per-device-port attribute.
> 
> I will let Sagi and Christoph have the last word.

I think I only added it on requests from someone (you?), and when
writing the code debugged it by manually forcing it to on.  Thay
being said a module parameter is entirely trivial and thus I'm fine
with it.  Think like debugfs or per-device setting for such a trivial
debug tool have just way to much boilerplate code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
