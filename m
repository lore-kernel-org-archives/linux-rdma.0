From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCHv9 09/12] ib_core: Add VLAN support to IBoE
Date: Fri, 6 Aug 2010 10:49:15 -0600
Message-ID: <20100806164915.GL11306@obsidianresearch.com>
References: <20100806144153.GJ20588@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100806144153.GJ20588@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 06, 2010 at 05:41:53PM +0300, Eli Cohen wrote:
> -static inline void iboe_mac_to_ll(union ib_gid *gid, u8 *mac)
> +static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16 vid)
>  {
>  	memset(gid->raw, 0, 16);
>  	*((u32 *)gid->raw) = cpu_to_be32(0xfe800000);
> -	gid->raw[12] = 0xfe;
> -	gid->raw[11] = 0xff;
> +	if (vid) {
> +		gid->raw[12] = vid & 0xff;
> +		gid->raw[11] = vid >> 8;
> +	} else {
> +		gid->raw[12] = 0xfe;
> +		gid->raw[11] = 0xff;
> +	}
>  	memcpy(gid->raw + 13, mac + 3, 3);
>  	memcpy(gid->raw + 8, mac, 3);
>  	gid->raw[8] ^= 2;

My general comment on this would be the same I made for userspace:
Don't assume VID == 0 means no vlan tag. Use 0xFFFF or something that
is actually invalid.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
