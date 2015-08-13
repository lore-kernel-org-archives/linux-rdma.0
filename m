From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 4/8 v2] IB/odp/hmm: prepare for HMM code path.
Date: Thu, 13 Aug 2015 14:13:35 -0600
Message-ID: <20150813201335.GA22581@obsidianresearch.com>
References: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
 <1439493653-1191-5-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439493653-1191-5-git-send-email-jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 13, 2015 at 03:20:49PM -0400, J=E9r=F4me Glisse wrote:
 =20
> +#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
> +#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */

Yuk, what is wrong with

 #if !IS_ENABLED(...)

?

> -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> +#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)
> +#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
> +#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */

Double yuk

 #if !(IS_ENABLED(..) && IS_ENABLED(..))

?

And the #ifdefs suck, as many as possible should be normal if
statements, and one should think carefully if we really need to remove
fields from structures..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
