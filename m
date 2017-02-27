From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Tue, 28 Feb 2017 00:11:58 +0200
Message-ID: <CAFgAxU9XJTXkaeL_VE7zHASPBM+j=TZd2L+McKBcJRThJtUN5w@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170227185912.GM5891@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170227185912.GM5891-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "M: Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2017 at 8:59 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Feb 27, 2017 at 06:08:41PM +0200, Alex Rosenbaum wrote:
>
>> In order to prevent resource leak for provider libraries that do not
>> support plugout API, libibverbs will move the relevant ibv_device=E2=80=
=99s
>> to a cached device
>
> We no longer support configurations like this, add the new feature and
> globally update all providers in rdma-core. No hacks to support
> un-updated providers.

This is definitely one approach I was thinking about as well. It will
surely help clean some of the older, not extendible API's.
I'd like to call out to all provide library maintainer. if you have
started code porting from the old ibv_register_driver() to the new
extendible verbs_register_driver() then please move forward with
submitting it. Once using the extendible 'struct verbs_device' it will
be easy to add the new unint_device() functionality to all provided
library in order to support plug-in for all.

Here is the list of the maintainers and provider libraries still use
the old ibv_register_driver():
Steve Wise for CXBG3 & CXBG4
Mike Marciniszyn & Dennis Dalessandro for HF1 and IPATH/QIB
Lijun Ou & Wei Hu(Xavier) for HNS
Tatyana Nikolova for I40IW and NES
Vladimir Sokolovsky, Moni Shoua and Yishai Hadas for MTHCA and RXE
Devesh Sharma for OCRDMA
Ram Amrani & Ariel Elior for QEDR
Adit Ranadive for VMW_PVDRMA


PS: I'll present the verbs hotplug idea in tomorrow's OFVWG call.
See Liran's notice: http://marc.info/?l=3Dlinux-rdma&m=3D148821532209342&w=
=3D2

Cheers,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
