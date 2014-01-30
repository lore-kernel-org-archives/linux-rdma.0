From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Thu, 30 Jan 2014 12:38:54 +0200
Message-ID: <52EA2BBE.8060904@mellanox.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>	<52CD1C68.4050406@mellanox.com>	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>	<52DBB4F1.4020400@mellanox.com>	<CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>	<CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>	<CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>	<52DF93D3.6030509@dev.mellanox.co.il> <CAJZOPZLBECYXrpp0GY0uUvyf+XbiLHhXdVukni
 PXD4AWZObymg@mail.gmail.com> <52E90C81.9040800@acm.org> <52E91906.70802@dev.mellanox.co.il> <52E940B2.3070901@acm.org> <52EA0AFA.40100@mellanox.com> <52EA2465.8010907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52EA2465.8010907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30/01/2014 12:07, Bart Van Assche wrote:
> On 01/30/14 09:19, Or Gerlitz wrote:
>> Thanks for narrowing this down, I see your point, however the solution I
>> propose if to remove this copy altogether... for those rare cases where
>> fast-registration can't be done -- in SRP I think the code goes to
>> indirect mode under which there no copy (right?). As for iSER, we will
>> add to our TODO enhancing the code to avoid using bounce-buffer, few
>> designs might be possible, one way would be to create set of
>> FMRS/Fast-reg element which are capable to map chunks which are <
>> PAGE_SIZE, e.g in the order of single block, and hence can map what ever
>> arbitrary set of blocks provided by the upper layer.
> I'm not sure how important this issue is on x86 systems since the page
> size on these systems is 4 KB and since many applications use an I/O
> size >= 4 KB. So if the I/O buffers are aligned on page boundaries the
> buffer memory can be registered as a single memory region without having
> to copy any data. However, on PPC systems, which have a page size of 64
> KB, if e.g. a database issues a readv() or writev() call or if an I/O
> scheduler coalesces several small I/O requests into a single I/O request
> the data buffer of these I/O requests is discontiguous. I think it is
> important that data copying can be avoided for such I/O requests.

We know that... and hence iser uses fast registration in chucks of 4KB 
even when the page size is 64KB

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
