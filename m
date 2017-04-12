From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core/srp_daemon PATCH] Correct method field for PathRecord
 request
Date: Wed, 12 Apr 2017 22:18:01 +0800
Message-ID: <20170412141800.GA20223@dhcp-13-42.nay.redhat.com>
References: <1491924533-2548-1-git-send-email-honli@redhat.com>
 <20170411154944.GA19917@obsidianresearch.com>
 <20170412132923.GB16375@dhcp-13-42.nay.redhat.com>
 <d5a9d1a8-6c38-51f2-d444-a6942db406f9@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d5a9d1a8-6c38-51f2-d444-a6942db406f9-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 12, 2017 at 09:34:20AM -0400, Hal Rosenstock wrote:
> On 4/12/2017 9:29 AM, Honggang LI wrote:
> > On Tue, Apr 11, 2017 at 09:49:44AM -0600, Jason Gunthorpe wrote:
> >> On Tue, Apr 11, 2017 at 11:28:53PM +0800, Honggang LI wrote:
> >>> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>>
> >>> According to InfiniBand Architecture Release 1.2.1, Table 208
> >>> Example PathRecord Request MAD Header Fields, MADHeader:Method
> >>> should setup to 0x12 (SubnAdmGetTable()).
> >>
> >> That is just an example, Table 192 shows that Get and GetTable are
> >> both valid query types.
> > 
> > I don't understand this as "Table 192 PortInfoRecord" seems nothing to
> > do with PathRecord request.
> 
> In IBA 1.3 volume 1, it's Table 209 Subnet Administration
> Attribute/Method Map shows PathRecord methods are Get and GetTable.
> 

http://www.intel.com/content/dam/www/public/us/en/documents/product-briefs/truescale-infiniband-12300-switch-brief.pdf
Interoperability
• Compliant with IBTA* specifications 1.0a, 1.1, 1.2, and 1.2.

It seems the embedded subnet manager does not support IBA 1.3

> >>
> >> I however expect that the SM will fail when using GetTable if the
> >> query returns more than one result, could that be what is happening?
> >> When you convert it to GET_TABLE does it return more than one result?
> > 
> > strace output shows srptools always received MAD packet in 320 bytes. So
> > the embedded subnet manager only returns one result.
> 
> What is MAD status ?

ib_user_mad->status     = 0x0

I attached the MAD packet dump out with strace. Please see the
attachments p4.in amd p4.decode.

> 
> -- Hal
> 
> >>
> >> Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="p4.in"
Content-Transfer-Encoding: quoted-printable

\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x01\x0=
0\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x01\x03\x02\x81\x00\x00\x00\x00\x00\x00\x00=
\x08\x00\x00\x00\x04\x00\x35\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x20\x30\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x80\x00\=
x00\x00\x00\x00\x00\x00\x11\x75\x00\x00\x6f\x9b\xba\xfe\x80\x00\x00\x00\x00=
\x00\x00\x00\x11\x75\x00\x00\x6f\x9a\x34\x01\x9b\x00\xed\x00\x00\x00\x00\x0=
0\x80\xff\xff\x00\x00\x84\x87\x8f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x=
00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\=
x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00=
\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0=
0\x00

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="p4.decode"

ib_user_mad->agent_id	= 0x0
ib_user_mad->status	= 0x0
ib_user_mad->timeout_ms	= 0x0
ib_user_mad->retries	= 0x0
ib_user_mad->length	= 0x140 = 320
ib_mad_addr->qpn		= BE32 0x1000000
ib_mad_addr->qkey		= BE32 0x0
ib_mad_addr->lid		= BE16 0x100
ib_mad_addr->sl 		= 0x0
ib_mad_addr->path_bits		= 0x0
ib_mad_addr->grh_present	= 0x0
ib_mad_addr->gid_index		= 0x0
ib_mad_addr->hop_limit		= 0x0
ib_mad_addr->traffic_class	= 0x0
ib_mad_addr->gid[16]= 0x\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00
ib_mad_addr->flow_label		= BE32 0x0
ib_mad_addr->pkey_index		= BE16 0x0
ib_mad_addr->reserved[6]= 0x\x00\x00\x00\x00\x00\x00
srp_dm_rmpp_sa_mad->base_version	= 0x1
srp_dm_rmpp_sa_mad->mgmt_class		= 0x3
srp_dm_rmpp_sa_mad->class_version	= 0x2
srp_dm_rmpp_sa_mad->method		= 0x81 //IB_MAD_METHOD_GET_RESP opensm/include/iba/ib_types.h // GetResp() Method (13.4.5)
srp_dm_rmpp_sa_mad->status		= 0x0
srp_dm_rmpp_sa_mad->reserved1		= 0x0
srp_dm_rmpp_sa_mad->tid			= 0x400000008000000
srp_dm_rmpp_sa_mad->attr_id		= 0x3500
srp_dm_rmpp_sa_mad->reserved2		= 0x0
srp_dm_rmpp_sa_mad->attr_mod		= 0x0
srp_dm_rmpp_sa_mad->rmpp_version	= 0x0
srp_dm_rmpp_sa_mad->rmpp_type		= 0x0
srp_dm_rmpp_sa_mad->rmpp_rtime_flags	= 0x0
srp_dm_rmpp_sa_mad->rmpp_status		= 0x0
srp_dm_rmpp_sa_mad->seg_num		= 0x0
srp_dm_rmpp_sa_mad->paylen_newwin	= 0x0
srp_dm_rmpp_sa_mad->sm_key		= 0x0
srp_dm_rmpp_sa_mad->attr_offset		= 0x0
srp_dm_rmpp_sa_mad->reserved3		= 0x0
srp_dm_rmpp_sa_mad->comp_mask		= 0x3020000000000000
ib_path_rec_t->resv0[8]			= \x00\x00\x00\x00
ib_path_rec_t->dgid			= \xfe\x00\x00\x00\x00\x75\x00\x9b
ib_path_rec_t->sgid			= \xfe\x00\x00\x00\x00\x75\x00\x9a
ib_path_rec_t->dlid				= ib_net16_t 0x9b01
ib_path_rec_t->slid				= ib_net16_t 0xed00
ib_path_rec_t->hop_flow_raw			= ib_net32_t 0x0
ib_path_rec_t->tclass				= 0x0
ib_path_rec_t->num_path				= 0x80
ib_path_rec_t->pkey				= ib_net16_t 0xffff
ib_path_rec_t->sl				= ib_net16_t 0x0
ib_path_rec_t->mtu				= 0x84
ib_path_rec_t->rate				= 0x87
ib_path_rec_t->pkt_life				= 0x8f
ib_path_rec_t->preference			= 0x0
ib_path_rec_t->resv2[6]				= \x00\x00\x00

--VbJkn9YxBvnuCH5J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
