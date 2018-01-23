From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Tue, 23 Jan 2018 10:31:24 -0600
Message-ID: <00fd01d39467$9bdde7f0$d399b7d0$@opengridcomputing.com>
References: <20180114223603.19961-1-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180114223603.19961-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> This patch set contributes a new version of the SoftiWarp
> driver, as originally introduced Oct 6th, 2017.
> 
> Thank you all for the commments on my last submissiom. It
> was vey helpful and encouraging. I hereby re-send a SoftiWarp
> patch after taking all comments into account, I hope. Without
> introducing SoftiWarp (siw) again, let me fast forward
> to the changes made to the last submission:
> 
> 
> 1. Removed all kernel module parameters, as requested.
>    I am not completely happy yet with what came out of
>    that, since parameters like the name of interfaces
>    siw shall attach to,

Can configfs be used for this? I don't remember if that was discussed during
v2 review?  OR, the new rdma command that is part of iproute2 can be
extended.  It would use netlink messages to do the configuration.  Perhaps
Leon can comment on that when he gets time.  It could be extended to support
both rxe and siw.

> or if we want to use TCP_NODELAY
>    for low ping-pong delay, or disable it for higher
>    message rates for multiple outstanding operations,
>    were quite handy. I understand I have to find a better
>    solution for that. Ideally, we would be able to
>    distinguish between global siw driver control (like
>    interfaces it attaches to), and per-QP parameters
>    (somehow similar to socket options) which allow for
>    example to tune delay, setting CRC on/off, or control
>    GSO usage.
> 

Per connection settings could be done by extending the rdma_cm API.  See
rdma_set_option() in librdmacm from rdma-core, and kernel rdmacm API
functions like rdma_set_service_type() and rdma_set_reuseaddr().  We really
need the TCP options to be tweakable for iwarp cm_ids...


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
