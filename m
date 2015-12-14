From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Mon, 14 Dec 2015 10:06:27 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512141005010.25235@east.gentwo.org>
References: <20151211182532.332343651@linux.com> <20151211182543.329283794@linux.com> <CAAKD3BAT36BGP+21y9oz1E4EuURFuwiAHi558ho8y+k3GEy4Ww@mail.gmail.com> <alpine.DEB.2.20.1512140853510.25000@east.gentwo.org>
 <CAAKD3BC+DTMpza8WoshBS5SwzzWz-OMiR-KEegKAcrFYpCfqrg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BC+DTMpza8WoshBS5SwzzWz-OMiR-KEegKAcrFYpCfqrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 14 Dec 2015, Matan Barak wrote:

> > No idea what the counter is doing. Saw another EXT counter implementation
> > use 0 so I thought that was fine.
>
> It seems like a counter index, but I might be wrong though. If it is,
> don't we want to preserve the existing non-EXT schema for the new
> counters too?

I do not see any use of that field so I am not sure what to put in there.
Could it be obsolete?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
