From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Thu, 11 Jun 2015 12:24:31 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABD03A@CRSMSX101.amr.corp.intel.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <1433861837-26177-2-git-send-email-kaike.wan@intel.com>
 <55787827.7030003@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABCD80@CRSMSX101.amr.corp.intel.com>
 <55789609.4020906@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6A9D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE6A9D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Hefty, Sean
> Sent: Wednesday, June 10, 2015 4:32 PM
> To: Hal Rosenstock; Wan, Kaike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> Subject: RE: [PATCH v4 1/4] IB/netlink: Add defines for local service requests
> through netlink
> 
> > >>> +/* Local Service Reversible attribute */ struct
> > >>> +rdma_nla_ls_reversible {
> > >>> +	__u32		reversible;
> > >>> +};
> > >>
> > >> Isn't __u8 sufficient for reversible ?
> > > Certainly enough. However, reversible is __u32 in struct
> > ib_user_path_rec and int in struct ib_sa_path_rec.
> >
> > OK; I hadn't double checked there. So it's "inherited" from those
> > reversible definitions.
> 
> I don't think we need to adhere to the sizes defined in other structures.  I
> agree with Hal's original comment.  A __u8 here seems sufficient, unless we
> want to introduce some bit fields.

There are two reasons why we should use __u32 here:
1. Easy to convert from struct ib_sa_path_rec (the input) to netlink attribute:

   nla_put(skb, LS_NLA_TYPE_REVERSIBLE,
			sizeof(sa_rec->reversible), &sa_rec->reversible);

 Instead of:

    __u8 tmp;

    tmp = (__u8)sa_rec->reversible;
    nla_put(skb, , LS_NLA_TYPE_REVERSIBLE, sizeof(tmp), &tmp);

2. Most importantly, sa_rec->reversible is define as type "int", but it really is "__be32" (big-endian), as proven below:

path rec: len 64 :
00 00 00 00 00 00 00 00 fe 80 00 00 00 00 00 00 00 11 75 00
00 78 ad 92 fe 80 00 00 00 00 00 00 00 11 75 00 00 78 a4 24
00 07 00 03 00 00 00 00 00 80 ff ff 00 00 84 87 92 00 00 00
00 00 00 00
sa path_rec: len 88 :
00 00 00 00 00 00 00 00 fe 80 00 00 00 00 00 00 00 11 75 00
00 78 ad 92 fe 80 00 00 00 00 00 00 00 11 75 00 00 78 a4 24
00 07 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
00 00 ff ff 00 00 00 02 04 02 07 02 12 00 00 00 00 00 00 00
00 00 00 00 00 00 ff ff
sa path_rec reversible 0x1000000

The path rec is the pathrecord returned from ibacm in MAD wire format (dumped in sa_query.c).  The byte "0x80" before "ff ff" (the third row) is reversible_numpath field (reversible bit 7: 1).

The sa_path_rec is the struct ib_sa_path_rec dumped in cma_query_handler() in cma.c (rdma_cm) when the query callback is invoked. The data "00 00 00 01" (the last four bytes of the third row) is the field ib_sa_path_rec->reversible (there are some alignment padding for fields before it).  Again the same field is dumped in user-friendly version as 0x1000000 (or 0x01000000), indicating that it is in big-endian format.

This test was run on x86_64 machines with Opensm as the SM/SA.

I stumped across this during previous patch tests where ibacm returned struct ib_user_path_rec as the response. In that test, I had to manually convert struct ibv_path_record into ib_user_path_rec. Then in ib_sa, I had to convert from struct ib_user_path_rec to struct ib_sa_path_rec. If I set ib_user_path_rec->reversible = 1, then the returned result failed rping; If I set ib_user_path_rec->reversible = 0x01000000, then rping successfully connected to the destination. I also used ib_pack() and ib_unpack() to convert between struct ib_sa_path_rec and pathrecord in MAD wire format (struct ibv_path_record) and compared the result with that from SA. If ib_sa_path_rec->reversible = 1, the ibv_path_record->reversible_numpath=0x00; if ib_sa_path_rec->reversible=0x01000000, then ibv_path_record->r
 eversible_numpath=0x80.

As a result, I think that the following code is incorrect in cma_query_ib_route() (cma.c):

path_rec.reversible = 1;

I am surprised that it still works to query SA with IB_SA_PATH_REC_REVERSIBLE bit set in comp_mask. By the way, of the three callers of ib_sa_path_rec_get(), this is the only place that ib_sa_path_rec.reversible is set.

That is why we should use __u32 as the attribute data type for reversible.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
