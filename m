From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: any suggested configuration for rxe?
Date: Tue, 31 Jan 2017 10:28:23 +0200
Message-ID: <CAG9sBKPGWNrR_ejm-LxNzy5iqXKwvxUD2-mLYsGJnVw7FkxKHg@mail.gmail.com>
References: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA@mail.gmail.com>
 <CAG9sBKPj9wJhwZOFDXoOwH0=tBZR1pWdS6chYn_VK6SLdDQ7Xg@mail.gmail.com> <CAJ-uSQY50gRrQe7TAoJq3rd_MFqX8o=y_CZ=hqFJ1=WFZSg+tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ-uSQY50gRrQe7TAoJq3rd_MFqX8o=y_CZ=hqFJ1=WFZSg+tw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 5:30 PM, feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Thanks Moni,
>
> Unfortunately getting the same with -g1:
>
> root@xdev:~# ibv_rc_pingpong -d rxe0 -g 1 -i 1
>   local address:  LID 0x0000, QPN 0x000018, PSN 0xdf8d29, GID
> ::ffff:192.168.237.132
>   remote address: LID 0x0000, QPN 0x000011, PSN 0xc5c58c, GID
> ::ffff:192.168.237.133
> Completion for unknown wr_id 0
> parse WC failed 2
>
> Regards,
>
> Fedor

Hi
1. Can you ping from 192.168.237.132 to 192.168.237.133?
2. Which Ethernet NICs are you using (vendor)?
3. Can you please run the test with tracing on the server side (the
side you sent the log for) and attach the results
(/sys/kernel/debug/tracing/trace)

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
