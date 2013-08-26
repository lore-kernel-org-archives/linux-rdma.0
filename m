From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 for-next 1/4] IB/core: Add receive Flow Steering support
Date: Mon, 26 Aug 2013 12:07:07 -0700
Message-ID: <CAL1RGDUp7Tmak=b_Ttqm=WWoS5vvA1r0HCGKR7y6MJ4th44=pQ@mail.gmail.com>
References: <1376477911-13828-1-git-send-email-ogerlitz@mellanox.com> <1376477911-13828-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376477911-13828-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 14, 2013 at 3:58 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> +struct _ib_flow_spec {

Just out of curiousity, why does this structure name start with "_"?
In fact why have the struct at all, since all it's doing is wrapping
an anonymous union?  Does the following work:

+union ib_flow_spec {
+               struct {
+                       enum ib_flow_spec_type  type;
+                       u16                     size;
+               };
+               struct ib_flow_spec_eth eth;
+               struct ib_flow_spec_ipv4 ipv4;
+               struct ib_flow_spec_tcp_udp tcp_udp;
+       };
+};

If that works, then that seems a lot nicer to me...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
