From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] cma: resolve to first active IB port
Date: Mon, 12 Dec 2016 09:43:43 +0100
Message-ID: <CAMGffEkgHTKZmVOb2q6jPfC32ofuh=-WNAkE2=VqTN6W0UjV9Q@mail.gmail.com>
References: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg@mail.gmail.com>
 <CAMGffEnBfUnvKFHOKDuzXopa6m63RBOmHRhpeZun-UddXGjzvg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BC8BE@ORSMSX109.amr.corp.intel.com>
 <CAMGffEkGcxdYutV0cZYAzeu_kZOgTmuqTbMNfnPuFbHj+oT+2g@mail.gmail.com>
 <20161209163803.GA31304@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB0BCED3@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BCED3-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 9, 2016 at 6:17 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > Sure, I updated the v2 patch as attached, is this what you want?
>> >
>> > Note: in cma_resolve_loopback, it does the same, I leave it like that
>> > for now, I can also update this part if you like.
>>
>> I feel like we already have a cache for subnet prefix, or maybe
>> another patch series added one? Can't remember, sorry.
>
> Yep - see core/cache.c.
>
> Jinpu, port state caching should go here as well.  If you can update the =
loopback call as well, that would be great.

Thanks Jason and Hefty, good idea!
I will send a patchset to cache port state in cache module, will also
update loopback call as well.

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
