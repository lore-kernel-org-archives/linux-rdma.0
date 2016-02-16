From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining queues
Date: Tue, 16 Feb 2016 13:00:29 +0200
Message-ID: <56C3014D.3070204@dev.mellanox.co.il>
References: <cover.1455230646.git.swise@chelsio.com>
 <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com>
 <56C23DA8.40905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C23DA8.40905-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> As I mentioned in my comment above, I would have thought that the
> attempt to post a send to a QP in ERR state would have returned an
> error.  It must not or else this patch is worthless because of the order
> of actions.  What that highlights though, is that this code will drain a
> QP, but only if the caller has taken the time to stop all possible
> contexts that might run on other cores and post commands to the QP.
> Those commands will error out, but the caller must, none the less, take
> steps to block other contexts from sending or else this drain is
> useless.  That might be fine for the API, but it should be clearly
> documented, and currently it isn't.

I agree, it should be documented that if there are other contexts that
post concurrently then the QP drain is not guaranteed. That's a valid
requirement I think...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
