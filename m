From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: cxgb4: Missing NULL check of the return value of get_skb() in
 function send_flowc()
Date: Thu, 12 Jul 2012 22:03:53 -0700
Message-ID: <CAL1RGDWwXxr_2WDvTTwW41fYP-+gfqf=DzB3cF-Aoe=DS74JJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

steve, in case you didn't read this because of the generic subject:

On Thu, Jul 12, 2012 at 7:16 PM,  <bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=44631
>
>            Summary: Missing NULL check of the return value of get_skb() in
>                     function send_flowc()
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.39
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Infiniband/RDMA
>         AssignedTo: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
>         ReportedBy: rucsoftsec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>         Regression: No
>
>
> Function get_skb() may return a NULL pointer, and its return value shall be
> checked before used. But in function send_flowc() after get_skb() is called(at
> drivers/infiniband/hw/cxgb4/cm.c:362), the return value is immediately used as
> a parameter of __skb_put() without NULL check. Besides, there is no check
> before the parameter is dereferenced in the callee function __skb_put(). So an
> invalid memory access may be triggered.
> The related code snippets in send_flowc() are as following.
> send_flowc() @@drivers/infiniband/hw/cxgb4/cm.c:362
>  362        skb = get_skb(skb, flowclen, GFP_KERNEL);
>  363        flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
>
> And the implementation of get_skb() are as following.
> get_skb() drivers/infiniband/hw/cxgb4/cm.c:301
>  301static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>  302{
>  303        if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>  304                skb_trim(skb, 0);
>  305                skb_get(skb);
>  306                skb_reset_transport_header(skb);
>  307        } else {
>  308                skb = alloc_skb(len, gfp);
>  309        }
>  310        return skb;
>  311}
>
> Following is a call instance of snd_flowc.
> act_establish @@drivers/infiniband/hw/cxgb4/cm.c:695
>  695        /* start MPA negotiation */
>  696        send_flowc(ep, NULL);
>
> So from the source code we can see that potential NULL dereference fault exists
> when path act_establish()->send_flowc()->get_skb()->alloc_skb() is executed.
>
> Thank you
>
> RUC_Soft_Sec
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
