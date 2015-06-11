From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 14:25:52 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABD14B@CRSMSX101.amr.corp.intel.com>
References: <1433861878-26264-1-git-send-email-kaike.wan@intel.com>
 <557997EF.7070707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557997EF.7070707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
> Sent: Thursday, June 11, 2015 10:15 AM
> 
> On 6/9/2015 10:57 AM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > This patch enables ibacm to process pathrecord queries through netlink.
> > Since ibacm can cache pathrecords, this implementation provides an
> > easy pathrecord cache for kernel components and therefore offers great
> > performance advantage on large fabric systems.
> >
> > Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > +#define NLA_LEN(nla)	((nla)->nla_len - NLA_HDRLEN)
> > +#define NLA_DATA(nla)	((char *)(nla) + NLA_HDRLEN)
> > +
> > +static void acm_nl_parse_path_attr(struct nlattr *attr,
> > +				   struct acm_ep_addr_data *data)
> 
> Should this return status as to whether parsing was successful or not ?
> 
> > +{
> > +	struct ibv_path_record *path;
> > +	struct rdma_nla_ls_service_id  *sid;
> > +	struct rdma_nla_ls_gid *gid;
> > +	struct rdma_nla_ls_tclass *tcl;
> > +	struct rdma_nla_ls_reversible *rev;
> > +	struct rdma_nla_ls_numb_path *npath;
> > +	struct rdma_nla_ls_pkey *pkey;
> > +	struct rdma_nla_ls_qos_class *qos;
> > +	uint16_t val;
> > +
> > +#define IBV_PATH_RECORD_QOS_MASK 0xfff0
> > +
> > +	path = &data->info.path;
> > +	switch (attr->nla_type & NLA_TYPE_MASK) {
> > +	case LS_NLA_TYPE_SERVICE_ID:
> > +		sid = (struct rdma_nla_ls_service_id *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(sid->service_id)) {
> > +			acm_log(2, "service_id 0x%llx\n", sid->service_id);
> > +			path->service_id = sid->service_id;
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_DGID:
> > +		gid = (struct rdma_nla_ls_gid *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(gid->gid)) {
> > +			acm_format_name(2, log_data, sizeof(log_data),
> > +					ACM_ADDRESS_GID, gid->gid,
> > +					sizeof(union ibv_gid));
> > +			acm_log(2, "path dgid %s\n", log_data);
> > +			memcpy(path->dgid.raw, gid->gid, sizeof(path-
> >dgid));
> > +			data->flags |= ACM_EP_FLAG_DEST;
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_SGID:
> > +		gid = (struct rdma_nla_ls_gid *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(gid->gid)) {
> > +			acm_format_name(2, log_data, sizeof(log_data),
> > +					ACM_ADDRESS_GID, gid->gid,
> > +					sizeof(union ibv_gid));
> > +			acm_log(2, "path sgid %s\n", log_data);
> > +			memcpy(path->sgid.raw, gid->gid, sizeof(path->sgid));
> > +			data->flags |= ACM_EP_FLAG_SOURCE;
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_TCLASS:
> > +		tcl = (struct rdma_nla_ls_tclass *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(tcl->tclass)) {
> > +			acm_log(2, "tclass 0x%x\n", tcl->tclass);
> > +			path->tclass = tcl->tclass;
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_REVERSIBLE:
> > +		rev = (struct rdma_nla_ls_reversible *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(rev->reversible)) {
> > +			acm_log(2, "reversible 0x%x\n", rev->reversible);
> > +			if (rev->reversible)
> > +				path->reversible_numpath |=
> > +					IBV_PATH_RECORD_REVERSIBLE;
> > +			else
> > +				path->reversible_numpath &=
> > +					~IBV_PATH_RECORD_REVERSIBLE;
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_NUMB_PATH:
> > +		npath = (struct rdma_nla_ls_numb_path *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(npath->numb_path)) {
> > +			acm_log(2, "numb_path %d\n", npath->numb_path);
> > +			path->reversible_numpath &=
> IBV_PATH_RECORD_REVERSIBLE;
> > +			path->reversible_numpath |=
> > +				(npath->numb_path &
> > +				 (~IBV_PATH_RECORD_REVERSIBLE));
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_PKEY:
> > +		pkey = (struct rdma_nla_ls_pkey *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(pkey->pkey)) {
> > +			acm_log(2, "pkey 0x%x\n", pkey->pkey);
> > +			path->pkey = pkey->pkey;
> > +		}
> > +		break;
> > +
> > +	case LS_NLA_TYPE_QOS_CLASS:
> > +		qos = (struct rdma_nla_ls_qos_class *) NLA_DATA(attr);
> > +		if (NLA_LEN(attr) == sizeof(qos->qos_class)) {
> > +			acm_log(2, "qos_class 0x%x\n", qos->qos_class);
> > +			val = ntohs(path->qosclass_sl);
> > +			val &= ~IBV_PATH_RECORD_QOS_MASK;
> > +			val |= (ntohs(qos->qos_class) &
> > +				IBV_PATH_RECORD_QOS_MASK);
> > +			path->qosclass_sl = htons(val);
> > +		}
> > +		break;
> > +
> > +	default:
> > +		acm_log(1, "WARN: unknown attr %x\n", attr->nla_type);
> > +		break;
> 
> Is this a parsing failure case ?

The error handling code, which was also suggested by Jason,  will be added in next revision. 

> 
> > +	}
> > +}
> > +
> > +static void acm_nl_process_resolve(struct acmc_client *client,
> > +				   struct acm_nl_msg *acmnlmsg)
> > +{
> > +	struct acm_msg msg;
> > +	struct nlattr *attr;
> > +	int payload_len;
> > +	int rem;
> > +	int total_attr_len;
> > +
> > +	memset(&msg, 0, sizeof(msg));
> > +	msg.hdr.opcode = ACM_OP_RESOLVE;
> > +	msg.hdr.version = ACM_VERSION;
> > +	msg.hdr.length = ACM_MSG_HDR_LENGTH +
> ACM_MSG_EP_LENGTH;
> > +	msg.hdr.status = ACM_STATUS_SUCCESS;
> > +	msg.hdr.tid = (uint64_t) acmnlmsg;
> > +	msg.resolve_data[0].type = ACM_EP_INFO_PATH;
> > +
> > +	payload_len = acmnlmsg->nlmsg_header.nlmsg_len -
> NLMSG_HDRLEN;
> > +	attr = NLMSG_DATA(&acmnlmsg->nlmsg_header);
> > +	rem = payload_len;
> > +	while (1) {
> > +		if (rem < (int) sizeof(*attr) ||
> > +		    attr->nla_len < sizeof(*attr) ||
> > +		    attr->nla_len > rem)
> > +			break;
> > +
> > +		acm_nl_parse_path_attr(attr, &msg.resolve_data[0]);
> > +
> > +		/* Next attribute */
> > +		total_attr_len = NLA_ALIGN(attr->nla_len);
> > +		rem -= total_attr_len;
> > +		attr = (struct nlattr *) ((char *) attr + total_attr_len);
> > +	}
> > +
> 
> Since ACM does not resolve multicast PRs,

Why not? The multicast gid will be used as the dgid and ibacm will not ask peers for address resolution. Instead, It will ask SA directly for the multicast pathrecord (route resolution only). I can't see why it can't be done here.

> as an optimization here, some
> minor check of DGID could be done and if it's multicast DGID, ENODATA
> could be indicated in NL message.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
