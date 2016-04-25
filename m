From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Mon, 25 Apr 2016 12:19:53 -0600
Message-ID: <20160425181953.GC7675@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB045101@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB045101-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 24, 2016 at 08:11:47PM +0000, Hefty, Sean wrote:

> After fully over-analyzing things, these are my current thoughts.
> 
> I'm for merging all the rdma uABI interfaces.  This will allow us to
> share events, and allow closer association between objects.

Yes

> We have 256 ioctl commands available.  A straightforward mapping
> would result in uverbs using 43, ucma 23, and ucm 18.  I'd deprecate
> ucm, but if it needs to be kept, it could probably drop to about 6
> commands.  Uverbs could be re-structured into 10 objects -- each
> with create/query/modify/close routines -- plus about 6 fast path
> commands.

Yes, this seems broadly right to me.

However, I had intended to use the object type carred in the ioctl arg
as the primary mux and the ioctl would just indicate the 'method'. The
method ID table would be split much like you describe:

'core common' object routines
'built-in extra' object routines
'driver-fast-path' object routines

Not sure about experimental..

~128 unique methods for every object seems like enough??

Why do you feel cm/mgmt needs dedicated routines? I was going to model
CM as more objects and use the 'built-in extra' block to make CM
object specific calls (eg bind/etc)

This still works OK for strace: it has to parse the ioctl # and then
look into the class_id uniform first dword, then it knows exactly how
to format and parse the ioctl argument.

> A command block has a num_ops, followed by an array of calls.  Each
> device structure has an array of pointers to command blocks.  This
> allows a driver to override any call, without necessarily storing a
> huge function table.

My sketch had the drivers just provide the individual things they
wanted to provide/override by number:

 static const struct rdma_uapi_class hfi_uapi_ops[] {
  // Driver directly provides its own object
  {.class_id = RDMA_OBJECT_HFI1_CTXT,
   .create_object = assign_ctxt,

And then rely on a 'compile' phase during registration to build a
micro-optimized dispatch table.

> For the base ioctl command, I would also add these two fields:
> op_ctrl and flags.  I'm envision that these fields can be used to
> determine the format of the input/output data.

There has been a lot of talk of using a structure like netlink with a
linked list of binary attributes and an optional/mandatory flag. For
the lower speed stuff that seems reasonable, though it is certainly
over-engineered for some commands.

So, a sketch would look like this:

struct msg
{
   uint16_t length;
   uint16_t class_id;
   uint32_t object_id; // in/out
   struct qp_base_attr
   {
       uint16_t length;
       uint16_t attribute_id;

       uint16_t qpn;  //in/out
       uint16_t qp_flags;
       uint16_t max_send_wr,max_recv_qr,max_send_sge,////
   };
   // Option to piggy back what ibv_modify_qp does:
   struct qp_addr_ib
   {
       uint16_t length;
       uint16_t attribute_id;

       uint16_t dlid,slid,sl,pkey,etc;
   }
}

msg.length = sizeof(msg);
msg.class_id = RDMA_OBJ_QP_UD;
msg.base.legnth = sizeof(msg.base);
msg.base.attribute_id = RDMA_ATTR_QP_BASE;
msg.base.qp_flags = XX
[..]
ioctl(fd,RDMA_CREATE_OBJECT,&msg);
[..]
ioctl(fd,RDMA_MODIFY_OBJECT,&msg2);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
