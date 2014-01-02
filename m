From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IPoIB and STP
Date: Thu, 02 Jan 2014 11:23:50 -0500
Message-ID: <52C59296.1070209@dev.mellanox.co.il>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com> <CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com> <CA+Ekn_c=LVNAhqpZqbnjFSV-WW3TZNTyHDjb74S1_x1nSV8iXQ@mail.gmail.com> <CAJH6TXgXtHrtv5KQQvF1X-qLa4R7iC8cAJC0LJkJRj_JUKp1ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgXtHrtv5KQQvF1X-qLa4R7iC8cAJC0LJkJRj_JUKp1ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Gennadiy Nerubayev <parakie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2013 5:43 AM, Gandalf Corvotempesta wrote:
> OpenSM will be running on both nodes and both node ports will be
> bonded together in active-failover (or active-active, if possible). My
> issue is with interconnection links between switches.
> Last time that i've tried I had issue due to the interface bonding in
> active-active.
> When using active-active i've seen IPoIB running and just a couple of
> KBytes/s and in active-failover was running at 10-11Gbps/s

AFAIK IPoIB bonding only supports active/backup and not active/active
(load sharing) mode.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
