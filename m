From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Mon, 25 Apr 2016 19:16:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04548E@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB045101@ORSMSX109.amr.corp.intel.com>
 <20160425181953.GC7675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425181953.GC7675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> However, I had intended to use the object type carred in the ioctl arg
> as the primary mux and the ioctl would just indicate the 'method'. The
> method ID table would be split much like you describe:
> 
> 'core common' object routines
> 'built-in extra' object routines
> 'driver-fast-path' object routines

I did understand the proposal.  My main concern was that it appeared that it would result in a very large function array, potentially with a significant number of NULL functions, associated with each driver.

> Not sure about experimental..

I wasn't sure either.

> ~128 unique methods for every object seems like enough??

Seems more than enough to me

> Why do you feel cm/mgmt needs dedicated routines? I was going to model
> CM as more objects and use the 'built-in extra' block to make CM
> object specific calls (eg bind/etc)

I separated the cm/mgmt calls because I doubt a driver will ever override them, and some of the calls are system wide, versus being bound to a driver. 

> This still works OK for strace: it has to parse the ioctl # and then
> look into the class_id uniform first dword, then it knows exactly how
> to format and parse the ioctl argument.
> 
> > A command block has a num_ops, followed by an array of calls.  Each
> > device structure has an array of pointers to command blocks.  This
> > allows a driver to override any call, without necessarily storing a
> > huge function table.
> 
> My sketch had the drivers just provide the individual things they
> wanted to provide/override by number:
> 
>  static const struct rdma_uapi_class hfi_uapi_ops[] {
>   // Driver directly provides its own object
>   {.class_id = RDMA_OBJECT_HFI1_CTXT,
>    .create_object = assign_ctxt,
> 
> And then rely on a 'compile' phase during registration to build a
> micro-optimized dispatch table.
> 
> > For the base ioctl command, I would also add these two fields:
> > op_ctrl and flags.  I'm envision that these fields can be used to
> > determine the format of the input/output data.
> 
> There has been a lot of talk of using a structure like netlink with a
> linked list of binary attributes and an optional/mandatory flag. For
> the lower speed stuff that seems reasonable, though it is certainly
> over-engineered for some commands.
> 
> So, a sketch would look like this:
> 
> struct msg
> {
>    uint16_t length;
>    uint16_t class_id;
>    uint32_t object_id; // in/out
>    struct qp_base_attr
>    {
>        uint16_t length;
>        uint16_t attribute_id;
> 
>        uint16_t qpn;  //in/out
>        uint16_t qp_flags;
>        uint16_t max_send_wr,max_recv_qr,max_send_sge,////
>    };
>    // Option to piggy back what ibv_modify_qp does:
>    struct qp_addr_ib
>    {
>        uint16_t length;
>        uint16_t attribute_id;
> 
>        uint16_t dlid,slid,sl,pkey,etc;
>    }
> }
> 
> msg.length = sizeof(msg);
> msg.class_id = RDMA_OBJ_QP_UD;
> msg.base.legnth = sizeof(msg.base);
> msg.base.attribute_id = RDMA_ATTR_QP_BASE;
> msg.base.qp_flags = XX
> [..]
> ioctl(fd,RDMA_CREATE_OBJECT,&msg);
> [..]
> ioctl(fd,RDMA_MODIFY_OBJECT,&msg2);

I had followed this, but wondered if it wouldn't be easier to just say, use structure 1 or structure 2.  A lot of the need for this complexity seems driven by treating all QPs as a single object, rather than separate objects.  Making that change might simplify things..?  Also I think we should consider reasonable optimizations for connecting QPs.  Doug and I had to debug apps that broke because the connection process was not completing quick enough.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
