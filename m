From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 12/47] RDMA/cxgb4: Fix indentation
Date: Fri, 6 Oct 2017 17:10:28 -0500
Message-ID: <01bc01d33eef$eb1eb380$c15c1a80$@opengridcomputing.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com> <20171006213333.6721-13-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-13-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> This patch avoids that smatch reports the following:
> 
> drivers/infiniband/hw/cxgb4/device.c:1105: copy_gl_to_skb_pkt() warn:
> inconsistent indenting
> drivers/infiniband/hw/cxgb4/cm.c:835: send_connect() warn: inconsistent
indenting
> drivers/infiniband/hw/cxgb4/cm.c:841: send_connect() warn: inconsistent
indenting
> drivers/infiniband/hw/cxgb4/cm.c:888: send_connect() warn: inconsistent
indenting
> drivers/infiniband/hw/cxgb4/cm.c:894: send_connect() warn: inconsistent
indenting
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
