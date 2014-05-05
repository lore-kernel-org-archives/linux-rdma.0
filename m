From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibumad: add new registration ioctl
Date: Mon, 5 May 2014 13:20:59 -0600
Message-ID: <20140505192059.GC5743@obsidianresearch.com>
References: <1399153023-25755-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399153023-25755-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, May 03, 2014 at 05:37:03PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This supports the new registration ioctl which the kernel is exporting.
> Specifically this adds flags to the registration operation.  The first such
> flag is to request user space RMPP.  Thus turning off kernel based RMPP
> coalescing.

Did the kernel side get posted?

> +struct umad_reg_attr {
> +	uint16_t   struct_version;
> +	uint8_t    mgmt_class;
> +	uint8_t    mgmt_class_version;
> +	uint32_t   flags;
> +	uint64_t   method_mask[2];
> +	uint8_t    oui[3]; /* network order */

Seems like oui should just be a uint32_t in host order, doesn't make
alot of API sense to burden callers with that detail.

> +	uint8_t    rmpp_version;
> +};
> +int umad_register2(int port_fd, struct umad_reg_attr *attr,
> +		   uint32_t *agent_id);

verbs has been moving to using sizeof(struct umad_reg_attr) not a
'struct_version', it would be nice to be consistent.

> +
> +
>  int umad_debug(int level);
>  void umad_addr_dump(ib_mad_addr_t * addr);
>  void umad_dump(void *umad);
> diff --git a/man/umad_register2.3 b/man/umad_register2.3
> new file mode 100644
> index 0000000..9086bb3
> +++ b/man/umad_register2.3
> @@ -0,0 +1,77 @@
> +.\" -*- nroff -*-
> +.\"
> +.TH UMAD_REGISTER2 3  "March 25, 2014" "OpenIB" "OpenIB Programmer\'s Manual"
> +.SH "NAME"
> +umad_register2 \- register the specified management class and version for port
> +.SH "SYNOPSIS"
> +.nf
> +.B #include <infiniband/umad.h>
> +.sp
> +.BI "int umad_register2(int " "port_fd" ", struct umad_reg_attr *" "attr" ", uint32_t *" "agent_id");
> +.fi
> +.SH "DESCRIPTION"
> +.B umad_register2()
> +registers for a MAD agent using the provided registration attributes
> +
> +.I port_fd\fR
> +the port on which to register the agent
> +
> +.I attr\fR
> +The registration attributes as defined by the structure passed.  See below for
> +details of this structure.  Future structures may be defined.
> +
> +.I agent_id\fR
> +returned on success.

The man page should describe what agent_id should be used for.. (I
expect it is the argument passed to umad_unregister?)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
