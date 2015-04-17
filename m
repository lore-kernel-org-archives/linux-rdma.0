From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4
 changes in virtual GID management)
Date: Fri, 17 Apr 2015 14:15:53 +0300
Message-ID: <CAJ3xEMiBN-af7Dcem4yoPYBv9uFN5D6+s_C30EjCs-N+Y-JHsw@mail.gmail.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FC0120@ORSMSX109.amr.corp.intel.com>
	<1428858993.3470.12.camel@dworkin>
	<20150413164238.GB17521@obsidianresearch.com>
	<4EC214DA-97F8-4BCD-AEA6-6FB539E820F1@redhat.com>
	<20150414234258.GA25810@phlsvsds.ph.intel.com>
	<232BEA5DF26EF54583B8B332938DD0B84BB8E335@CMEXMB1.ad.emulex.com>
	<F6B0F954-1E60-4CE9-AF39-7A6E8C8EC47B@redhat.com>
	<20150416201310.GA24838@obsidianresearch.com>
	<CAJ3xEMizgYb2DfbJxTCb2=zYQA60p5LfeJQ+TJuBa6HnWKvMCQ@mail.gmail.com>
	<20150416213726.GA26437@obsidianresearch.com>
	<1429221799.2980.488.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429221799.2980.488.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 17, 2015 at 1:03 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> On Thu, 2015-04-16 at 15:37 -0600, Jason Gunthorpe wrote:
>> On Fri, Apr 17, 2015 at 12:26:47AM +0300, Or Gerlitz wrote:
>> > On Thu, Apr 16, 2015 at 11:13 PM, Jason Gunthorpe
>> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > > On Wed, Apr 15, 2015 at 08:39:13AM -0400, Doug Ledford wrote:
>> > >
>> > >> Let=E2=80=99s take this as a starting point.  If there are othe=
r patches
>> > >> people think should make 4.1, please bring them to my attention=
 and
>> > >> I=E2=80=99ll add them for review and possible addition to the l=
ist.
>> > >>
>> > >> git://github.com/dledford/linux.git for-4.1
>> > >
>> > > I noticed a few patches didn't get Reviewed-By's etc from the ma=
iling
>> > > list annotated..
>> >
>> > Every patch need not have a Reviewed-By annotation, it's perfectly=
 up
>> > to the maintainer judgement to make sure there was either consensu=
s,
>>
>> More clearly: There were several patches where a Reviewed-By/etc was
>> *provided* on-list but did not get captured in the git commit.
>
> Sure, that's what I figured you meant.  That most likely means that I
> pulled the bundle from patchworks before their review was captured.  =
It
> means I would need to either re-pull the bundle or manually add the
> review.
>
>> AFAIK, capturing provided tags is considered best practice as a way =
to
>> recognize and retain contributors.
>
> Agreed.  I'll double check them tomorrow.

Doug,

Seems like Roland isn't around to carry the rdma pull request for 4.1 .=
=2E.

I assume the most safe way to do that would be ask Dave Miller to pull
the patches from your tree into net-next ASAP, next, have them sit
there for 1-2 days to pass linux-next etc auto merge tests, and then
have Dave to send a pull request. Dave, I hope it would be OK from you
to help us here with the 4.1-rc1 bits. For 4.2 and 4.1-rc > 1 Doug
will should be ready for sending pull request directly to Linus.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
