From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Tue, 22 Dec 2015 13:19:05 -0500
Message-ID: <20151222181905.GA742@phlsvsds.ph.intel.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 22, 2015 at 02:38:10PM +0200, Moni Shoua wrote:
>Hi,
>
>In the past months the need for a kernel module that implements the InfiniBand
>transport in software and unify all the InfiniBand software drivers has
>been raised. Since then, nobody has submitted any design proposal that satisfy
>the initial thoughts and can serve various back-ends.
>
>The following is a RFC that presents a solution made of a single
>generic InfiniBand
>driver and many hardware specific back-end drivers. The RFC defines
>the requirements
>and the interfaces that have to be part of any generic InfiniBand driver.
>A generic InfiniBand driver that is not compliant with this RFC wouldn't be able
>to serve different back-ends and therefore would miss its target.

This makes no mention of the already posted work which aims to consolidate 
the qib and hfi1 drivers verbs implementation. However it does seem to be 
mostly in line with what we have already presented for rdmavt and the 
direction the next set of patches is going in. Have you seen something in 
rdmavt that contradicts this? I have not seen the need to write a detailed 
RFC because it's pretty straight forward what needs to happen. Take the 
common parts of qib and hfi and move to another kmod. Don't do anything that 
prevents soft-roce from using the same infrastructure. I think we are 
accomplishing that and have been very open during the process.

Specifically this RFC does not capture much more detail beyond what has 
already been posted. There are also a number of details regarding hardware 
specifics that are not dealt with here but are in the current rdmavt patch 
series, as well as patches that are yet to be posted. The bottom line is we 
can't sacrifice performance for a perfect API.

Previous discussion threads:
http://marc.info/?l=linux-rdma&m=144353141420065&w=2
http://marc.info/?l=linux-rdma&m=144563342718705&w=2
http://marc.info/?l=linux-rdma&m=144614769419528&w=2

Rdmavt & Qib code submissions:
http://marc.info/?l=linux-rdma&m=144968107508268&w=2
http://marc.info/?l=linux-rdma&m=144952133926970&w=2
Feedback has been received on these patches and unless otherwise noted in 
the relevant threads will be incorporated into the V2 of the patch sets.

hfi1 RFC sent to staging list:
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-December/082896.html

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
