From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum
 offload capabilities report
Date: Wed, 5 Aug 2015 17:12:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A9022D60@ORSMSX109.amr.corp.intel.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
 <1438788867-18332-2-git-send-email-amirv@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9022CBD@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1004A52EBD00FA30FAFFD225AA750@HE1PR05MB1004.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1004A52EBD00FA30FAFFD225AA750-eBadYZ65MZ9M5L2kK+KmM9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > +enum ib_csum_cap_flags {
> > > +	IB_CSUM_RX_TCP_UDP       = 1 << 0,
> > > +	IB_CSUM_RX_IP_HDR        = 1 << 1,
> > > +	IB_CSUM_TX_TCP_UDP       = 1 << 2,
> > > +	IB_CSUM_TX_IP_HDR        = 1 << 3
> > > +};
> >
> > TPC and UDP should be separate flags.
> 
> Can you explain why?

For the same reason that you didn't include *all* L4 headers.

> What we are advertising here is offloads for L3 and L4 checksums, why
> should it be per protocol?

Because UDP and TCP have different headers, and it's entirely possible for a NIC (e.g. usnic) to support offloading one but not the other.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
