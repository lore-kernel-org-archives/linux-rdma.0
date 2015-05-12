From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/5] IB/user_mad: Fix bug in ib_umad_remove_one when
 rdma_cap_ib_mad implementation changed
Date: Tue, 12 May 2015 14:42:15 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1107C924@CRSMSX101.amr.corp.intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
 <1431395218-27693-2-git-send-email-ira.weiny@intel.com>,<1828884A29C6694DAF28B7E6B8A82373A8FCE4C5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCE4C5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixed

Patch 5 need to be updated as well.

I'll send a new series today.

Ira

________________________________
From: Hefty, Sean
Sent: Monday, May 11, 2015 7:29:48 PM
To: Weiny, Ira; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Weiny, Ira
Subject: RE: [PATCH 1/5] IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad implementation changed

> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -1327,14 +1327,21 @@ free:
>  static void ib_umad_remove_one(struct ib_device *device)
>  {
>        struct ib_umad_device *umad_dev = ib_get_client_data(device,
> &umad_client);
> -     int i;
> +     int s, e, i;
>
>        if (!umad_dev)
>                return;
>
> -     for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
> +     if (device->node_type == RDMA_NODE_IB_SWITCH)
> +             s = e = 0;
> +     else {

Please use braces on both sides of the else if either side needs it.  I.e. add braces to the if-part.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
