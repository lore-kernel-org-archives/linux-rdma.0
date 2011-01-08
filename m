From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Mellanox target workaround in SRP
Date: Sat, 08 Jan 2011 13:13:16 -0500
Message-ID: <1294510396.7914.82.camel@obelisk.thedillows.org>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>
	 <adaipy09h0i.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaipy09h0i.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2011-01-07 at 20:05 -0800, Roland Dreier wrote:
> > I'm sure this was tested and shown to fix the problem; I'm just confused
>  > as to what the problem really was and if this is still relevant. Can
>  > someone please enlighten me?
> 
> At this point I'm afraid it's all lost in the mists of time,

Yep, that's my fear. And since it is a corruption bug, I've got to tread
lightly in this area. :/

> looking at the patch, I would guess that the corruption occurred when
> the target got an IO request that started at a non-page-aligned address
> but that spanned more than one page.

That's my thought as well, but then I'm not sure this really solved
their problem. It may be more likely to occur in the FMR case, but the
initiator enables clustering, so blk_rq_map_sg() could generate the same
kinds of requests for both direct and indirect descriptors, even without
FMR. This looks to have been true since the initiator was added to the
kernel, though it is possible I'm misreading the code.

> I don't know if the target was ever fixed, or whether that target code
> has any relevance today.

Here's hoping someone from Mellanox can shed some light.

Thanks!
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
