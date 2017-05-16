From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 16 May 2017 10:22:12 +0300
Message-ID: <d46b0a41-92c2-2ce2-5cf2-ac5c6c3811cd@grimberg.me>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net>
 <20170515145757.GI3616@mtr-leonro.local>
 <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com>
 <20170515170021.GJ3616@mtr-leonro.local>
 <AE3152CC-B7C8-4C51-ADDE-C3822533BB94@oracle.com>
 <20170516054256.GA4013@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170516054256.GA4013-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I think I only added it on requests from someone (you?), and when
> writing the code debugged it by manually forcing it to on.  Thay
> being said a module parameter is entirely trivial and thus I'm fine
> with it.  Think like debugfs or per-device setting for such a trivial
> debug tool have just way to much boilerplate code.

I tend to agree. It's a very simple knob, can't imagine why we'd want it
to be per-device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
