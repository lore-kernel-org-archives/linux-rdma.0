From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/IPoIB: Support SRIOV standard configuration
Date: Thu, 21 May 2015 15:01:45 -0600
Message-ID: <20150521210145.GA20175@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432225447-6536-2-git-send-email-ogerlitz@mellanox.com>
 <20150521184613.GD6771@obsidianresearch.com>
 <CAJ3xEMgJvXjg3aFbTNEudj9QWMfP4==eBq0ccuhjuVJsv9mRmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgJvXjg3aFbTNEudj9QWMfP4==eBq0ccuhjuVJsv9mRmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 11:05:32PM +0300, Or Gerlitz wrote:
> On Thu, May 21, 2015, Jason Gunthorpe  wrote:
> 
> >> +static int ipoib_set_vf_mac(struct net_device *dev, int queue, u8 *mac)
> >> +{
> >> +     char *raw_guid;
> >> +     u64 guid = 0;
> >
> > This doesn't seem right at all.
> >
> > It makes no sense that a IPoIB interface with a 20 byte LLADDR would
> > accept an 8 byte LLADDR only for 'ip link set vf mac'
> >
> > The definition of the netlink struct seems to confirm this:
> >
> > struct ifla_vf_mac {
> >         __u32 vf;
> >         __u8 mac[32]; /* MAX_ADDR_LEN */
> > };
> >
> > If it was really just ever a mac it would really only be 6 bytes.
> > [Honestly, this whole feature seems very inconistent with the rest of
> >  the design of ip net link, so who knows]
> >
> > If the ifla_vf_mac had been variable-sized (like every other address
> > related attribute) then sure, auto detect the length and do the right
> > thing.
> >
> > But with this API, I think you have no choice, 'ip set vf mac LLADDR'
> > can only be the 20 byte address.
> 
> You can't enforce 20 byte address on ipoib instance b/c the driver
> can't dictate the QPN of their UD QP.

I can think of several ways off the top of my head to deal with
that. Don't see it as a problem.

> Also, you don't need to force that, b/c what the virtualization
> system want to provision relates to a VM ID which is their mac (-->
> guid).

No, I do need to force that because that is how netlink works: each
device has a defined hw address length, and all netlink messages
dealing with LLADDR must use an identical format for the hw
address. For IPoIB that is 20 byte.

It is a simple matter of UAPI sanity, it is not the kernel's problem
that some userspace tools assume a 6 byte LLADDR for all devices -
they are broken.

> (mac), 64bits (guid) or even 128bits (whole gid), but it doesn't and I
> would like to either use the lowest common denominator (48bits) or
> just take always 64bits which could have two zero bytes (e.g when
> libvirt calls into that api through netlink).

Then get the iproute and netdev people to sign off on using
ifla_vf_mac with something other than the defined 20 byte IPoIB HW
address. Maybe you can work out some scheme with them. Making the
IFLA_VF_MAC properly variable sized might be a good angle.

NACK otherwise.

The rest of the series's idea seems sound.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
