From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Tue, 25 Oct 2016 13:42:44 +0800
Message-ID: <580EF0D4.9050209@huawei.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

在 2016/10/20 0:18, Leon Romanovsky 写道:
> Hi All,
> 
> I want to remind you that latest kernel is exposing different vendor
> specific structures (include/uapi/rdma/*-abi.,h) and new coming user
> space drivers should use these headers directly and not copy/paste the
> code from them.
> 
> In the future, we will convert already accepted drivers too.
> 
> Thanks
> 
> .
> 
Hi, Leon
  I am preparing for the userspace library of hns and have learned your email.
I have the same question with Jason Gunthorpe. Meanwhile, the new provider qedr don't
do this.
  I think that your plan will have a more clever discussion coming forward. In order to
not be blocked, I will don't something more until it is a step closer. After that, i
will fix it seraparete separately.

thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
