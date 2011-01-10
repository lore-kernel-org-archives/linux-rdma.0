From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ewg] Mellanox target workaround in SRP
Date: Mon, 10 Jan 2011 11:49:31 -0800
Message-ID: <4D2B62CB.30408@mellanox.com>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>	<adaipy09h0i.fsf@cisco.com>	<1294510396.7914.82.camel@obelisk.thedillows.org>	<4D2B4E13.6070903@mellanox.com> <adapqs48uhm.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqs48uhm.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Roland Dreier wrote:
>  > I think that the patch is specific for srp initiator using Mellanox
>  > FMR. It tried to avoid indirect desc with Mellanox FMR having
>  > first-byte-offset != 0.  Since the low level implementation of
>  > mlx4/mthca_map_phys_fmr() did not create + setup MPT for FMR with
>  > first_byte_offset != 0. The corruption can happen with any target.
> 
> I don't think this could be right -- right now the workaround only
> triggers if the target has a Mellanox OUI, so if what you say is true,
> presumably everyone who is using the SRP initiator with mlx4 would be
> seeing this problem.

Yes, I'm afraid targets without Mellanox OUI would be seeing this problem.

> 
> Also, the SRP initiator code that uses ib_fmr_pool_map_phys does not
> pass in any non-aligned addresses -- it doesn't try to use any first
> byte offset, it just uses the virtual address it passes to the target to
> handle the offset.
> 


Yes and I suspect that the corruption happen with Mellanox FMR/MPT setup without fbo and target doing RDMA with offset vaddr.

Let me ask around and confirm.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
