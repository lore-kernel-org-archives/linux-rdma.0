From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Wed, 23 Dec 2015 18:28:08 +0200
Message-ID: <CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
	<20151222181905.GA742@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151222181905.GA742-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>
> This makes no mention of the already posted work which aims to consolidate
> the qib and hfi1 drivers verbs implementation. However it does seem to be
> mostly in line with what we have already presented for rdmavt and the
> direction the next set of patches is going in. Have you seen something in
> rdmavt that contradicts this? I have not seen the need to write a detailed
> RFC because it's pretty straight forward what needs to happen. Take the
> common parts of qib and hfi and move to another kmod. Don't do anything that
> prevents soft-roce from using the same infrastructure. I think we are
> accomplishing that and have been very open during the process.
>
> Specifically this RFC does not capture much more detail beyond what has
> already been posted. There are also a number of details regarding hardware
> specifics that are not dealt with here but are in the current rdmavt patch
> series, as well as patches that are yet to be posted. The bottom line is we
> can't sacrifice performance for a perfect API.
>
> Previous discussion threads:
> http://marc.info/?l=linux-rdma&m=144353141420065&w=2
> http://marc.info/?l=linux-rdma&m=144563342718705&w=2
> http://marc.info/?l=linux-rdma&m=144614769419528&w=2
>
> Rdmavt & Qib code submissions:
> http://marc.info/?l=linux-rdma&m=144968107508268&w=2
> http://marc.info/?l=linux-rdma&m=144952133926970&w=2
> Feedback has been received on these patches and unless otherwise noted in
> the relevant threads will be incorporated into the V2 of the patch sets.
>

Hi Denny

http://marc.info/?l=linux-rdma&m=144614769419528&w=2 introduced a
concept (RVT) which was never followed by a discussion and never
agreed upon. Moreover,
http://marc.info/?l=linux-rdma&m=144952098726776&w=2 presents a work
that besides keeping the name RVT is far from the immature concept I
mentioned earlier and its scope was changed from general purpose
solution to Intel and HFI/QIB only. I therefore conclude that the
concept of RVT, as it was supposed to be, was abandoned.

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
