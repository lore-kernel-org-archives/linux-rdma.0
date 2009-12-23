From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Wed, 23 Dec 2009 10:09:44 +0200
Message-ID: <4B31D048.5040001@voltaire.com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Liran Liss wrote:
> >> all the rdmaoe materials saying the lossless traffic class is a 
> must,  are you saying that this works well also  >> without it? then 
> why from  architect point of view you have posed this requirement?
>
> lossless traffic can be achieved today using global pause, for 
> example.  PFC is still important; we will submit initial patches that 
> support it next wee
Liran, I would say that OTOH global pause isn't the way to go and OTHO 
IB RC functions quite bad when many packets are lost. As such RDMAoE 
without PFC and mapping priorities into TCs (the Ethernet VLs) isn't 
really for production, for any non trivial environment involving more 
then one hop. Also, this email is from one month ago, any news on the 
patches?

Yevgeny, I took a look, and there are patches to support pfc for the 
mlx4_en driver, but they were never submitted upstream, which means that 
even if rdmaoe goes upstream, mainline users will not be able even to 
really test it. Also,  the pfc in these patches configuration seems to 
be done with sysfs and not through the Netlink APIs defined in 
include/net/dcbnl.c, did you had any specific reason not to integrate 
with the mainline method of pfc/tc configuration?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
