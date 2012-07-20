From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: mlx4_ib_create_qp failed - OOM with call trace
Date: Fri, 20 Jul 2012 09:47:40 +0200
Message-ID: <50090D1C.6040500@profitbricks.com>
References: <5006BF13.50405@profitbricks.com> <CAL1RGDX6+NZ_ZJ+TLOMBaVdyM0wd6BjCEHwwAYCVODY4Cfkm4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDX6+NZ_ZJ+TLOMBaVdyM0wd6BjCEHwwAYCVODY4Cfkm4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 19.07.2012 22:31, Roland Dreier wrote:
> I have to think about the best way to fix this.  We could just
> convert to vmalloc() here but I'm not thrilled about consuming
> vmalloc() space (on modern 64-bit architectures it's a non-issue
> but it's going to cause issues for people on smaller systems).

This is at least something we can implement and test for us as we only
have modern server systems.

Thank you very much for the information and your help!

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
