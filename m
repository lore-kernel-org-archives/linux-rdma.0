From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Thu, 24 Dec 2009 14:49:24 +0200
Message-ID: <4B336354.2060305@voltaire.com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com><4B31D048.5040001@voltaire.com><adahbrh1yd0.fsf@roland-alpha.cisco.com><15ddcffd0912231412y8f6724fh5a7036f30117189e@mail.gmail.com>	<adad42519n5.fsf@roland-alpha.cisco.com> <2ED289D4E09FBD4D92D911E869B97FDD0222EFDF@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD0222EFDF-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Liran Liss wrote:
> I second...
>   
fair-enough, so now (A) everyone agrees that DCB is good for IBoE and 
(B) mlx4 supports pfc, any reason not to push the pfc patches into the 
kernel and have mlx4_en comply with the mainline dcbnl code?
> The only way an end-node can cause congestion is if its internal buses don't match the IB link's BW, but this is unrelated to (lack of) transport-level flow control.
>   
thanks for clarifying this

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
