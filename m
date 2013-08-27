From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs V2] Add new verb: uv_query_port_max_datagram()
Date: Tue, 27 Aug 2013 15:20:10 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F839A0E@xmb-rcd-x01.cisco.com>
References: <1377120147-12286-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377120147-12286-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <B6F7AE6778A23A43991954CCE8865D45-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bump.  This is V2 of the patch, which removes the ABI issue: libibverbs directly calls the command in the kernel (without going through the provider plugin).

On Aug 21, 2013, at 5:22 PM, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> Per lengthy discussion on the linux-rdma list, add a new verb to get
> max datagram size (in bytes) since the methods for retrieving MTU
> values are limited to a finite enum set, and are difficult to change
> for backwards compatibility reasons.  
> 
> Also add corresponding command: uv_cmd_query_port_max_datagram().
> Since this is a new verb, there was no need to add a _V2 enum for the
> command macro, which required adding a UB_INIT_CMD_RESP() macro.
> 
> If the kernel does not support the new QUERY_PORT_MAX_DATAGRAM
> command, fall back to returning the int-ized MTU enum from
> ibv_cmd_query_port().
> 
> Note that the name for this verb was chosen with the following
> rationale:
> 
> * After discussion with Roland, use the prefix "uv" instead of "ibv",
>  since this verb is generic to both Ethernet, InfiniBand, and
>  whatever other transports are underneath.
> * "query" was used (vs. "get") because it invokes a command (vs. a
>  struct lookup)
> 
> If the community likes this approach, I'll send the corresponding
> kernel patch.
> 
> Difference from V1 
> ==================
> Do not add this verb to the devops struct (because that would break ABI).
> Instead, just have uv_query_port_max_datagram() directly invoke 
> uv_cmd_query_port_max_datagram().
> 
> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
> Makefile.am                      |  3 +-
> examples/devinfo.c               |  7 +++++
> include/infiniband/driver.h      |  4 +++
> include/infiniband/kern-abi.h    | 17 +++++++++++-
> include/infiniband/verbs.h       |  6 ++++
> man/uv_query_port_max_datagram.3 | 59 ++++++++++++++++++++++++++++++++++++++++
> src/cmd.c                        | 54 ++++++++++++++++++++++++++++++++++++
> src/ibverbs.h                    |  8 ++++++
> src/libibverbs.map               |  2 ++
> src/verbs.c                      | 13 +++++++++
> 10 files changed, 171 insertions(+), 2 deletions(-)
> create mode 100644 man/uv_query_port_max_datagram.3
> 
> diff --git a/Makefile.am b/Makefile.am
> index 40e83be..51fe5d5 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -54,7 +54,8 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
>     man/ibv_post_srq_recv.3 man/ibv_query_device.3 man/ibv_query_gid.3	\
>     man/ibv_query_pkey.3 man/ibv_query_port.3 man/ibv_query_qp.3	\
>     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
> -    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3
> +    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3	\
> +    man/uv_query_port_max_datagram.3
> 
> DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
>     debian/ibverbs-utils.install debian/libibverbs1.install \
> diff --git a/examples/devinfo.c b/examples/devinfo.c
> index ff078e4..f51620b 100644
> --- a/examples/devinfo.c
> +++ b/examples/devinfo.c
> @@ -209,6 +209,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
> 	struct ibv_port_attr port_attr;
> 	int rc = 0;
> 	uint8_t port;
> +	uint32_t max_datagram;
> 	char buf[256];
> 
> 	ctx = ibv_open_device(ib_dev);
> @@ -298,6 +299,11 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
> 			fprintf(stderr, "Failed to query port %u props\n", port);
> 			goto cleanup;
> 		}
> +		rc = uv_query_port_max_datagram(ctx, port, &max_datagram);
> +		if (rc) {
> +			fprintf(stderr, "Failed to query port %u max datagram size\n", port);
> +			goto cleanup;
> +		}
> 		printf("\t\tport:\t%d\n", port);
> 		printf("\t\t\tstate:\t\t\t%s (%d)\n",
> 		       port_state_str(port_attr.state), port_attr.state);
> @@ -305,6 +311,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
> 		       mtu_str(port_attr.max_mtu), port_attr.max_mtu);
> 		printf("\t\t\tactive_mtu:\t\t%s (%d)\n",
> 		       mtu_str(port_attr.active_mtu), port_attr.active_mtu);
> +		printf("\t\t\tmax_datagram_size:\t%u\n", max_datagram);
> 		printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
> 		printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
> 		printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
> diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
> index 9a81416..6e1236c 100644
> --- a/include/infiniband/driver.h
> +++ b/include/infiniband/driver.h
> @@ -67,6 +67,10 @@ int ibv_cmd_query_device(struct ibv_context *context,
> int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
> 		       struct ibv_port_attr *port_attr,
> 		       struct ibv_query_port *cmd, size_t cmd_size);
> +int uv_cmd_query_port_max_datagram(struct ibv_context *context, uint8_t port_num,
> +				   uint32_t *max_datagram,
> +				   struct uv_query_port_max_datagram *cmd,
> +				   size_t cmd_size);
> int ibv_cmd_query_gid(struct ibv_context *context, uint8_t port_num,
> 		      int index, union ibv_gid *gid);
> int ibv_cmd_query_pkey(struct ibv_context *context, uint8_t port_num,
> diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
> index 619ea7e..248dbef 100644
> --- a/include/infiniband/kern-abi.h
> +++ b/include/infiniband/kern-abi.h
> @@ -85,7 +85,8 @@ enum {
> 	IB_USER_VERBS_CMD_MODIFY_SRQ,
> 	IB_USER_VERBS_CMD_QUERY_SRQ,
> 	IB_USER_VERBS_CMD_DESTROY_SRQ,
> -	IB_USER_VERBS_CMD_POST_SRQ_RECV
> +	IB_USER_VERBS_CMD_POST_SRQ_RECV,
> +	USER_VERBS_CMD_QUERY_PORT_MAX_DATAGRAM
> };
> 
> /*
> @@ -227,6 +228,20 @@ struct ibv_query_port_resp {
> 	__u8  reserved[2];
> };
> 
> +struct uv_query_port_max_datagram {
> +	__u32 command;
> +	__u16 in_words;
> +	__u16 out_words;
> +	__u64 response;
> +	__u8  port_num;
> +	__u8  reserved[7];
> +	__u64 driver_data[0];
> +};
> +
> +struct uv_query_port_max_datagram_resp {
> +	__u32 max_datagram;
> +};
> +
> struct ibv_alloc_pd {
> 	__u32 command;
> 	__u16 in_words;
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 4b1ab57..13062b3 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -813,6 +813,12 @@ static inline int ___ibv_query_port(struct ibv_context *context,
> 	___ibv_query_port(context, port_num, port_attr)
> 
> /**
> + * uv_query_port_max_datagram - Get port's max datagram size
> + */
> +int uv_query_port_max_datagram(struct ibv_context *context,
> +			uint8_t port_num, uint32_t *max_datagram);
> +
> +/**
>  * ibv_query_gid - Get a GID table entry
>  */
> int ibv_query_gid(struct ibv_context *context, uint8_t port_num,
> diff --git a/man/uv_query_port_max_datagram.3 b/man/uv_query_port_max_datagram.3
> new file mode 100644
> index 0000000..34955c1
> --- /dev/null
> +++ b/man/uv_query_port_max_datagram.3
> @@ -0,0 +1,59 @@
> +.\" -*- nroff -*-
> +.\"
> +.TH UV_QUERY_PORT_MAX_DATAGRAM 3 2013-08-12 libibverbs "Libibverbs Programmer's Manual"
> +.SH "NAME"
> +uv_query_port_max_datagram \- query an RDMA port's max datagram size
> +.SH "SYNOPSIS"
> +.nf
> +.B #include <infiniband/verbs.h>
> +.sp
> +.BI "int uv_query_port_max_datagram(struct ibv_context " "*context" ","
> +.BI "                                    uint8_t " "port_num" "," 
> +.BI "                                    uin32_t " "*max_datagram" ");"
> +.fi
> +.SH "DESCRIPTION"
> +.B uv_query_port_max_datagram()
> +returns the max datagram size of port
> +.I port_num
> +for device context
> +.I context
> +through the pointer
> +.I port_attr\fR.
> +.fi
> +.PP
> +This function was added primarily to support non-InfiniBand transports
> +that can have MTU values outside the small set of enums that can be
> +returned by
> +.BR ibv_query_port() .
> +In order to be backwards compatible, 
> +.B ibv_query_port() 
> +and its associated data structures were left unchanged, and the
> +.B uv_query_port_max_datagram()
> +verb was created specifically to allow returning arbitrary MTU /
> +datagram sizes.
> +.PP
> +This verb should be used to find the active MTU size (instead of the
> +values returned from
> +.BR ibv_query_port() )
> +for all devices that support it.
> +.PP
> +The "uv" prefix refers to "user verbs" because the "ibv" prefix would
> +imply that the function is specific to InfiniBand devices (which would
> +be ironic, since this verb was created to return arbitrary MTU / max
> +datagram sizes, but InfiniBand devices are restricted to a small set
> +of MTU values).
> +.fi
> +.SH "RETURN VALUE"
> +.B uv_query_port_max_datagram()
> +returns 0 upon success, and the max datagram size (in bytes) is returned
> +in
> +.IR max_datagram .
> +Otherwise, the negative value of errno is returned on failure (which
> +indicates the failure reason), and the value of
> +.I max_datagram
> +is undefined.
> +.SH "SEE ALSO"
> +.BR ibv_query_port (3),
> +.SH "AUTHORS"
> +.TP
> +Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> diff --git a/src/cmd.c b/src/cmd.c
> index 9789092..48d56ae 100644
> --- a/src/cmd.c
> +++ b/src/cmd.c
> @@ -203,6 +203,60 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
> 	return 0;
> }
> 
> +int uv_cmd_query_port_max_datagram(struct ibv_context *context, uint8_t port_num,
> +				   uint32_t *max_datagram,
> +				   struct uv_query_port_max_datagram *cmd,
> +				   size_t cmd_size)
> +{
> +	int rc;
> +	struct uv_query_port_max_datagram_resp resp;
> +	struct ibv_port_attr port_attr;
> +	struct ibv_query_port qp_cmd;
> +
> +	UV_INIT_CMD_RESP(cmd, cmd_size, QUERY_PORT_MAX_DATAGRAM,
> +			&resp, sizeof resp);
> +	cmd->port_num = port_num;
> +	memset(cmd->reserved, 0, sizeof cmd->reserved);
> +
> +	if (write(context->cmd_fd, cmd, cmd_size) == cmd_size) {
> +		(void) VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
> +		*max_datagram = resp.max_datagram;
> +		return 0;
> +	} 
> +
> +	/* If the errno isn't ENOSYS, return that error */
> +	if (errno != ENOSYS)
> +		return errno;
> +
> +	/* Otherwise, if we got ENOSYS, that means the kernel doesn't
> +	 * have the QUERY_PORT_MAX_DATAGRAM command, so fall back to
> +	 * ibv_cmd_query_port.  */
> +	rc = ibv_cmd_query_port(context, port_num, &port_attr, 
> +				&qp_cmd, sizeof qp_cmd);
> +	if (rc)
> +		return rc;
> +
> +	switch(port_attr.active_mtu) {
> +	case IBV_MTU_256:
> +		*max_datagram = 256;
> +		break;
> +	case IBV_MTU_512:
> +		*max_datagram = 512;
> +		break;
> +	case IBV_MTU_1024:
> +		*max_datagram = 1024;
> +		break;
> +	case IBV_MTU_2048:
> +		*max_datagram = 2048;
> +		break;
> +	case IBV_MTU_4096:
> +		*max_datagram = 4096;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
> 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
> 		     struct ibv_alloc_pd_resp *resp, size_t resp_size)
> diff --git a/src/ibverbs.h b/src/ibverbs.h
> index fa6cd41..26cd1d3 100644
> --- a/src/ibverbs.h
> +++ b/src/ibverbs.h
> @@ -102,4 +102,12 @@ HIDDEN int ibverbs_init(struct ibv_device ***list);
> 		(cmd)->response  = (uintptr_t) (out);			\
> 	} while (0)
> 
> +#define UV_INIT_CMD_RESP(cmd, size, opcode, out, outsize)		\
> +	do {								\
> +		(cmd)->command = USER_VERBS_CMD_##opcode;		\
> +		(cmd)->in_words  = (size) / 4;				\
> +		(cmd)->out_words = (outsize) / 4;			\
> +		(cmd)->response  = (uintptr_t) (out);			\
> +	} while (0)
> +
> #endif /* IB_VERBS_H */
> diff --git a/src/libibverbs.map b/src/libibverbs.map
> index 7e722f4..e855c25 100644
> --- a/src/libibverbs.map
> +++ b/src/libibverbs.map
> @@ -99,4 +99,6 @@ IBVERBS_1.1 {
> 
> 		ibv_rate_to_mbps;
> 		mbps_to_ibv_rate;
> +
> +		uv_query_port_max_datagram;
> } IBVERBS_1.0;
> diff --git a/src/verbs.c b/src/verbs.c
> index a6aae70..f05d658 100644
> --- a/src/verbs.c
> +++ b/src/verbs.c
> @@ -138,6 +138,19 @@ int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
> }
> default_symver(__ibv_query_port, ibv_query_port);
> 
> +int __uv_query_port_max_datagram(struct ibv_context *context, uint8_t port_num,
> +				uint32_t *max_datagram)
> +{
> +	struct uv_query_port_max_datagram cmd;
> +
> +	/* To avoid backwards compatibility issues, just call
> +	 * uv_cmd_query_port_max_datagram() directly (vs. going
> +	 * through the provider plugin library) */
> +	return uv_cmd_query_port_max_datagram(context, port_num,
> +					max_datagram, &cmd, sizeof cmd);
> +}
> +default_symver(__uv_query_port_max_datagram, uv_query_port_max_datagram);
> +
> int __ibv_query_gid(struct ibv_context *context, uint8_t port_num,
> 		    int index, union ibv_gid *gid)
> {
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
