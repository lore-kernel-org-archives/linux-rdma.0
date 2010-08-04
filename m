From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: iboe - address resolution in userspace
Date: Wed, 04 Aug 2010 11:24:20 -0600
Message-ID: <4C59A244.1070806@obsidianresearch.com>
References: <1280423371.16125.30.camel@mtldesk30> <20100729172605.GX7920@obsidianresearch.com> <AANLkTinp++TVkhz+vCnWX4kSU5o3rjh18C+e99Vq868b@mail.gmail.com> <20100801164357.GA14012@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100801164357.GA14012@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> Hi,
>
> I am attaching a new patch which addresses the comments raised.
> --
>
>
> libibverbs: Add API to resolve GID to L2 address
>
> Add a new API, resolve_eth_gid(), which resolves a GID to layer 2 address
> information. A GID resembles an IPv6 link local address and encodes the MAC
> address and the VLAN tag within it. The function accepts the destination GID,
> port number and source GID index and returns the MAC, VLAN and indications
> whether the remote address is tagged VLAN and whether the address is multicast.
>
> VLAN encoding is done as follows:
> gid[11] is MS byte
> gid[12] is LS byte
>
>  
> +int resolve_eth_gid(struct ibv_pd *pd, uint8_t port_num,
> +		    union ibv_gid *dgid, uint8_t sgid_index,
> +		    uint8_t mac[], uint16_t *vlan, uint8_t *tagged,
> +		    uint8_t *is_mcast);
>
>   
Forgot to make the dgid const here.

> +static void get_mcast_mac(const union ibv_gid *gid, uint8_t *mac)
> +{
> +	int i;
> +
> +	mac[0] = 0x33;
> +	mac[1] = 0x33;
> +	for (i = 2; i < 6; ++i)
> +		mac[i] = gid->raw[i + 10];
> +}
>
>   
So how does vlan and multicast work? This is copying byte 12 into the 
MAC address.. Not too thrilled about using the IPv6 prefix 
unconditionally either?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
