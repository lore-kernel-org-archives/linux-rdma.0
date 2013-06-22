From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/qib: add optional numa affinity
Date: Sat, 22 Jun 2013 23:45:40 +0300
Message-ID: <CAJZOPZLpODnwMfiupoBH4FjanUmpo-e1SdTH9H1a2FwP8pAUXw@mail.gmail.com>
References: <20130528165733.30588.71366.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130528165733.30588.71366.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> This patch adds context relative numa affinity conditioned on the
> module parameter numa_aware. The qib_ctxtdata has an additional
> node_id member and qib_create_ctxtdata() has an addition node_id parameter.

Could you elaborate why making numa awareness be conditioned on module
parameter?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
