From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
Date: Tue, 7 Jul 2015 10:41:08 -0500
Message-ID: <004001d0b8cb$57f106f0$07d314d0$@opengridcomputing.com>
References: <20150705174353.10042.39648.stgit@build2.ogc.int> <20150705174452.10042.44695.stgit@build2.ogc.int> <559A335A.90506@dev.mellanox.co.il> <001401d0b7f9$09c21b40$1d4651c0$@opengridcomputing.com> <559B712D.7020105@dev.mellanox.co.il> <000601d0b8bd$2aa599d0$7ff0cd70$@opengridcomputing.com> <559BE2EC.8030806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <559BE2EC.8030806@mellanox.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Or Gerlitz' <ogerlitz@mellanox.com>, 'Sagi Grimberg' <sagig@dev.mellanox.co.il>
Cc: dledford@redhat.com, infinipath@intel.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Or Gerlitz
> Sent: Tuesday, July 07, 2015 9:32 AM
> To: Steve Wise; 'Sagi Grimberg'
> Cc: dledford@redhat.com; infinipath@intel.com; roid@mellanox.com; linux-rdma@vger.kernel.org; eli@mellanox.com; target-
> devel@vger.kernel.org
> Subject: Re: [PATCH V5 3/5] RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
> 
> On 7/7/2015 4:59 PM, Steve Wise wrote:
> >>>>> > >>>diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> >>>>> > >>>index 6a594aa..de8730d 100644
> >>>>> > >>>--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> >>>>> > >>>+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> >>>>> > >>>@@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
> >>>>> > >>>    						   SHOST_DIX_GUARD_CRC);
> >>>>> > >>>    		}
> >>>>> > >>>
> >>>>> > >>>+		/*
> >>>>> > >>>+		 * Limit the sg_tablesize and max_sectors based on the device
> >>>>> > >>>+		 * max fastreg page list length.
> >>>>> > >>>+		 */
> >>>>> > >>>+		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
> >>>>> > >>>+			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> >>>>> > >>>+		shost->max_sectors = min_t(unsigned int,
> >>>>> > >>>+			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
> >>>>> > >>>+
> >>>> > >>
> >>>> > >>The min statement is meaningless for max_sectors - you do a min between
> >>>> > >>default sg_tablesize and frpl length - so the maximum sg_tablesize is
> >>>> > >>128 which is 1024 max_sectors.
> >>> > >
> >>> > >I'm not following.  What if ib_conn->device->dev_attr.max_fast_reg_page_list_len is say, 32?
> >>> > >Then shost->sg_tablesize is set to 32, and max_sectors is set to (32*4K) >> 9 == 256 512B sectors.
> >> >
> >> >Correct - but it cannot exceed 1024 (as it is derived from sg_tablesize
> >> >which is maximum 128).
> > Actually it is initialized to 1024 in iscsi_iser_sht / iscsi_iser.c, so it isn't derived from sg_tables (although it probably should be).  I can
> remove the min_t() though.
> >
> > Hey Or, thoughts?
> 
> Originally, we've put the double restriction of 128 SG entries AND 1024
> sectors to make sure that whatever SG is up there, it'snot spanning >
> 512KB.
> 
> Think on SG whose one/some of their element/s is > one page or on
> systems with > 4KB page size or others examples... since your patch
> touched the number of SG entries I was thinking you need to make sure no
> regression was introduced re the max_sectors to be <= 1024
> 
> If U2 are @ consensus that this is  the case with the original patch w.o
> further changes, let it be.
> 

I'm not sure... you guys are the iSER experts. :)  But considering a 64K PAGE_SIZE and an adjusted sg_tablesize of say, 32, w/o the min() we get (32 * 65536) >> 9 ==  4096.  So if the requirement is that max_sectors always be <= 1024, then we need the min()...

Steve.
