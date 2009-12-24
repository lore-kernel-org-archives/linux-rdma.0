From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMAoE / lossless Ethernet (ewg: SC'09 BOF - Meeting notes)
Date: Thu, 24 Dec 2009 14:25:49 +0200
Message-ID: <4B335DCD.4080201@voltaire.com>
References: <2ED289D4E09FBD4D92D911E869B97FDD01AF10F2@mtlexch01.mtl.com>	<4B31D048.5040001@voltaire.com> <adahbrh1yd0.fsf@roland-alpha.cisco.com>	<15ddcffd0912231412y8f6724fh5a7036f30117189e@mail.gmail.com> <adad42519n5.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adad42519n5.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Sure, DCB is very useful, in many environments. And maybe even a requirement sometimes.  I'm simply trying to say that IBoE with classical ethernet is at least as useful as standard IB in many cases
Roland, Paul,

Putting a side for a moment the detailed discussion we've started and 
looking on the concluding remarks you have made, I wasn't sure to 
follow:  if DCB isn't available (even from a silly reason of hw 
supporting pfc but patches not being pushed to the kernel...) what you 
think would function better (or function at all) for IBoE, lossy or 
globally paused Ethernet? I haven't managed so far to convince you that 
both aren't applicable for IBoE, but I also didn't manage to see what 
are you suggesting in the absence of DCB.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
