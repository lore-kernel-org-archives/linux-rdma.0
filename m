From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 3/9] net/mlx4_core: Set initial admin GUIDs for
 VFs
Date: Mon, 30 Mar 2015 11:16:31 -0600
Message-ID: <20150330171631.GA1152@obsidianresearch.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
 <1427637093-6711-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427637093-6711-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 29, 2015 at 04:51:27PM +0300, Or Gerlitz wrote:
> +void mlx4_set_random_admin_guid(struct mlx4_dev *dev, int entry, int port)
> +{
> +	struct mlx4_priv *priv = mlx4_priv(dev);
> +	u8 random_mac[6];
> +	char *raw_gid;
> +
> +	/* hw GUID */
> +	if (entry == 0)
> +		return;
> +
> +	eth_random_addr(random_mac);
> +	raw_gid = (char *)&priv->mfunc.master.vf_admin[entry].vport[port].guid;

raw_gid is actually a guid

> +	raw_gid[0] = random_mac[0] ^ 2;

eth_random_addr already guarentees the ULA bit is set to one (local),
so this is wrong. IBA uses the EUI-64 system, not the IPv6
modification.

> +	raw_gid[1] = random_mac[1];
> +	raw_gid[2] = random_mac[2];
> +	raw_gid[3] = 0xff;
> +	raw_gid[4] = 0xfe;

This should be 0xff for mapping a MAC to a EUI-64

But, it doesn't really make sense to use eth_random_addr (which
doesn't have a special OUI) and not randomize every bit.

        get_random_bytes(&guid, sizeof(guid));
        guid &= ~(1ULL << 56);
	guid |= 1ULL << 57;

I also don't think the kernel should be generating random GUIDs. Either
the SA should be consulted to do this, or the management stack should
generate a cloud wide unique number.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
