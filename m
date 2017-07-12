From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Difference between normal and fast memory registration
Date: Wed, 12 Jul 2017 15:22:13 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1707121520050.17315@nuc-kabylake>
References: <CAPO=kN1Qcb8SSvyxGgGPLgYOTGoGnV32RLNJU=f+b9_1aMYdcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPO=kN1Qcb8SSvyxGgGPLgYOTGoGnV32RLNJU=f+b9_1aMYdcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arka Sharma <arka.sw1988-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 10 Jul 2017, Arka Sharma wrote:

> So my question is in case of fast registration when exactly physical
> addresses are written in registers of RNIC card. If it is done in
> initialization as I am thinking by reading this statement, in that
> case the physical location of data buffer to be registered may be
> different with the address that has been programmed to the RNIC. I
> have read in RDMA verbs specification that in case of fast
> registration we need to create a work request and post to SQ. Why this
> kind of approach is needed in case of fast registration.
>
> Some clarification of this will be highly appreciated.

A scan of the paper suggests to me that the authors simply register large
memory regions and then provide slices of that for the application. It is
a "registration cache". The memory is registered in large chunks by the
caching layer and then later small pieces of it are used by the
application. That is faster because the whole area is already registered
and one does not need to register the smaller area.

Nothing changes regarding registration of memory.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
