From: Gennadiy Nerubayev <parakie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB and STP
Date: Sun, 29 Dec 2013 15:51:47 -0500
Message-ID: <CA+Ekn_c0YpJ6b5drKdWA9DoDU9Sewm3Sm4hucy7yHCDr_m_zVA@mail.gmail.com>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com>
	<CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com>
	<CA+Ekn_c=LVNAhqpZqbnjFSV-WW3TZNTyHDjb74S1_x1nSV8iXQ@mail.gmail.com>
	<CAJH6TXgXtHrtv5KQQvF1X-qLa4R7iC8cAJC0LJkJRj_JUKp1ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgXtHrtv5KQQvF1X-qLa4R7iC8cAJC0LJkJRj_JUKp1ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 29, 2013 at 5:43 AM, Gandalf Corvotempesta
<gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> OpenSM will be running on both nodes and both node ports will be
> bonded together in active-failover (or active-active, if possible). My
> issue is with interconnection links between switches.
> Last time that i've tried I had issue due to the interface bonding in
> active-active.
> When using active-active i've seen IPoIB running and just a couple of
> KBytes/s and in active-failover was running at 10-11Gbps/s
>
> So, are you suggesting:
> OpenSM running on both, node1 and node2
> Both nodes connected to both switches (1 port per switch)
> Both switches interconnected with 2 or more links to have aggregated bandwidth
>
> This would'nt require any special configuration? How can I ensure the
> both link on switches are used together? Any command to run with
> OpenSM ?

I haven't had much success and/or advantages with a active/active
bond, and used active/passive instead. One of the reasons for that is
the app I used at a time only did one network connection worth of
traffic, which doesn't gain any speed benefits from active/active. I
don't recall seeing such drastic speed issues with active/active, but
granted it's been a bit since I last worked with it and Infiniband in
general.

-Gennadiy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
