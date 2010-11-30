From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 30 Nov 2010 16:09:31 +0200
Message-ID: <1291126171.3155.250.camel@nirm-desktop>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
	 <1291047399-430-6-git-send-email-nirm@voltaire.com>
	 <20101129191136.GC16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101129191136.GC16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-11-29 at 12:11 -0700, Jason Gunthorpe wrote:
> On Mon, Nov 29, 2010 at 06:16:39PM +0200, Nir Muchtar wrote:
> > Add callbacks and data types for statistics export.
> > One callback is implemented that exports all of the current devices/ids.
> > Add/remove the callback to IB Netlink on init/cleanup.
> 
> Please include the schema for the messages you are adding to netlink
> in the comment so other people can review them easily.
> 
> Looks to me like you have messages of the form:
> 
> {
>  [IBNL_RDMA_CM_DEVICE_NAME - char[]]
>  [IBNL_RDMA_CM_ID_STATS - struct rdma_cm_id_stats]*
> }*
> 

Yes that's the basic structure. I'll add an explanation next time.

> As I've said before, I don't want to see this tied to RDMA_CM, that is
> not general enough for a new userspace API. The use of
> IBNL_RDMA_CM_DEVICE_NAME is very un-netlink-like and is just an ugly
> hack to avoid addressing that problem.

This is done to save space in the netlink messages.
I am open for ideas for improvements.
I thought of another possibility: We can make another op for rdma
devices only with index mapping. This could create a problems if a
device is added/removed between calls though.
See my question about your suggestion below.

> 
> How about messages of the form:
> {
>  IBNL_QP - struct ib_nl_qp
>    IBNL_QP_ATTR - struct ib_qp_attr (or a reasonable subset)
>    IBNL_QP_CM_INFO u8[] - struct ib_nl_qp_cm_info
>    IBNL_QP_CM_SERVICE_ID u8[]
>    IBNL_RDMA_CM_INFO - struct ib_nl_rdma_cm_info
>    IBNL_RDMA_CM_SRC - u8[]  // This is a sockaddr_*
>    IBNL_RDMA_CM_DST - u8[] 
> }+
> 
> Meaning there is an array of IBNL_QP messages which contains various
> attributes. Similar to how everything else in netlink works.
> 
> struct ib_nl_qp
> {
>         // String names for IB devices was a mistake, don't perpetuate it.

I don't know of an IB device index mapping like the one in netdevice.
Am I missing one? Do you mean we should create one?

>         __u32 ib_dev_if;
> 	__u32 qp_num;
>         __s32 creator_pid; // -1 for kernel consumer
> };
> 
> struct ib_nl_qp_cm_info
> {
>       u32 cm_state; // enum ib_cm_state
>       u32 lap_state;
> };
> 
> struct ib_nl_rdma_cm_info
> {
> 	__u32 bound_dev_if;
>         __u32 family;
> 	__u32 cm_state; // enum rdma_cm_state
> };
> 
> This captures more information and doesn't tie things to RDMA_CM.

My problem with making everything QP related is that not everything
necessarily is. For example, when creating rdma cm id's they are still 
not bound to QP's. I guess you could send all zeros in this case, but as
more and more of such exceptions are needed this framework will become a
bit unnatural. The current implementation is not tying anything to RDMA
CM. It allows other modules to export data exactly the way they need.

> 
> > +static int cma_get_stats(struct sk_buff **nl_skb, int pid)
> 
> You really have to use netlink_dump_start here, doing it like this
> will deadlock. See how other places use NLM_F_DUMP as well.

Well, I already reviewed netlink_dump_start, and this is how it works 
as much as I can see (Please correct me if I'm wrong):
1. Allocates an skb
2. Calls its supplied dump cb
3. Calls its supplied done cb if if applicable
4. Appends NLMSG_DONE

This appears to be executed synchronously, within the context of the
calling thread. So I couldn't figure out how to use it for avoiding long
locking times.

Anyway, what I tried to achieve is a mechanism that allocates more skb's
as they are needed, and separate it from the calling module. Do you know
of an inherent way to make netlink_dump_start to do that?

> 
> > +struct rdma_cm_id_stats {
> > +	enum rdma_node_type nt;
> > +	int port_num;
> > +	int bound_dev_if;
> > +	__be16	local_port;
> > +	__be16	remote_port;
> > +	__be32	local_addr[4];
> > +	__be32	remote_addr[4];
> > +	enum rdma_port_space ps;
> > +	enum rdma_cm_state cm_state;
> > +	u32 qp_num;
> > +	pid_t pid;
> > +};
> 
> Putting enums in a user/kernel structure like this makes me nervous
> that we'll have a 32/64 bit problem. It would be more consistent with
> the uverbs stuff to use explicit fixed width types.

Yes you're right. Also, I see now that this is not normally done this
way, so I'll drop the enums.

> 
> Jason

Thanks again for all your input.
Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
