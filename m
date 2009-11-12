From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH 1/2] consistently type lids and lmcs
 libibnetdisc
Date: Fri, 13 Nov 2009 01:01:41 +0200
Message-ID: <20091112230141.GB7192@me>
References: <1257531261.18550.69.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1257531261.18550.69.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:14 Fri 06 Nov     , Al Chu wrote:
> Hey Sasha,
> 
> The ibnd_port_t lid and lmc are typed uint16_t/uint8_t, but the
> ibnd_node_t smalid and smalmc are typed int/int.  This patch turns the
> ints into uint16_t/uint8_t.
> 
> Naturally, we can do the opposite, but it should be consistent one way
> or the other.
> 
> Al
> 
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory

> From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Date: Thu, 5 Nov 2009 14:58:11 -0800
> Subject: [PATCH] consistently type lids and lmcs libibnetdisc
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
