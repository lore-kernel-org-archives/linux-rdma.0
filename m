From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCHv2 0/4] IB cache port state, use it when resolve address
Date: Fri, 13 Jan 2017 10:04:28 +0100
Message-ID: <CAMGffEkMrg6iHmFBRghmQHXA2kY5eCwJS2WX=fEH2Z=Sg2=GiQ@mail.gmail.com>
References: <CAMGffE=-dN6jpJUHyNEHra1P=SLYiO47pMbMoKSNf6Njy=znKA@mail.gmail.com>
 <CAMGffE=xA9GMMWAKPMzAtWxHBSbBVft04LjB+fhc0mLRjmEXfQ@mail.gmail.com> <1484280123.123135.55.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484280123.123135.55.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 13, 2017 at 5:02 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2017-01-11 at 13:26 +0100, Jinpu Wang wrote:
>> On Mon, Jan 2, 2017 at 1:15 PM, Jinpu Wang <jinpu.wang@profitbricks.c
>> om> wrote:
>> >
>> > Hi Folks,
>> >
>> > This is my forth attempt to fix rdma_revolve_addr may resolve to
>> > first
>> > port even it's down[1].
>> >
>> > As Jason and Hefty suggested, I now cache port_state in ib_core,
>> > and
>> > update cma_resolve_ib_dev and cma_bind_loopback to use it.
>> >
>> > 0001-IB-core-add-port-state-cache.patch
>> > 0002-IB-core-export-ib_get_cached_port_state.patch
>> > 0003-cma-resolve-to-first-active-ib-port.patch
>> > 0004-cma-use-cached-port-state-when-bind-loopback.patch
>> >
>> > [1]http://marc.info/?l=3Dlinux-rdma&m=3D148102306632521&w=3D2
>> >
>> > Changes from v1:
>> > - Add Hefty's Acked-by.
>> > - rebase on Doug's rdma/k.o/for-4.10 (commit
>> > 5cc8fabc5e4c588c75a5ec21423e7c3425f69f48)
>> > - fix a mem leak in ib_cache_setup_one in error case in first
>> > patch.
>> >
>> > --
>> Ping Doug?
>
> Sorry, I didn't see this before I wrote my last email.  You've already
> captured Sean's acks, that's good.  You modified the first patch in a
> way that negates the comment request I made, so that's fine.  But the
> patches are still coming through mangled.  If you look at them in
> patchworks, you can see telltale signs, such as seeing part of the
> patch in the patchwork comments and then the full patch later on in the
> patch section.  When I download those patches, they are mangled.  You
> can *not* both send the patch inline and as an attachment.  The
> prefered way to send patches, if your mailer is messing with your
> submissions, is to use "git send-email" and let it send the patches
> directly for you.
>
> However, this time I have fixed the patches up and applied them, but
> please don't send mangled patches like this in the future.
>
Thanks Doug for taking care of the format.
I will definitely will configure and my email client properly when send pat=
ch
to mainline.
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
