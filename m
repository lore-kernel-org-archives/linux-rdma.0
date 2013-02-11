From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2 for-next 1/6] IB/ipoib: Fix ipoib_neigh hashing to
 use the correct daddr octets
Date: Mon, 11 Feb 2013 19:46:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B99DDC@ORSMSX101.amr.corp.intel.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com>
 <1360079337-8173-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360079337-8173-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The hash function introduced in commit b63b70d877 "IPoIB: Use a private hash
> table for path lookup in xmit path" was designd to use the 3 octets of the
> IPoIB HW address that holds the remote QPN. However, this currently isn't
> the case under little endian machines as the code there uses the flags part
> (octet[0]) and not the last octet of the QPN (octet[3]), fix that.
> 
> The fix caused a checkpatch warning on line over 80 characters, to
> solve that changed the name of the temp variable that holds the daddr.
> 
> Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 6fdc9e7..e459fa7 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -844,10 +844,10 @@ static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl,
> u8 *daddr)
>  	 * different subnets.
>  	 */
>  	 /* qpn octets[1:4) & port GUID octets[12:20) */
> -	u32 *daddr_32 = (u32 *) daddr;
> +	u32 *d32 = (u32 *)daddr;
>  	u32 hv;
> 
> -	hv = jhash_3words(daddr_32[3], daddr_32[4], 0xFFFFFF & daddr_32[0], 0);
> +	hv = jhash_3words(d32[3], d32[4], cpu_to_be32(0xFFFFFF) & d32[0], 0);

Should d32 be declared as __be32 *?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
