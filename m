From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Wed, 29 Jan 2014 18:34:34 +0200
Message-ID: <52E92D9A.70402@mellanox.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>	<52CD1C68.4050406@mellanox.com>	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>	<52DBB4F1.4020400@mellanox.com>	<CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>	<CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>	<CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>	<52DF93D3
 .6030509@dev.mellanox.co.il> <CAJZOPZLBECYXrpp0GY0uUvyf+XbiLHhXdVukniPXD4AWZObymg@mail.gmail.com> <52E90C81.9040800@acm.org> <52E91906.70802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E91906.70802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/01/2014 17:06, Sagi Grimberg wrote:
> Non-contiguous buffers are a well known problem/challenge for RDMA 
> transports, each handles them differently: iSER uses bounce buffers, 
> SRP registers multiple contiguous regions.

To be precise, we do it only on very special cases, normally the payload 
**each** SCSI command of size > PAGE_SIZE is scattered between random 
set of pages allocated by the kernel buffer cache and this set is mapped 
through fast-reg or fmr mechanism to one RDMA virtual address.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
