From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] naming for new QP types
Date: Thu, 1 Jul 2010 17:34:29 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002191@orsmsx501.amr.corp.intel.com>
References: <4C2CB5EC.1080501@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2CB5EC.1080501-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In general, will it be acceptable if we submit the patches so that after
> they are applied the structure will look like this
> 
> enum ib_qp_type {
>         /*
>          * IB_QPT_SMI and IB_QPT_GSI have to be the first two entries
>          * here (and in that order) since the MAD layer uses them as
>          * indices into a 2-entry table.
>          */
>         IB_QPT_SMI,
>         IB_QPT_GSI,
> 
>         IB_QPT_RC,
>         IB_QPT_UC,
>         IB_QPT_UD,
>         IB_QPT_RAW_IPV6,
>         IB_QPT_RAW_ETHERTYPE = 7,
>         IB_QPT_RAW_PACKET = 8
> };
> 
> So when XRC is accepted we still keep the same values for the last 2?

Have the existing values been exposed to user space in any way, even if not defined by libibverbs?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
