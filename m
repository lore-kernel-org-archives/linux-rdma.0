From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: any suggested configuration for rxe?
Date: Wed, 1 Feb 2017 11:35:20 +0200
Message-ID: <CAG9sBKMVVtUdffzH8DbS7vRzYiyAPDBn+n2MMBYvpe6SQXYHjA@mail.gmail.com>
References: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA@mail.gmail.com>
 <CAG9sBKPj9wJhwZOFDXoOwH0=tBZR1pWdS6chYn_VK6SLdDQ7Xg@mail.gmail.com>
 <CAJ-uSQY50gRrQe7TAoJq3rd_MFqX8o=y_CZ=hqFJ1=WFZSg+tw@mail.gmail.com> <CAG9sBKPGWNrR_ejm-LxNzy5iqXKwvxUD2-mLYsGJnVw7FkxKHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPGWNrR_ejm-LxNzy5iqXKwvxUD2-mLYsGJnVw7FkxKHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> Hi
> 1. Can you ping from 192.168.237.132 to 192.168.237.133?
> 2. Which Ethernet NICs are you using (vendor)?
> 3. Can you please run the test with tracing on the server side (the
> side you sent the log for) and attach the results
> (/sys/kernel/debug/tracing/trace)
>
> thanks

I forgot to mention that in the trace filter I'd like to see functions
from ib_core, rdma_cm, ib_cm, ib_rxe

Also, please check if you have a firewall (iptables) that block UDP/4791

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
