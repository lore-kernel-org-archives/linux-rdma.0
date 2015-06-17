From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 47/49] IB/hfi1: add multicast routines
Date: Wed, 17 Jun 2015 12:14:50 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25751484@fmsmsx120.amr.corp.intel.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
 <20150615133012.29741.61892.stgit@phlsvslse11.ph.intel.com>
 <alpine.DEB.2.11.1506151222560.20941@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1506151222560.20941-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Ummm... This looks eerily similar to qib_verbs_mcast.c. Sed job on the file? Is
> there any way to get a description as to what the differences are between qib
> and hfi?
> 

We are working  on what can be said on OPA and the hardware.

We chose to impact qib as little as possible with this driver development.

There are differences in the verbs layer associated with the hardware and future work that will make that even more the case.

A future work could create a combined driver.

Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
