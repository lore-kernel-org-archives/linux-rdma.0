From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v7 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Mon, 6 Jul 2015 19:06:17 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAC2F01@CRSMSX101.amr.corp.intel.com>
References: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
 <1435671955-9744-2-git-send-email-kaike.wan@intel.com>
 <20150703211605.GA5595@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150703211605.GA5595-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Friday, July 03, 2015 5:16 PM
> To: Wan, Kaike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> Subject: Re: [PATCH v7 1/4] IB/netlink: Add defines for local service requests
> through netlink
> 
> On Tue, Jun 30, 2015 at 09:45:52AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > @@ -7,12 +7,14 @@ enum {
> >  	RDMA_NL_RDMA_CM = 1,
> >  	RDMA_NL_NES,
> >  	RDMA_NL_C4IW,
> > +	RDMA_NL_SA,
> 
> I think this should be RDMA_NL_LS to be consistent with the rest, the SA
> resolve OP should be something like:
> 
>   RDMA_NL_GET_TYPE(RDMA_NL_LS,RDMA_NL_LS_OP_RESOLVE_PATH)
> 
> I'd probably also add a comment:
> 
>  +	RDMA_NL_LS,   /* RDMA Local Services */
> 
> I have no idea what 'local services' means, it seems like a silly name for this,
> but whatever.

Changed.

> 
> > +/* Local service group opcodes */
> > +enum {
> > +	RDMA_NL_LS_OP_RESOLVE = 0,
> > +	RDMA_NL_LS_OP_SET_TIMEOUT,
> > +	RDMA_NL_LS_NUM_OPS
> > +};
> 
> I think you should document the schema for each operation here in a
> comment for future readers.

Added.

> 
> > +/* Local service netlink message flags */
> > +#define RDMA_NL_LS_F_OK		0x0100	/* Success response */
> > +#define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */
> 
> These overlap with other generic netlink flags, that seems OK, but didn't look
> too hard.
> 
> Drop RDMA_NL_LS_F_OK, we don't need OK and ERR. !ERR == OK.

RDMA_NL_LS_F_OK dropped.

> 
> You might need a RDMA_NL_LS_F_REPLY however, see below.

Added.

> 
> > +/* Local service attribute type */
> > +#define RDMA_NLA_F_MANDATORY	(1 << 13)
> > +#define RDMA_NLA_TYPE_MASK	~(NLA_F_NESTED |
> NLA_F_NET_BYTEORDER | \
> > +				  RDMA_NLA_F_MANDATORY)
> 
> More brackets for this macro:
> 
> #define RDMA_NLA_TYPE_MASK	(~(NLA_F_NESTED |
> NLA_F_NET_BYTEORDER | RDMA_NLA_F_MANDATORY))

Added.

> 
> > +/* Local service status attribute */
> > +enum {
> > +	LS_NLA_STATUS_SUCCESS = 0,
> > +	LS_NLA_STATUS_EINVAL,
> > +	LS_NLA_STATUS_ENODATA,
> > +	LS_NLA_STATUS_MAX
> > +};
> 
> So, this is never used, there seems to be a bunch of never used stuff
> - please audit everything and get rid of the cruft before re-sending anything.

Well,  EINVAL and ENODATA are not used by the kernel, but used by the application (ibacm). Should this file (include/uapi/rdma/rdma_netlink.h) contain only defines used by both kernel and application? In that case, the kernel may see unrecognized status value if it ever decides to check the status code when the response status is ERR.

> 
> We need a way to encode three reply types, I suggest:
>  RDMA_NL_LS_F_ERR
>    For some reason the listener could not respond. The kernel should
>    issue the request on its own. Identical to a timeout.
>  Good flags, but an empty reply with no LS_NLA_TYPE_PATH_RECORDs
>    The listener responded and there are no paths. Return no paths
>    failure to requestor.
>  Good flags, and up to 6 LS_NLA_TYPE_PATH_RECORDs
>    Success

