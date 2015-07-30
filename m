From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Thu, 30 Jul 2015 15:37:24 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507301535340.6551@east.gentwo.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730191631.25256.95511.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 30 Jul 2015, Mike Marciniszyn wrote:

> As a verbs driver the device functions as an InfiniBand device and
> supports the standard features of the IBTA specification v1.3 with
> the exceptions noted below.

Hmmm... So OPA networks and IB networks (Truescale?) will be able to
interoperate?

> The public information can be reviewed at:
>
> http://www.intel.com/content/www/us/en/omni-path/omni-path-fabric-overview.html

That is very helpful although I have to guess what the various marketing
terms mean. Is there more detail on NICs and switch specifications
available?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
