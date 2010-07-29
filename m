From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: iboe - address resolution in userspace
Date: Thu, 29 Jul 2010 11:26:05 -0600
Message-ID: <20100729172605.GX7920@obsidianresearch.com>
References: <1280423371.16125.30.camel@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1280423371.16125.30.camel@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 29, 2010 at 08:09:31PM +0300, Eli Cohen wrote:

> Add a new API, resolve_eth_ll_gid(), which resolves a GID to layer 2
> address information. The GID resembles an IPv6 link local address
> and encodes the MAC address and the VLAN tag within it. The function
> accepts the destination GID, port number and source GID index and
> returns the MAC VLAN and indications whether the remote address is
> tagged VLAN and whether the address is multicast.

Is it reasonable for the receiver to have an sgid table entry for
every vlan supported?

resolve_eth_gid should probably fail if dgid vlan != sgid vlan..

> +int resolve_eth_gid(struct ibv_pd *pd, uint8_t port_num,
> +		    union ibv_gid *dgid, uint8_t sgid_index,
> +		    uint8_t mac[], uint16_t *vlan, uint8_t *tagged,
> +		    uint8_t *is_mcast);

union ibv_gid * should be const (and const flowed down)

> +static int is_multicast_gid(union ibv_gid *gid)
> +{
> +	return gid->raw[0] == 0xff ? 1 : 0;
> +}

This ternary if is kinda redundant?

> +static int resolve_grh(union ibv_gid *dgid, uint8_t *mac, uint8_t *is_mcast)
> +{

Funny name for the function? It does not touch GRHs?

> +	*vlan = get_vlan_id(&sgid);
> +	*tagged = *vlan;

It is hard to see what you are trying to do here, can you document
this GID address format you invented? vlan 0 is not special, you
shouldn't use it to mean untagged packets. I'm guessing the scheme
is if the GID has the 0xFFFE bit then it should be untagged
otherwise it should be tagged with the VID in bytes 11/12? If so
then this computation if *tagged is wrong, it prevents someone
creating tagged vlan id 0 packets, which is a valid thing to do.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
