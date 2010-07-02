From: "Moni Shoua" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] naming for new QP types
Date: Fri, 2 Jul 2010 08:30:49 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F86D8875@exil.voltaire.com>
References: <4C2CB5EC.1080501@Voltaire.COM> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002191@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002191-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Along with the patches to the kernel we will send a patch to libibverbs
to expose the new values

---------------------------------------
  Moni Shoua|  +972-54-5567934  


-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Friday, July 02, 2010 3:34 AM
To: Moni Shoua; Roland Dreier
Cc: linux-rdma; Or Gerlitz; Walukiewicz, Miroslaw; Aleksey Senin
Subject: RE: [RFC] naming for new QP types

> In general, will it be acceptable if we submit the patches so that 
> after they are applied the structure will look like this
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

Have the existing values been exposed to user space in any way, even if
not defined by libibverbs?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
