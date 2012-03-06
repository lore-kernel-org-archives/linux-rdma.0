From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: mlx4 verbs question
Date: Mon, 5 Mar 2012 21:44:30 -0600
Message-ID: <006501ccfb4b$703c49e0$50b4dda0$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

It has been a long time since I looked at this but I was looking at
ibv_modify_qp on an mlx4 system.
I noticed the following which seems incorrect to me.

>From the RTS state issuing a modify qp with qp_attr_mask only set to state
to the SQD state
Returns qp_attr with qp_state = SQD but if you then issue ibv_query_qp the
state is reported as RTS.
No amount of waiting seems to change this. According to the IBA spec this
should just work without anything special required.

Also for what it's worth most of the errors returned from mlx4 these days
are EXXX e.g. EINVAL.
An exception is the failure of a mailbox command which returns the error
value in the command context i.e. 1.
It would seem better to be consistent in style.

Bob Pearson

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
