From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Mellanox target workaround in SRP
Date: Fri, 07 Jan 2011 20:05:49 -0800
Message-ID: <adaipy09h0i.fsf@cisco.com>
References: <1294439717.6219.54.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294439717.6219.54.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org> (David Dillow's
	message of "Fri, 07 Jan 2011 17:35:17 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, mst-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, ishai-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > I'm sure this was tested and shown to fix the problem; I'm just confused
 > as to what the problem really was and if this is still relevant. Can
 > someone please enlighten me?

At this point I'm afraid it's all lost in the mists of time, but the
original patch seems to have come from

http://lists.openfabrics.org/pipermail/general/2006-July/024322.html

looking at the patch, I would guess that the corruption occurred when
the target got an IO request that started at a non-page-aligned address
but that spanned more than one page.

I don't know if the target was ever fixed, or whether that target code
has any relevance today.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
