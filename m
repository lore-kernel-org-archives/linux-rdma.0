From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: smatch  warnings on the IB core
Date: Mon, 28 Oct 2013 16:32:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF16CC@ORSMSX109.amr.corp.intel.com>
References: <526CB685.40607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526CB685.40607-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > drivers/infiniband/core/cma.c:1336 cma_req_handler() warn:
> > inconsistent returns mutex:&listen_id->handler_mutex: locked (1271
> > [(-22)], 1274 [(-103)]) unlocked (1323 [0], 1336
> > [s32min-(-1),1-s32max], 1336 [(-12)])
> >
> > drivers/infiniband/core/cma.c:1535 iw_conn_req_handler() warn:
> > inconsistent returns mutex:&listen_id->handler_mutex: locked (1463
> > [(-103)]) unlocked (1535 [0], 1535 [s32min-(-1),1-s32max], 1535
> > [s32min-(-1),1-s32max], 1535 [s32min-(-1),1-s32max], 1535
> > [s32min-(-1),1-s32max], 1535 [(-12)])

Visually inspecting the code for both of these, I don't see anything wrong.  In both cases the listen mutex is acquired near the top of the function and released at the end.  I don't see how you exit either function with the mutex locked.

In the top case, line 1271 is a return statement that occurs before we've acquired the mutex.  Line 1274 is an abort case where we acquire the mutex, check a state, release the mutex, and return.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
