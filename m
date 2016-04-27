From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 27 Apr 2016 21:54:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1604271043540.20042-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +struct ib_lso_caps {
> > +	u32 max_lso;
> > +	u32 supported_qpts; /* Use enum ib_qp_type */
> 
> So this is a bitmap of the qps supported? And thus we have a limit now of
> 32 QP types. That needs to be documented and  you need a BUILD_BUG_ON
> somewhere in case IB_QPT_MAX becomes larger than 32. Also needs to be
> better commented so we know this is a bitmap.

I think it would make more sense to indicate what protocol, or specific aspect of a protocol, are being offloaded.  Some qp types support LSO as a matter of practice.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
