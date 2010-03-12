From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: infiniband RDMA connection to server is rejected when client reboot
Date: Fri, 12 Mar 2010 08:47:15 -0800
Message-ID: <0D783A5934AD43FFAC5655D1FE23BA47@amr.corp.intel.com>
References: <MAILDRomQlDT6VxqM8E0004c9d0@mail.langchao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MAILDRomQlDT6VxqM8E0004c9d0-hsiVscFSYOJrXVYLWy1CrgC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?gb2312?B?J9HuvfC41Sc=?= <yangjg-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>    server:  rdma_create_id=A3=ACrdma_bind_addr=A3=AC rdma_listen(cb->=
cm_id, 3);
>Then  the  client connects the  server, the  connection is sucessful. =
Then
>nothing is done on the server but  the client is rebooted . After the =
client
>starts, it  connnets the server again. Errors come here. Sometime this
>connnection can be successful, and fails othertime. When it fails,the =
client
>receives RDMA_CM_EVENT_REJECTED event,and the server does't received
>RDMA_CM_EVENT_CONNECT_REQUEST event as the successful connection.
>I don't how this happens.Can someone help me ?Thanks!

The server side may be rejecting the connection request as a duplicate.=
  The
event.status may provide some additional insight.  It should contain on=
e of the
enum ib_cm_rej_reason values given in ib_cm.h (assuming that you're usi=
ng IB and
not iWarp).  If the status is 'IB_CM_REJ_STALE_CONN' (=3D 10), then ret=
rying the
connection with a new QP may succeed.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
