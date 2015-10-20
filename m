From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Tue, 20 Oct 2015 19:42:25 +0300
Message-ID: <CAJ3xEMiM1VRCOZwVtMR2=3dmBi_DmOA3yhPas5TqBtaFCdzH-A@mail.gmail.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
	<CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
	<561E510C.8060501@redhat.com>
	<CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
	<56266C4B.1060000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56266C4B.1060000-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2015 at 7:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/20/2015 12:25 PM, Or Gerlitz wrote:
>> On Wed, Oct 14, 2015 at 3:56 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On 10/14/2015 12:51 AM, Or Gerlitz wrote:
>>>> On Sun, Oct 11, 2015 at 11:58 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> Hi Doug,
>>>>> As we're soon on 4.3-rc5, could you please update how things look for 4.4?
>>>>>
>>>>> The mutlicast loopback prevention patches from Eran were intially
>>>>> posted ~two months ago and went through testing by Christoph and Co.
>>>> [...]
>>
>>
>>>> Hi Doug,
>>
>>>> So we're after rc5 and not a single word from you re the plans for the
>>>> next kernel, and your branch for that purpose contains exactly two patches... I do
>>>> see few chunks
>>>> of patches marked as under review in your patchworks, so there might
>>>> be sign for getting some hope, is that real?
>>
>>> Yes Or, I'm working on it.  A new 4.3-rc pull request should come out
>>> today and an update on the for next area probably as well.

>> Doug,
>> So we're after rc6 and still pretty much nothing in your for-4.4
>> branch, are we getting there
>> (e.g picking something from the backlog such as the self multicast
>> loopback prevention and the
>> rdma-cm name space patches) or for 4.4 we'd be coming naked?

> Another pull request for the final 4.3 fixups will go in today.  I
> prioritized those over the for-next work.
> Next I'll be pulling simple for-next items, then I'll be reviewing the

Sounds good as a starter

> then I'll be reviewing the
> RoCE GID cadche usage in verbs/cma v2 patchset, then the Add RoCE v2
> support v1 patchset, then the New fast registration API v5 set.

Doug, the New fast registration API v5 set has E2E community consensus,
I guess there's not much left for you to dig there, so these are good news.

As for the RoCE patches, you mentioned reviewing them, this is going to
take time, which makes sense. However, the self-multicast loopback prevention
patches are (1) sitting in the mailing list for months (2) small in
volume and very large
in benefit (3) passed testing by Christoph and Co, any reason not to
pick them prior
to review of the RoCE code.

We need to encourage developers to take part in the upstream process,
For this series
I am clueless towards the developers where they ask me what's missing?
why this isn't
moving for months?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
