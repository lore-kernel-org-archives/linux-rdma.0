From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Tue, 26 Apr 2016 08:33:23 -0600
Message-ID: <20160426143323.GA24104@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB045101@ORSMSX109.amr.corp.intel.com>
 <20160425181953.GC7675@obsidianresearch.com>
 <571F6A8C.9080100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571F6A8C.9080100-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 26, 2016 at 09:18:04AM -0400, Doug Ledford wrote:

> > So, a sketch would look like this:
> > 
> > struct msg
> > {
> >    uint16_t length;
> >    uint16_t class_id;
> >    uint32_t object_id; // in/out
> >    struct qp_base_attr
> >    {
> >        uint16_t length;
> >        uint16_t attribute_id;
> > 
> >        uint16_t qpn;  //in/out
> >        uint16_t qp_flags;
> >        uint16_t max_send_wr,max_recv_qr,max_send_sge,////
> >    };
> >    // Option to piggy back what ibv_modify_qp does:
> >    struct qp_addr_ib
> >    {
> >        uint16_t length;
> >        uint16_t attribute_id;
> > 
> >        uint16_t dlid,slid,sl,pkey,etc;
> >    }
> > }
> > 
> > msg.length = sizeof(msg);
> > msg.class_id = RDMA_OBJ_QP_UD;
> > msg.base.legnth = sizeof(msg.base);
> > msg.base.attribute_id = RDMA_ATTR_QP_BASE;
> > msg.base.qp_flags = XX
> > [..]
> > ioctl(fd,RDMA_CREATE_OBJECT,&msg);
> > [..]
> > ioctl(fd,RDMA_MODIFY_OBJECT,&msg2);
> 
> I think I would do it slightly differently.  In this example, the
> class_id covers the entire list of commands.

It isn't a list of commands, it is a list of attributes - this was
specifically exploring the idea Liran has talked about where create_qp
and modify_qp *as a special case* can be combined. This is not
chaining commands but atomically creating a qp with the full set of
attributes.

> if each command in the linked list was fully self-contained and
> complete.  For the example of the cmtime program that's part of
> librdamcm, when you run it with 1000s of connections as the test, being
> able to pipeline 10, or 50, or 100 different commands would be useful to
> the test.  Likewise, a verbs 2.0 application might want to build up a
> chain of commands and pass the whole chain down in one ioctl.

It would not be too hard to provide a linked list execution ioctl:

struct chain_hdr
{
    uint32_t command;
    struct chain_hdr *next;
    uint64_t msg[];
}
ioctl(fd,RDMA_EXECUTE_CHAINED_COMMANDS,&chain_hdr);

I think the kernel side would be fairly trivial.

Someone would have to figure out a way to use that from userspace of
course..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
