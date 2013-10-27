From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: smatch  warnings on the IB core
Date: Sun, 27 Oct 2013 08:45:25 +0200
Message-ID: <526CB685.40607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Dan,

With the latest smatch I still see these hits on the IB core, basically, 
I would be happy to see the IB stack free from such warnings and then we 
can easily require each new patch not to introduce them... can you shed 
some light on the problem and possible solutions?

> drivers/infiniband/core/user_mad.c:912 ib_umad_sm_open() warn: 
> inconsistent returns sem:&port->sm_sem: locked (908) unlocked (886 
> [(-6)], 912 [s32min-(-1),1-s32max], 912 [(-512)], 912 [(-11)])
>
> drivers/infiniband/core/cma.c:1336 cma_req_handler() warn: 
> inconsistent returns mutex:&listen_id->handler_mutex: locked (1271 
> [(-22)], 1274 [(-103)]) unlocked (1323 [0], 1336 
> [s32min-(-1),1-s32max], 1336 [(-12)])
>
> drivers/infiniband/core/cma.c:1535 iw_conn_req_handler() warn: 
> inconsistent returns mutex:&listen_id->handler_mutex: locked (1463 
> [(-103)]) unlocked (1535 [0], 1535 [s32min-(-1),1-s32max], 1535 
> [s32min-(-1),1-s32max], 1535 [s32min-(-1),1-s32max], 1535 
> [s32min-(-1),1-s32max], 1535 [(-12)])

Sean, if you want to reproduce clone git://repo.or.cz/smatch.git and use 
this command

$ make C=2 CHECK="/patch/to/smatch/smatch_scripts/../smatch 
--project=kernel"  drivers/infiniband/core/ -j 12
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
