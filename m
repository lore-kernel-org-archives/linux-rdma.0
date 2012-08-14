From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Setting service level for a QP with ibv_modify_qp and RDMA_CM
Date: Tue, 14 Aug 2012 16:16:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A89097@ORSMSX101.amr.corp.intel.com>
References: <502A19D5.70007@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502A19D5.70007-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Mohrbacher <christian.mohrbacher-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> we are trying to set the service level for a QP with ibv_modify_qp, but
> ibv_modify_qp() returns an error (errno = EINVAL).
> 
> We are using RDMA CM and use rdma_create_qp() to allocate the queue
> pair. After some searching in the net we found posts, which indicate
> that ibv_modify_qp() cannot be used to set the service level, if you are
> using RDMA CM. Can anybody confirm or negate this assumption and are
> there alternatives?

If you're using the rdmacm, you should avoid calling ibv_modify_qp directly.  The library will call it on your behalf.  The service level will be set automatically when the required path record is obtained.  You have a couple of options for controlling this.

An IP address is mapped to an IB GID and PKey.  You can assign different service levels based on different PKeys.

Quality/type of service can also be set by calling rdma_set_option, using RDMA_OPTION_ID_TOS.  This value ends up being used in a path record query to the SA.

In both cases, the SA must be configured with the QoS values.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
