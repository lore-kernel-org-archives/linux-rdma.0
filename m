From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Mon, 29 Nov 2010 12:11:36 -0700
Message-ID: <20101129191136.GC16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291047399-430-6-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 29, 2010 at 06:16:39PM +0200, Nir Muchtar wrote:
> Add callbacks and data types for statistics export.
> One callback is implemented that exports all of the current devices/ids.
> Add/remove the callback to IB Netlink on init/cleanup.

Please include the schema for the messages you are adding to netlink
in the comment so other people can review them easily.

Looks to me like you have messages of the form:

{
 [IBNL_RDMA_CM_DEVICE_NAME - char[]]
 [IBNL_RDMA_CM_ID_STATS - struct rdma_cm_id_stats]*
}*

As I've said before, I don't want to see this tied to RDMA_CM, that is
not general enough for a new userspace API. The use of
IBNL_RDMA_CM_DEVICE_NAME is very un-netlink-like and is just an ugly
hack to avoid addressing that problem.

How about messages of the form:
{
 IBNL_QP - struct ib_nl_qp
   IBNL_QP_ATTR - struct ib_qp_attr (or a reasonable subset)
   IBNL_QP_CM_INFO u8[] - struct ib_nl_qp_cm_info
   IBNL_QP_CM_SERVICE_ID u8[]
   IBNL_RDMA_CM_INFO - struct ib_nl_rdma_cm_info
   IBNL_RDMA_CM_SRC - u8[]  // This is a sockaddr_*
   IBNL_RDMA_CM_DST - u8[] 
}+

Meaning there is an array of IBNL_QP messages which contains various
attributes. Similar to how everything else in netlink works.

struct ib_nl_qp
{
        // String names for IB devices was a mistake, don't perpetuate it.
        __u32 ib_dev_if;
	__u32 qp_num;
        __s32 creator_pid; // -1 for kernel consumer
};

struct ib_nl_qp_cm_info
{
      u32 cm_state; // enum ib_cm_state
      u32 lap_state;
};

struct ib_nl_rdma_cm_info
{
	__u32 bound_dev_if;
        __u32 family;
	__u32 cm_state; // enum rdma_cm_state
};

This captures more information and doesn't tie things to RDMA_CM.

iWarp QPs would not export IBNL_QP_CM_INFO and QP_CM_SERVICE_ID, but
ideally we'd have a call out to the NIC to include the TCP diag
information for the underlying TCP socket since there is no other way
to access that.

Non RDMA-CM QPs (ie ipoib) would not include the RDMA_CM bits.

If you study how SS works you'll see it is similar, it uses a message
of type AF_INET/6.. and then includes attributes like
INET_DIAG_MEMINFO/INFO/CONG

> @@ -134,6 +135,7 @@ struct rdma_id_private {
>  	u32			qp_num;
>  	u8			srq;
>  	u8			tos;
> +	pid_t			owner;

Maybe a seperate patch for this? It probably really belongs in
ib_uverbs. What about kernel consumers?

> +static int cma_get_stats(struct sk_buff **nl_skb, int pid)

You really have to use netlink_dump_start here, doing it like this
will deadlock. See how other places use NLM_F_DUMP as well.

> +struct rdma_cm_id_stats {
> +	enum rdma_node_type nt;
> +	int port_num;
> +	int bound_dev_if;
> +	__be16	local_port;
> +	__be16	remote_port;
> +	__be32	local_addr[4];
> +	__be32	remote_addr[4];
> +	enum rdma_port_space ps;
> +	enum rdma_cm_state cm_state;
> +	u32 qp_num;
> +	pid_t pid;
> +};

Putting enums in a user/kernel structure like this makes me nervous
that we'll have a 32/64 bit problem. It would be more consistent with
the uverbs stuff to use explicit fixed width types.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
