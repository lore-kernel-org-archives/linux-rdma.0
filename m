From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Thu, 30 Jan 2014 10:19:06 +0200
Message-ID: <52EA0AFA.40100@mellanox.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>	<52CD1C68.4050406@mellanox.com>	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>	<52DBB4F1.4020400@mellanox.com>	<CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>	<CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>	<CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>	<52DF93D3
 .6030509@dev.mellanox.co.il> <CAJZOPZLBECYXrpp0GY0uUvyf+XbiLHhXdVukniPXD4AWZObymg@mail.gmail.com> <52E90C81.9040800@acm.org> <52E91906.70802@dev.mellanox.co.il> <52E940B2.3070901@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E940B2.3070901-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/01/2014 19:56, Bart Van Assche wrote:
> On 01/29/14 16:06, Sagi Grimberg wrote:
>>
>> Didn't understand why should it matter where the copy is done (iser/block)?
> In the Linux kernel community it is considered important to avoid code duplication. Hence the proposal to keep code that copies data buffers in the block layer core and to avoid that such functionality has to be reimplemented in every block driver or SCSI LLD.

Hi Bart,

Thanks for narrowing this down, I see your point, however the solution I 
propose if to remove this copy altogether... for those rare cases where 
fast-registration can't be done -- in SRP I think the code goes to 
indirect mode under which there no copy (right?). As for iSER, we will 
add to our TODO enhancing the code to avoid using bounce-buffer, few 
designs might be possible, one way would be to create set of 
FMRS/Fast-reg element which are capable to map chunks which are < 
PAGE_SIZE, e.g in the order of single block, and hence can map what ever 
arbitrary set of blocks provided by the upper layer.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
