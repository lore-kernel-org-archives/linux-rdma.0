From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: question on the timewait event of the rdma-cm
Date: Mon, 14 Nov 2011 23:10:50 +0200
Message-ID: <CAJZOPZKBaQ2HR4kbidW0Mec2xWhZ5H7-ezG20X-J_aYENd9ibw@mail.gmail.com>
References: <4EC13EE9.1070103@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AA8E@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZJVs=NSky4hQ1sdoF+XiU8_Pg6FzS2AUMjgqVAzs7Oi6Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AAC4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9AAC4-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It usually holds. =A0It will fail if rdma_disconnect() is called from=
 a bogus state. =A0But
> otherwise, I believe that it will enter timewait on failure to send o=
r receive a disconnect
> message

mmm, so can these bogus states for rdma_disconnect to be called be
better defined? basically, for  the case where the rdma_cm manages the
consumer QP, this call is the only way to move an RC QP into the error
state when the QP is okay and the consumer want to flush, etc.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
