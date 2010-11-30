From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 30 Nov 2010 10:50:18 -0700
Message-ID: <20101130175018.GG16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
 <20101129191136.GC16788@obsidianresearch.com>
 <4CF4EF73.6060406@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CF4EF73.6060406-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 30, 2010 at 02:34:59PM +0200, Or Gerlitz wrote:
> Jason Gunthorpe wrote:
> > struct ib_nl_qp
> >         // String names for IB devices was a mistake, don't perpetuate it.
> >         __u32 ib_dev_if;

> Do you have a concrete suggestion and/or sketch for a patch
> someone can work on to make this enumeration to take place? 

Oh, it is really easy, just add an ifindex member to struct
ib_device. alloc_name can be extended to compute an appropriate index,
see how this works in dev_new_index.

Add a 'ifindex' to the ib_device's sysfs directory that exports this
number.

In future we'd want to see a netlink query to get the RDMA device list
to replace trundling through sysfs.

I think this is really important from a netlink perspective, there are
going to be so many places you wan't to refer to an RDMA device.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
