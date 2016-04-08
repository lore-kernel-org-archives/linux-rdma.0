From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 7 Apr 2016 17:13:41 -0700
Message-ID: <CA+55aFyYkGr+LhRj1s5WS_tiZ-aQ=rzg2UHU8FqE=Ot3YnEU8g@mail.gmail.com>
References: <57055BC6.7070402@sandisk.com>
	<5706E548.3080002@sandisk.com>
	<1460072224.18732.67.camel@haakon3.risingtidesystems.com>
	<CA+55aFwOnCeKzg4SuceZm98DgN-tV7aCdtrenAS93LP7GqrZtw@mail.gmail.com>
	<1460073392.18732.83.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460073392.18732.83.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 7, 2016 at 4:56 PM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>
> Yes, I fucked up and am actively fixing the regression.

.. and then you complained when somebody who relies on that driver
wants it *working*.

Really.

I don't know why you and Bart butt heads, but I don't _need_ to know.
If people find major bugs that keep their machines from working and
want them reverted, that's quite understandable.

So I'm going to apply that revert, and I will *not* pull a fix from
you until I hear that the fix actually got tested and has a

   Tested-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

or similar from people who actually have the hardware.

Because bugs happen, and that's life.

But it's _not_ acceptable to complain when a used points out that the
change had no testing what-so-ever, and asks to have it reverted.

If you have a patch to fix it, reply to a revert request with "Here,
try this instead": That's a good approach, and allows the user of that
hardware to continue testing.

But if the change really had zero testing, and broke a driver that
Bart needs to work, then I certainly see why he'd want to have it
reverted.

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
