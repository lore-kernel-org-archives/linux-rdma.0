From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question about a corner case in the CMA
Date: Tue, 1 Nov 2011 16:17:20 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8B677@ORSMSX101.amr.corp.intel.com>
References: <CALvMawo3aR2xAUMsw8_t4-9Abe471gm+pG7Qif3V5iWpbFm7qg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8B583@ORSMSX101.amr.corp.intel.com>
 <CALvMawrf-Hit5JYxS1jy7AUE9bJOoa3hrQkfuVfZBLbJa5n0PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawrf-Hit5JYxS1jy7AUE9bJOoa3hrQkfuVfZBLbJa5n0PA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> My question is: will the mc->next contain the right value?
> (since the compiler may cache the value of mc->next within that function and
> not read the updated value from memory,
> so if the mc_list will be changed by another thread, we may get bad results
> ...)

Access to the list is protected by a mutex.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
