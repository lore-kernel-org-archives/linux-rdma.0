From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: question on the timewait event of the rdma-cm
Date: Mon, 14 Nov 2011 20:50:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9AAC4@ORSMSX101.amr.corp.intel.com>
References: <4EC13EE9.1070103@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AA8E@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZJVs=NSky4hQ1sdoF+XiU8_Pg6FzS2AUMjgqVAzs7Oi6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJVs=NSky4hQ1sdoF+XiU8_Pg6FzS2AUMjgqVAzs7Oi6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Does going through timewait always holds? e.g no matter what's the
> return status of rdma_disconnect and/or the status of the rdma_cm
> disconnected event?

It usually holds.  It will fail if rdma_disconnect() is called from a bogus state.  But otherwise, I believe that it will enter timewait on failure to send or receive a disconnect message.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
