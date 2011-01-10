From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ewg] Mellanox target workaround in SRP
Date: Mon, 10 Jan 2011 14:05:04 -0500
Message-ID: <1294686304.3038.14.camel@obelisk.thedillows.org>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>
	 <adaipy09h0i.fsf@cisco.com>
	 <1294510396.7914.82.camel@obelisk.thedillows.org>
	 <4D2B4E13.6070903@mellanox.com>  <adapqs48uhm.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqs48uhm.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-01-10 at 10:49 -0800, Roland Dreier wrote:
> > I think that the patch is specific for srp initiator using Mellanox
>  > FMR. It tried to avoid indirect desc with Mellanox FMR having
>  > first-byte-offset != 0.  Since the low level implementation of
>  > mlx4/mthca_map_phys_fmr() did not create + setup MPT for FMR with
>  > first_byte_offset != 0. The corruption can happen with any target.
> 
> I don't think this could be right -- right now the workaround only
> triggers if the target has a Mellanox OUI, so if what you say is true,
> presumably everyone who is using the SRP initiator with mlx4 would be
> seeing this problem.

Only if they are using less than 4 KB logical blocks it seems, or
perhaps certain sg3-util commands to directly send SCSI commands. We
should be getting page-aligned IO for 4 KB filesystems, so we probably
wouldn't hit this.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
