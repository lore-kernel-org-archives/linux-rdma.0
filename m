From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: odd use of WARN_ON() in ib_srpt.c
Date: Tue, 26 Mar 2013 13:34:34 -0700
Message-ID: <CAL1RGDXzyFA-gAVMVeOgFM_n8puskMiN7o_ObQ=Qr9vPdCSGTA@mail.gmail.com>
References: <CANEJEGvArsbMitJENhFQ4HPCfmAC=PGz4_J2d9JmJVQS4eKiUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANEJEGvArsbMitJENhFQ4HPCfmAC=PGz4_J2d9JmJVQS4eKiUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Grundler <grundler-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 25, 2013 at 4:48 PM, Grant Grundler <grundler-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Stumbled across this in 3.4 kernel but still exists in 3.9-rc3:
>
> fgrep -n WARN_ON ./drivers/infiniband/ulp/srpt/ib_srpt.c
> ...
> 1377:           WARN_ON("ERROR: unexpected command state");
> ...
>
> This "works" but intent is more obvious with something like:
>     WARN(1, "Unexpected command state (%d)", state);

Agree, that would be nicer for debugging if this ever triggers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
