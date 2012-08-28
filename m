From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_modify_qp to IBV_QPS_ERR returns EAGAIN
Date: Tue, 28 Aug 2012 18:14:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8B65C@ORSMSX101.amr.corp.intel.com>
References: <CALfB72A42UaUpxu+s_Cnr2P77CBN2=+bys-vBxF5W94bah5cVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72A42UaUpxu+s_Cnr2P77CBN2=+bys-vBxF5W94bah5cVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I was wondering if anyone could shed some light about what kind
> conditions might cause ibv_modify_qp to IBV_QPS_ERR to return EAGAIN?
> 
> The error occurred on a QP that probably already had some work
> completions for requests that failed. I've only seen it happen once in
> about 3 months, so reproducing is quite hard.

Did the error occur on the QP before calling ibv_modify_qp?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
