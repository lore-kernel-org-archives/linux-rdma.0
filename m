From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: The libibverbs with the verbs extension framework uses reserved
 word in C++
Date: Mon, 23 Apr 2012 15:53:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D7CE1@ORSMSX101.amr.corp.intel.com>
References: <CALvMawqXq9qYwy6d7mbXze5y8z04ytJAGivncdTgKJ_eQxJgJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawqXq9qYwy6d7mbXze5y8z04ytJAGivncdTgKJ_eQxJgJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We evaluated the verbs extension framework and we noticed that two new
> attributes in the structures:
>     ibv_device
>     ibv_context
> 
> contain an attribute called "private", which is a reserved work in C++.
> Changing those attributes to private_data seems like a good idea.
> 
> Do you want me to send a patch for this change?

A patch for that would be fine (and is needed), but you may want to wait a couple of weeks until after we discuss whether the current or a different approach will be used going forward.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
