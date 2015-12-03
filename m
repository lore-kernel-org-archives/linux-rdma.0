From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 5/6] IB core: Fix ib_sg_to_pages()
Date: Thu, 3 Dec 2015 11:07:48 +0200
Message-ID: <56600664.1010200@dev.mellanox.co.il>
References: <565DE3EC.2070002@sandisk.com> <565DE49D.4020102@sandisk.com>
 <565DE7D0.4080408@dev.mellanox.co.il> <565DF0A5.6040102@sandisk.com>
 <565EBA78.3050201@dev.mellanox.co.il> <565FA75E.7010100@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565FA75E.7010100-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hello Sagi,
>
> Hmm ... why would it be unacceptable to return 0 if sg_nents == 0 ?
>
> Regarding which component to modify if mapping the first page fails:
> for almost every kernel function I know a negative return value means
> failure and a return value >= 0 means success. Hence my proposal to
> change the return value of the ib_map_mr_sg() function if mapping the
> first page fails.

I'm fine with that.

>
> How about the patch below ?

Looks fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
