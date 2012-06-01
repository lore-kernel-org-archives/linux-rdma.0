From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: HCA concurrency
Date: Fri, 1 Jun 2012 23:48:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A25998@ORSMSX101.amr.corp.intel.com>
References: <117D8742-93E9-4877-AEF3-6440888317E3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <117D8742-93E9-4877-AEF3-6440888317E3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?=22Xavier_R=2E_Gu=E9rin=22?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In my test case to evaluate fetch-and-add, I spawn multiple threads, each
> owning its own QP inside the same PD and context and sending fetch-and-add
> requests without any inner contention (no lock, etc.). I quickly reach a
> ceiling of about 900KOPS with 5/6 threads, and I have a hard time figuring out
> why.

If you're setting inline data, try reducing it to 16 bytes or less.  We've seen small message rates drop drastically when using a larger inline data size.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
