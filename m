From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 11:52:59 -0400
Message-ID: <5579AEDB.5070702@dev.mellanox.co.il>
References: <1433861878-26264-1-git-send-email-kaike.wan@intel.com> <557997EF.7070707@dev.mellanox.co.il> <3F128C9216C9B84BB6ED23EF16290AFB0CABD14B@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABD14B-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/11/2015 10:25 AM, Wan, Kaike wrote:

>>> +static void acm_nl_process_resolve(struct acmc_client *client,
>>> +				   struct acm_nl_msg *acmnlmsg)
>>> +{
>>> +	struct acm_msg msg;
>>> +	struct nlattr *attr;
>>> +	int payload_len;
>>> +	int rem;
>>> +	int total_attr_len;
>>> +
>>> +	memset(&msg, 0, sizeof(msg));
>>> +	msg.hdr.opcode = ACM_OP_RESOLVE;
>>> +	msg.hdr.version = ACM_VERSION;
>>> +	msg.hdr.length = ACM_MSG_HDR_LENGTH +
>> ACM_MSG_EP_LENGTH;
>>> +	msg.hdr.status = ACM_STATUS_SUCCESS;
>>> +	msg.hdr.tid = (uint64_t) acmnlmsg;
>>> +	msg.resolve_data[0].type = ACM_EP_INFO_PATH;
>>> +
>>> +	payload_len = acmnlmsg->nlmsg_header.nlmsg_len -
>> NLMSG_HDRLEN;
>>> +	attr = NLMSG_DATA(&acmnlmsg->nlmsg_header);
>>> +	rem = payload_len;
>>> +	while (1) {
>>> +		if (rem < (int) sizeof(*attr) ||
>>> +		    attr->nla_len < sizeof(*attr) ||
>>> +		    attr->nla_len > rem)
>>> +			break;
>>> +
>>> +		acm_nl_parse_path_attr(attr, &msg.resolve_data[0]);
>>> +
>>> +		/* Next attribute */
>>> +		total_attr_len = NLA_ALIGN(attr->nla_len);
>>> +		rem -= total_attr_len;
>>> +		attr = (struct nlattr *) ((char *) attr + total_attr_len);
>>> +	}
>>> +
>>
>> Since ACM does not resolve multicast PRs,
> 
> Why not? The multicast gid will be used as the dgid and ibacm will not ask peers for address resolution. 
> Instead, It will ask SA directly for the multicast pathrecord (route resolution only). 
> I can't see why it can't be done here.

Are you saying the local cache lookup fails so it falls back to ask SA
for multicast PR ? If so, then perhaps there's provider optimization to
fail that style of lookup rather than doing the tree lookup.

>> as an optimization here, some
>> minor check of DGID could be done and if it's multicast DGID, ENODATA
>> could be indicated in NL message.
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
