From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: libibverbs: Added the man page verbs.7
Date: Sun, 13 Nov 2011 12:50:00 +0100
Message-ID: <CAO+b5-oofUddDi0HScj--wLmZzDcCcfHPmLoAA7ttOC6zP7VFw@mail.gmail.com>
References: <201111101103.41673.dotanb@sw.voltaire.com>
	<CAO+b5-pDo9C4+SZ=wbV9HwKE+yX_-i8EK6oeFSckJwtdFzOE_w@mail.gmail.com>
	<CALvMawoMov=nT_AH0GgA9wE28u9Rybpr=PtK9dwKAKa0FJsO-g@mail.gmail.com>
	<CAO+b5-rAYj1tuDnO2KyTic5DSszpfnRZf1sxvrod0yF1v3Huhw@mail.gmail.com>
	<CALvMawp1C8zNzd2RjTjQTwbCCHsO96dEtNySnS+qxc=tgw7Czw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawp1C8zNzd2RjTjQTwbCCHsO96dEtNySnS+qxc=tgw7Czw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 13, 2011 at 12:29 PM, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Sun, Nov 13, 2011 at 12:23 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> wrote:
>> Maybe the text in parentheses should be changed into a sentence on its
>> own, and maybe it's a good idea to mention that when polling the same CQ
>> from more than one thread that if the order in which CQE's are processed
>> matters that it's the responsibility of the application to enforce that
>> ordering ?
>
> Let's remove the text about the CQ, since i guess that as an example it adds
> complications that i don't want to handle in the introduction for the
> library.
>
> What about this:
>
> This library is a thread safe library and verbs can be called from every
> thread in the process. The same resource can even be handled from different
> threads (the atomicity of the operations is guaranteed). However, it is up
> to the user to stop working with a resource after it was destroyed (by the
> same thread or by any other thread), not doing so may result a segmentation
> fault.

Sounds fine to me.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
