From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: REQ GID enforcement in the CM
Date: Thu, 27 Oct 2011 16:14:07 +0200
Message-ID: <4EA9672F.2010601@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Looking on that case, I noted that the CM code (SB) checks that the GID 
in the incoming
REQ is present in at least of one the ports of the relevant device, but 
not specifically on
the port this request arrived to, is that following IBTA? I thought it 
could be problematic
e.g in the case of RC QP being set by this establishment, later the RC 
packets would be dropped
by the device if they have GRH and the GID isn't on that port table, 
isn't that?

Or.


>     ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
>         if (ret) {
>                 ib_get_cached_gid(work->port->cm_dev->ib_device,
>                                   work->port->port_num, 0, 
> &work->path[0].sgid);
>                 ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
> &work->path[0].sgid, sizeof work->path[0].sgid,
>                                NULL, 0);
>                 goto rejected;
>         }

>  read_lock_irqsave(&cm.device_lock, flags);
>         list_for_each_entry(cm_dev, &cm.device_list, list) {
>                 if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
> &p, NULL)) {
>                         port = cm_dev->port[p-1];
>                         break;
>                 }
>         }
>         read_unlock_irqrestore(&cm.device_lock, flags);
>
>         if (!port)
>                 return -EINVAL;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
