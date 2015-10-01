From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 03/18] xprtrdma: Remove completion polling budgets
Date: Thu, 1 Oct 2015 11:13:10 -0600
Message-ID: <20151001171310.GA8428@obsidianresearch.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net>
 <20150917204435.19671.56195.stgit@manet.1015granger.net>
 <CANjDDBgokeHEZ7jWhRKRRU4Usr655zRoYY-qUHc9jeuyjYBzpA@mail.gmail.com>
 <A3B1A836-81AF-40E6-B551-587B7173B72D@oracle.com>
 <55FE8C0F.1050706@dev.mellanox.co.il>
 <CANjDDBjcRXsPFt2Bd+9oL2wTBTxpDsAvN5PZN669dhTC7xSyqw@mail.gmail.com>
 <0804C887-9E32-4257-96D2-6C1FBC9CB271@oracle.com>
 <CANjDDBgB_T9BN7ATTWEJcJScs2JH9bGv5zikUpu_2JJaRYS-Ug@mail.gmail.com>
 <A5EE402A-82CE-49DC-8AB9-63EC340CE8DA@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A5EE402A-82CE-49DC-8AB9-63EC340CE8DA-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2015 at 12:37:36PM -0400, Chuck Lever wrote:

> A missed WC will result in an RPC/RDMA transport deadlock. In
> fact that is the reason for this particular patch (although
> it addresses only one source of missed WCs). So I would like
> to see that there are no windows here.

WCs are never missed.

The issue is a race where re-arming the CQ might not work, meaning you
don't get an event.

You can certainly use arrays with poll_cq. There is no race in the API
here.

But you have to use the IB_CQ_REPORT_MISSED_EVENTS scheme to guarantee
the CQ is actually armed or continue to loop again.

Basically you have to loop until ib_req_notify_cq succeeds.

Any driver that doesn't support this is broken, do we know of any?

while (1) {
  struct ib_wc wcs[100];
  int rc = ib_poll_cq(cw, NELEMS(wcs), wcs);

  .. process rc wcs ..

  if (rc != NELEMS(wcs))
    if (ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
        IB_CQ_REPORT_MISSED_EVENTS) == 0)
     break;
}

API wise, we should probably look at forcing
IB_CQ_REPORT_MISSED_EVENTS on and dropping the flag.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
