From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv9 09/12] ib_core: Add VLAN support to IBoE
Date: Mon, 16 Aug 2010 15:51:28 +0300
Message-ID: <20100816125128.GB22111@mtldesk30>
References: <20100806144153.GJ20588@mtldesk30>
 <20100806164915.GL11306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100806164915.GL11306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 06, 2010 at 10:49:15AM -0600, Jason Gunthorpe wrote:
> On Fri, Aug 06, 2010 at 05:41:53PM +0300, Eli Cohen wrote:
> > -static inline void iboe_mac_to_ll(union ib_gid *gid, u8 *mac)
> > +static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16 vid)
> >  {
> >  	memset(gid->raw, 0, 16);
> >  	*((u32 *)gid->raw) = cpu_to_be32(0xfe800000);
> > -	gid->raw[12] = 0xfe;
> > -	gid->raw[11] = 0xff;
> > +	if (vid) {
> > +		gid->raw[12] = vid & 0xff;
> > +		gid->raw[11] = vid >> 8;
> > +	} else {
> > +		gid->raw[12] = 0xfe;
> > +		gid->raw[11] = 0xff;
> > +	}
> >  	memcpy(gid->raw + 13, mac + 3, 3);
> >  	memcpy(gid->raw + 8, mac, 3);
> >  	gid->raw[8] ^= 2;
> 
> My general comment on this would be the same I made for userspace:
> Don't assume VID == 0 means no vlan tag. Use 0xFFFF or something that
> is actually invalid.
> 
I was looking for a way to distinguish between the case of none VLAN
and that of VLAN and saw places (in the bonding code) that treat 0 as
a none VLAN case. So now I will use the following function to get the
VLAN ID and code 0xffff as the none VLAN case.

+static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev)
+{
+	return dev->priv_flags & IFF_802_1Q_VLAN ?
+		vlan_dev_vlan_id(dev) : 0xffff;
+}
+

0xffff will signify none VLAN but will be coded as 0xfffe in the GID
as is the case with IPv6 link local addresses.

I will send a v10 series with these changes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