Current implementation can be easily modified to handle these three cases.

> 
> > +struct rdma_nla_ls_status {
> > +	__u32		status;
> > +};
> 
> Never used, drop it

OK.

> 
> > +
> > +/* Local service pathrecord attribute: struct ib_path_rec_data */
> > +
> > +/* Local service timeout attribute */ struct rdma_nla_ls_timeout {
> > +	__u32		timeout;
> > +};
> 
> I don't think the SET_TIMEOUT schema makes much sense, there is not much
> reason for a nested attribute, just use the rdma_nla_ls_timeout as the value.
> If we need extension then we can add optional attributes after it later
> without breaking.

OK

> 
> > +/* Local Service ServiceID attribute */ struct rdma_nla_ls_service_id
> > +{
> > +	__u64		service_id;
> > +};
> 
> Drop struct, just use u64

OK

> 
> > +/* Local Service DGID/SGID attribute: big endian */ struct
> > +rdma_nla_ls_gid {
> > +	__u8		gid[16];
> > +};
> 
> Wish there was a common GID type we could use, but OK..
> 
> > +/* Local Service Traffic Class attribute */ struct rdma_nla_ls_tclass
> > +{
> > +	__u8		tclass;
> > +};
> 
> Drop

OK.

> 
> > +/* Local Service path use attribute */ enum {
> > +	LS_NLA_PATH_USE_ALL = 0,
> > +	LS_NLA_PATH_USE_UNIDIRECTIONAL,
> > +	LS_NLA_PATH_USE_GMP,
> > +	LS_NLA_PATH_USE_MAX
> > +};
> 
> Document how these work

Done.

> 
> > +
> > +struct rdma_nla_ls_path_use {
> > +	__u8		use;
> > +};
> > +
> > +/* Local Service Pkey attribute*/
> > +struct rdma_nla_ls_pkey {
> > +	__u16		pkey;
> > +};
> > +
> > +/* Local Service Qos Class attribute */ struct rdma_nla_ls_qos_class
> > +{
> > +	__u16		qos_class;
> > +};
> 
> Drop all of these

Done.

> 
> There are only two remaining problems I see with the actual netlink
> schema:
>  1) There is no easy indication what port the request is coming
>     from. User space absolutely needs that to be able to forward a
>     request on to the proper SA. Yes, we could look at the SGID, but
>     with gid aliases that seems like alot of work for a performant
>     API. Ideas? Include the hardware port GUID? Port Number? Device
>     Name?
>     Not sure, but does need to be addressed.

We can pass the device name and port number to the user application. The device and port_num are two of the parameters to ib_sa_path_rec_get().

>  2) You are using NLM_F_REQUEST to send the reply back from userspace.
>     This is ugly, but it also creates a worthless NLMSG_DONE reply.
>     Since we care about performance this should be fixed.
> 
>     I see the problem is that netlink_rcv_skb forces this scheme, but
>     I think that just means you cannot use netlink_rcv_skb to handle
>     a response packet for the kernel request.

I will create another function to handle response only. Hopefully the user application will not mix response with another request so that we can use the customized handler for response message and netlink_rcv_skb for request. Otherwise, we will have to either modify netlink_rcv_skb (which is I am reluctant to do because it have quite some callers) or duplicate the function in rdma netlink code.

> 
>     This just means you have to open code some respone parsing in
>     ibnl_rcv_msg and do not call netlink_dump_start for response
>     messages.

Yes if I continue to use ibnl_rcv_msg for response. 

> 
>     I'm also not completely sure we should be using dump_start for
>     things like set_timeout - please check into what other netlink
>     users are doing. IIRC dump is only for certain 'get table' like
>     queries.

The dump function is generally used when the NLM_F_DUMP flag is set for the GET request, and it is overly convoluted and definitely an overkill for set_timeout. I can add some check in ibnl_rcv_msg to bypass the dump calls.

Kaike


> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
