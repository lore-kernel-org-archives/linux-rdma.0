From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: libibverbs: Added the man page verbs.7
Date: Thu, 10 Nov 2011 12:13:30 +0100
Message-ID: <CAO+b5-qowK0AhCgReEhqvjrSndhfhnOFdBZT4=2gUtcw-wwibw@mail.gmail.com>
References: <201111101103.41673.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111101103.41673.dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 10, 2011 at 10:03 AM, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> +This library is thread safe library and verbs can be called from every thread in the process (the

Looks like "a" is missing between "is" and "thread safe" ?

> +However, it is up to the user to stop working with a resource after it was destroyed (by the same thread or by any other thread), this may result a segmentation fault.

", this" -> ". Not doing so" ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
