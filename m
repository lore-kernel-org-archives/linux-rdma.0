From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Possible event on cm_id after rdma_accept() fails?
Date: Fri, 6 Jan 2012 12:08:34 -0800
Message-ID: <CAL1RGDVhFP+yESH4pnYPA7co1WkY2HSV7vGB-eM34cgv7Tvpgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

If I get a new cm_id from a RDMA_CM_EVENT_CONNECT_REQUEST
event, and call rdma_accept(), and then rdma_accept() returns an error
for whatever reason, is it safe to assume I won't get any other events
for the cm_id I failed to accept?

ie there's no race where another thread might get a disconnect event
on that cm_id too, right?  So it's safe to just start cleaning up after
I get a failed status from rdma_accept().

Thanks,
 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
