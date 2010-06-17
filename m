From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] [RESEND] opensm/osm_trap_rcv.c: No need for heavy
 sweep when just NodeDescription changes
Date: Thu, 17 Jun 2010 17:01:56 +0300
Message-ID: <20100617140156.GF20172@me>
References: <20100614111148.GA25056@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100614111148.GA25056-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07:11 Mon 14 Jun     , Hal Rosenstock wrote:
> 
> For trap 144s which indicate NodeDescription changed, there is no need for
> a heavy sweep if that is the only change indicated by the trap. Determine that
> by checking that there are no other change flags set and that the 
> capability mask is unchanged. Still sweep if this is not the case (there
> is some other change).
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
