From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Question about a corner case in the CMA
Date: Tue, 1 Nov 2011 00:40:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8B583@ORSMSX101.amr.corp.intel.com>
References: <CALvMawo3aR2xAUMsw8_t4-9Abe471gm+pG7Qif3V5iWpbFm7qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawo3aR2xAUMsw8_t4-9Abe471gm+pG7Qif3V5iWpbFm7qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If a user tried to join a multicast group and the variable "mc" is being added
> to the list of the mc_list:
> 1) If the write() fails, the value of mc->next may be changed by another
> thread (for example, removing the mcast which is pointed by mc->next)
>     will the "mc->next" still point to the right location? (since i don't see
> any "volatile" or something like this).

This shouldn't matter.  On a failure, the code searches the mc_list for the entry and removes it.  mc->next can change between entering the mc entry and removing it.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
