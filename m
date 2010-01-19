From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: clarification on the mlx4 CQE structure
Date: Tue, 19 Jan 2010 16:08:43 +0200
Message-ID: <4B55BCEB.5080006@Voltaire.com>
References: <Pine.LNX.4.64.1001191416160.22919@zuben.voltaire.com> <2ED289D4E09FBD4D92D911E869B97FDD02783427@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD02783427-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yevgeny Petrilin wrote:
> This commit has an endianess bug, that was fixed in commit f781a22f.
> The cqe->sl_vid field is a be16, so we needed to convert the sl value to
> host order. Before the commit this field was two u8 fields, so no conversion was needed

okay, got it, thanks 

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
