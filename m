From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 47/49] IB/hfi1: add multicast routines
Date: Mon, 15 Jun 2015 12:24:43 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506151222560.20941@east.gentwo.org>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com> <20150615133012.29741.61892.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615133012.29741.61892.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ummm... This looks eerily similar to qib_verbs_mcast.c. Sed job on the
file? Is there any way to get a description as to what the differences are
between qib and hfi?

Can you just use the same file?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
