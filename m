From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ewg] Mellanox target workaround in SRP
Date: Tue, 18 Jan 2011 15:05:11 -0500
Message-ID: <1295381111.17379.15.camel@lap75545.ornl.gov>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>
 <adaipy09h0i.fsf@cisco.com> <1294510396.7914.82.camel@obelisk.thedillows.org>
 <4D2B4E13.6070903@mellanox.com>
 <1294686163.3038.12.camel@obelisk.thedillows.org>
 <4D2B64CA.6040609@mellanox.com>
 <1295239821.3051.1.camel@obelisk.thedillows.org>
 <4D35EF9C.3050609@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4D35EF9C.3050609-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Ishai Rabinovitz <ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-01-18 at 11:53 -0800, Vu Pham wrote:
> Our hw/fw guys confirm that there is no problem, my suspect is wrong.
> 
> To explain clearly how hw translate from remote rdma address to physical address in fmr's MTT
> 
> X = requested/rdma_va - MPT.start + MPT.fbo
> MTT index = X / MPT.blocksize
> MTT offset = X % MPT.blocksize
> PA = MTT[index] + MTT offset
> 
> MPT - memory protection table
> MTT - memory translation table

Thanks for following up... unfortunately, we're still in the dark as to
the bug this was intended to solve. :/

And thanks for the information about how the mapping works, that's good
to know.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
