From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/qib: add optional numa affinity
Date: Thu, 27 Jun 2013 13:29:16 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2115B106@FMSMSX107.amr.corp.intel.com>
References: <20130528165733.30588.71366.stgit@phlsvslse11.ph.intel.com>
 <CAJZOPZLpODnwMfiupoBH4FjanUmpo-e1SdTH9H1a2FwP8pAUXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLpODnwMfiupoBH4FjanUmpo-e1SdTH9H1a2FwP8pAUXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or,

Sorry for the delay.

The maximum performance differs from CPU to CPU.

The module parameter was chosen to avoid CPU family tests, which didn't seem like a good idea.

Mike

> -----Original Message-----
> From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Saturday, June 22, 2013 4:46 PM
> To: Marciniszyn, Mike
> Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] IB/qib: add optional numa affinity
> 
> Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >
> > From: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > This patch adds context relative numa affinity conditioned on the
> > module parameter numa_aware. The qib_ctxtdata has an additional
> > node_id member and qib_create_ctxtdata() has an addition node_id
> parameter.
> 
> Could you elaborate why making numa awareness be conditioned on module
> parameter?
> 
> Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
