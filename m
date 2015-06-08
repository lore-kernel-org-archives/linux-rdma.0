From: "ira. weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 5/6] xprtrdma, svcrdma: Switch to generic logging helpers
Date: Mon, 8 Jun 2015 12:00:17 -0400
Message-ID: <20150608160016.GA24846@phlsvsds.ph.intel.com>
References: <1431945633-18401-1-git-send-email-sagig@mellanox.com> <1431945633-18401-6-git-send-email-sagig@mellanox.com> <20150607060010.GA26768@phlsvsds.ph.intel.com> <55754F08.7000201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55754F08.7000201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 11:15:04AM +0300, Sagi Grimberg wrote:
> On 6/7/2015 9:00 AM, ira.weiny wrote:
> >>@@ -201,9 +202,10 @@ static void qp_event_handler(struct ib_event *event, 
> >>void *context)
> >>  	case IB_EVENT_QP_ACCESS_ERR:
> >>  	case IB_EVENT_DEVICE_FATAL:
> >>  	default:
> >>-		dprintk("svcrdma: QP ERROR event %d received for QP=%p, "
> >>+		dprintk("svcrdma: QP ERROR event %s (%d) received for QP=%p, 
> >>"
> >>  			"closing transport\n",
> >
> >
> >Generally it is recommended to keep strings on a single line for easier
> >grepping of the code.
> >
> >"However, never break user-visible strings such as printk messages, because
> >that breaks the ability to grep for them."
> 
> Hey Ira,
> 
> Note that this patch did not cause the line split so I prefer that this
> nit will be addressed in a later patch (along with the rest of the
> file/module).

I am ok with that.

Ira

> 
> Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
