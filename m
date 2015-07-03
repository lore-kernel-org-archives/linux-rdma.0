From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v7 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Fri, 3 Jul 2015 15:16:05 -0600
Message-ID: <20150703211605.GA5595@obsidianresearch.com>
References: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
 <1435671955-9744-2-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435671955-9744-2-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 09:45:52AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> @@ -7,12 +7,14 @@ enum {
>  	RDMA_NL_RDMA_CM = 1,
>  	RDMA_NL_NES,
>  	RDMA_NL_C4IW,
> +	RDMA_NL_SA,

I think this should be RDMA_NL_LS to be consistent with the rest, the
SA resolve OP should be something like:

  RDMA_NL_GET_TYPE(RDMA_NL_LS,RDMA_NL_LS_OP_RESOLVE_PATH)

I'd probably also add a comment:

 +	RDMA_NL_LS,   /* RDMA Local Services */

I have no idea what 'local services' means, it seems like a silly
name for this, but whatever.

> +/* Local service group opcodes */
> +enum {
> +	RDMA_NL_LS_OP_RESOLVE = 0,
> +	RDMA_NL_LS_OP_SET_TIMEOUT,
> +	RDMA_NL_LS_NUM_OPS
> +};

I think you should document the schema for each operation here in a
comment for future readers.

> +/* Local service netlink message flags */
> +#define RDMA_NL_LS_F_OK		0x0100	/* Success response */
> +#define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */

These overlap with other generic netlink flags, that seems OK, but
didn't look too hard.

Drop RDMA_NL_LS_F_OK, we don't need OK and ERR. !ERR == OK.

You might need a RDMA_NL_LS_F_REPLY however, see below.

> +/* Local service attribute type */
> +#define RDMA_NLA_F_MANDATORY	(1 << 13)
> +#define RDMA_NLA_TYPE_MASK	~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | \
> +				  RDMA_NLA_F_MANDATORY)

More brackets for this macro:

#define RDMA_NLA_TYPE_MASK	(~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | RDMA_NLA_F_MANDATORY))

> +/* Local service status attribute */
> +enum {
> +	LS_NLA_STATUS_SUCCESS = 0,
> +	LS_NLA_STATUS_EINVAL,
> +	LS_NLA_STATUS_ENODATA,
> +	LS_NLA_STATUS_MAX
> +};

So, this is never used, there seems to be a bunch of never used stuff
- please audit everything and get rid of the cruft before re-sending
anything.

We need a way to encode three reply types, I suggest:
 RDMA_NL_LS_F_ERR 
   For some reason the listener could not respond. The kernel should
   issue the request on its own. Identical to a timeout.
 Good flags, but an empty reply with no LS_NLA_TYPE_PATH_RECORDs
   The listener responded and there are no paths. Return no paths
   failure to requestor.
 Good flags, and up to 6 LS_NLA_TYPE_PATH_RECORDs
   Success

> +struct rdma_nla_ls_status {
> +	__u32		status;
> +};

Never used, drop it

> +
> +/* Local service pathrecord attribute: struct ib_path_rec_data */
> +
> +/* Local service timeout attribute */
> +struct rdma_nla_ls_timeout {
> +	__u32		timeout;
> +};

I don't think the SET_TIMEOUT schema makes much sense, there is not
much reason for a nested attribute, just use the rdma_nla_ls_timeout
as the value. If we need extension then we can add optional attributes after it
later without breaking.

> +/* Local Service ServiceID attribute */
> +struct rdma_nla_ls_service_id {
> +	__u64		service_id;
> +};

Drop struct, just use u64

> +/* Local Service DGID/SGID attribute: big endian */
> +struct rdma_nla_ls_gid {
> +	__u8		gid[16];
> +};

Wish there was a common GID type we could use, but OK..

> +/* Local Service Traffic Class attribute */
> +struct rdma_nla_ls_tclass {
> +	__u8		tclass;
> +};

Drop

> +/* Local Service path use attribute */
> +enum {
> +	LS_NLA_PATH_USE_ALL = 0,
> +	LS_NLA_PATH_USE_UNIDIRECTIONAL,
> +	LS_NLA_PATH_USE_GMP,
> +	LS_NLA_PATH_USE_MAX
> +};

Document how these work

> +
> +struct rdma_nla_ls_path_use {
> +	__u8		use;
> +};
> +
> +/* Local Service Pkey attribute*/
> +struct rdma_nla_ls_pkey {
> +	__u16		pkey;
> +};
> +
> +/* Local Service Qos Class attribute */
> +struct rdma_nla_ls_qos_class {
> +	__u16		qos_class;
> +};

Drop all of these

There are only two remaining problems I see with the actual netlink
schema:
 1) There is no easy indication what port the request is coming
    from. User space absolutely needs that to be able to forward a
    request on to the proper SA. Yes, we could look at the SGID, but
    with gid aliases that seems like alot of work for a performant
    API. Ideas? Include the hardware port GUID? Port Number? Device
    Name?
    Not sure, but does need to be addressed.
 2) You are using NLM_F_REQUEST to send the reply back from userspace.
    This is ugly, but it also creates a worthless NLMSG_DONE reply.
    Since we care about performance this should be fixed.

    I see the problem is that netlink_rcv_skb forces this scheme, but
    I think that just means you cannot use netlink_rcv_skb to handle
    a response packet for the kernel request.

    This just means you have to open code some respone parsing in
    ibnl_rcv_msg and do not call netlink_dump_start for response
    messages.

    I'm also not completely sure we should be using dump_start for
    things like set_timeout - please check into what other netlink
    users are doing. IIRC dump is only for certain 'get table' like
    queries.
 
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
