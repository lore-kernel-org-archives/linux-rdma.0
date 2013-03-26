From: Grant Grundler <grundler-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: odd use of WARN_ON() in ib_srpt.c
Date: Tue, 26 Mar 2013 14:54:50 -0700
Message-ID: <CANEJEGss9WBy3WDWmNUjjJr5kOagSmC5QdPkb6xc6Uo1Xg=ahQ@mail.gmail.com>
References: <CANEJEGvArsbMitJENhFQ4HPCfmAC=PGz4_J2d9JmJVQS4eKiUg@mail.gmail.com>
	<CAL1RGDXzyFA-gAVMVeOgFM_n8puskMiN7o_ObQ=Qr9vPdCSGTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXzyFA-gAVMVeOgFM_n8puskMiN7o_ObQ=Qr9vPdCSGTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 26, 2013 at 1:34 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
...
>> This "works" but intent is more obvious with something like:
>>     WARN(1, "Unexpected command state (%d)", state);
>
> Agree, that would be nicer for debugging if this ever triggers.

Thanks. I just tried to send as a properly formatted patch. Prod me if
I messed that up.

cheers,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
