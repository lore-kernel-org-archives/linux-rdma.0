From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMA mini-summit during LPC 2017
Date: Wed, 30 Aug 2017 14:39:40 +0530
Message-ID: <CANjDDBiYaY36mcFr30gtSYauCjrgWrPTY89VoNv7ub2TY_CXDw@mail.gmail.com>
References: <20170403180820.GS20443@mtr-leonro.local> <20170404062141.GA8886@lst.de>
 <alpine.DEB.2.20.1704041016260.23821@east.gentwo.org> <1501642385.2800.2.camel@wdc.com>
 <20170802034102.GU13672@mtr-leonro.local> <1501710141.16387.1.camel@wdc.com> <20170803052049.GG13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803052049.GG13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon et. al,

Is there a possibility of arranging a webex for those who want to join
but unable to attend due to various reasons.

-Regards
Devesh

On Thu, Aug 3, 2017 at 10:50 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Aug 02, 2017 at 09:42:24PM +0000, Bart Van Assche wrote:
>> On Wed, 2017-08-02 at 06:41 +0300, Leon Romanovsky wrote:
>> > On Wed, Aug 02, 2017 at 02:53:05AM +0000, Bart Van Assche wrote:
>> > > On Tue, 2017-04-04 at 10:17 -0500, Christoph Lameter wrote:
>> > > > On Tue, 4 Apr 2017, Christoph Hellwig wrote:
>> > > > > unfortunately LPC is at the same time as SNIA SDC, so I won't be able
>> > > > > to make it.
>> > > >
>> > > > Well jet over from SFO to LAX late Thursday or so and join us on Friday.
>> > >
>> > > I plan to attend the RDMA mini-summit.
>> >
>> > Thanks Bart,
>> >
>> > Will you be able to drive topics raised by Sagi?
>> >
>> >  1. Adding NUMA hints to *all* rdma resources.
>> >  2. SRQ sizing. No one knows what is a correct SRQ size.
>> >  3. Adaptive interrupt moderation.
>> >  4. Striding receive queue in core API
>> >
>> > IMHO, 1 and 3 have right audience during the conference.
>> >
>> > http://wiki.linuxplumbersconf.org/2017:rdma#proposed_schedule_tentative
>>
>> Hello Leon,
>>
>> If someone can help me with taking notes during the discussion I can drive one
>> of these topics. Personally I'm most interested in [1] and [4].
>
> 4 is also fine, Liran, Tzahi and Jason will be at that minisummit, so
> I'm sure that it will lead to a fruitful discussion.
>
> Regarding notes, It is my lesson-learned from the previous year.
> My initial thoughts were to bring sound recorder, record everything,
> convert to the notes with Mechanical Turk [1] and post it here after
> internal review.
>
> [1] https://www.mturk.com/mturk/welcome
>
>>
>> Best regards,
>>
>> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
