From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: question on the timewait event of the rdma-cm
Date: Mon, 14 Nov 2011 21:28:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9AAF4@ORSMSX101.amr.corp.intel.com>
References: <4EC13EE9.1070103@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AA8E@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZJVs=NSky4hQ1sdoF+XiU8_Pg6FzS2AUMjgqVAzs7Oi6Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AAC4@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZKBaQ2HR4kbidW0Mec2xWhZ5H7-ezG20X-J_aYENd9ibw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKBaQ2HR4kbidW0Mec2xWhZ5H7-ezG20X-J_aYENd9ibw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> mmm, so can these bogus states for rdma_disconnect to be called be
> better defined? basically, for  the case where the rdma_cm manages the
> consumer QP, this call is the only way to move an RC QP into the error
> state when the QP is okay and the consumer want to flush, etc.

By bogus I mean calling disconnect when the QP has never been connected, or calling disconnect twice.  The ib_cm will check the state of the connection when disconnect is called.  If disconnect is called from the wrong state, it simply fails.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
