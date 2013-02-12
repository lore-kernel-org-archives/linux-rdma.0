From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/6] IB/ipoib: Fix ipoib_neigh hashing to use
 the correct daddr octets
Date: Tue, 12 Feb 2013 13:35:17 -0700
Message-ID: <20130212203517.GI1471@obsidianresearch.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com>
 <1360079337-8173-2-git-send-email-ogerlitz@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237368B99DDC@ORSMSX101.amr.corp.intel.com>
 <511A560D.8020900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <511A560D.8020900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 12, 2013 at 04:47:41PM +0200, Shlomo Pongratz wrote:
> On 2/11/2013 9:46 PM, Hefty, Sean wrote:
> >>>+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> >>>@@ -844,10 +844,10 @@ static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl,
> >>>u8 *daddr)
> >>>  	 * different subnets.
> >>>  	 */
> >>>  	 /* qpn octets[1:4) & port GUID octets[12:20) */
> >>>-	u32 *daddr_32 = (u32 *) daddr;
> >>>+	u32 *d32 = (u32 *)daddr;
> >>>  	u32 hv;
> >>>
> >>>-	hv = jhash_3words(daddr_32[3], daddr_32[4], 0xFFFFFF & daddr_32[0], 0);
> >>>+	hv = jhash_3words(d32[3], d32[4], cpu_to_be32(0xFFFFFF) & d32[0], 0);
> >Should d32 be declared as __be32 *?
> Hi Sean,
> 
> The IPoIB destination address is indeed in big endian format and
> normally the pointer to it should be of type __be32.
> However in this case I just want to feed it into the hash function
> without the flags part.
> defining d32 as __be32* will make the code a bit ugly as I'll need
> to cast 3 of "jhash_3words" functions arguments.
> That is,
> 
> __be32 *d32;
> ....
> 
> hv = jhash_3words((__force u32) d32[3], (__force u32) d32[4],
> (__force u32)(cpu_to_be32(0xFFFFFF) & d32[0]), 0);

Not sure what your hv is used for, but be aware that it is going to
have a different value on big and little endian systems..

This is why the (__force u32) is somewhat desirable, because you are
explicitly, and deliberately ignoring the effect of endianness at that
point in the code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
