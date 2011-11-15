From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: question on the timewait event of the rdma-cm
Date: Tue, 15 Nov 2011 07:26:48 +0200
Message-ID: <CAJZOPZJ=7dVjN9BVnNDJz66c4bMB=gp1jLb4wXqNaxgwCeshUA@mail.gmail.com>
References: <4EC13EE9.1070103@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AA8E@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZJVs=NSky4hQ1sdoF+XiU8_Pg6FzS2AUMjgqVAzs7Oi6Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AAC4@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZKBaQ2HR4kbidW0Mec2xWhZ5H7-ezG20X-J_aYENd9ibw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AAF4@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZLn3hEYp_kHRs22ttF3ca0iq4s5NtFi4iUYgEie81osBg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E9AB1E@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZLB-WvMQwhkx_o5kMD-A33ff8chA1AvQSj+npg4HiOAKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLB-WvMQwhkx_o5kMD-A33ff8chA1AvQSj+npg4HiOAKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 On Mon, Nov 14, 2011 at 11:55 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> [...] calling disconnect is one way that a QP may be transitioned into timewait [...]

I was talking on the QP "physical" state (e.g error that causes
flushes) not the state w.r.t the IB CM.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
