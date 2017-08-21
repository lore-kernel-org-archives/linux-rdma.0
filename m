From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/1] RDMA/uverbs: Initialize cq_context appropriately
Date: Mon, 21 Aug 2017 14:11:39 -0500
Message-ID: <01cb01d31ab1$51458340$f3d089c0$@opengridcomputing.com>
References: <1501565315-3183-1-git-send-email-bharat@chelsio.com>         <CAAKD3BCdeG=FkUNQjqGxEYw5Sx-TtmeRSAA8K7M43G62Qw_gbw@mail.gmail.com> <1503079603.2598.33.camel@redhat.com> <008701d31863$c83d3600$58b7a200$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008701d31863$c83d3600$58b7a200$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ping...

> 
> >
> > I agree, I like your solution better.  Patch fixed up and applied.
> >
> 
> Hey Doug, I see this in your -next branch, but it needs to hit 4.13-rc and stable, as it
> is a fatal regression that breaks user mode rdma applications.
> 
> Thanks,
> 
> Steve.
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
