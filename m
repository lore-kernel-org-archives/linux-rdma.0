From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 15:27:56 -0600
Message-ID: <20110922212756.GJ28454@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E674F0@ORSMSX101.amr.corp.intel.com>
 <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E67532@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E67532-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 22, 2011 at 08:20:54PM +0000, Hefty, Sean wrote:
 
> The entire windows tree is built using the WinDDK compiler.  I
> haven't found a way to disable that warning that works.  Since the
> warning is real, an explicit cast at least lets someone reading the
> code know that the author took truncation into account.

It would be much better to fix this at the source.

 mad_get_field16(..,IB_NODE_DEVID_F)

Then at least there is the option of doing a static or runtime check
that IB_NODE_DEVID_F is actually referring to a 16 bit field.

For instance, a static check might be possible with some compilers by
doing:

enum MAD_FIELDS8
{
IB_PORT_LOCAL_PORT_F
};

enum MAD_FIELDS16
{
IB_NODE_DEVID_F
};

uint8_t mad_get_field8(void *buf, int base_offs,
	               enum MAD_FIELDS8 field);
uint16_t mad_get_field16(void *buf, int base_offs,
	                 enum MAD_FIELDS16 field);

A compiler can produce a warning about mismatching enums.

Someone can fixup the enums later, but I'd much rather see you add a
patch with this hunk:

static inline uint16_t mad_get_field16(void *buf, int base_offs,
	                               enum MAD_FIELDS field)
{
   return (uint16_t)mad_get_field(buf,base_offs,field);
}

And another patch replacing every (uint16_t)mad_get_field with
mad_get_field16

Adding a cast is just pointless noise, doesn't fix or prove anything.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
