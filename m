From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] fix libibnetdisc portguid hashing corner
 case
Date: Sun, 18 Apr 2010 19:47:34 +0300
Message-ID: <20100418164734.GM11943@me>
References: <1271267283.17987.120.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271267283.17987.120.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:48 Wed 14 Apr     , Al Chu wrote:
> Hey Sasha,
> 
> This patch fixes a corner case in libibnetdisc that was storing
> portguids w/ a guid of 0.
> 
> This bug was relatively innoucuous for ibnetdiscover b/c ibnetdiscover
> does not output these ports.  However, it became a problem for me in the
> caching library as I attempted to reconstruct a fabric, and multiple
> ports were identifying themselves with identical guids [1].
> 
> Al
> 
> [1] - The fact the caching code assumes duplicate guids can't exist is
> also a bug.  But that's for another patch.  This is a bug by itself.
> 
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory

> Date: Tue, 13 Apr 2010 14:01:43 -0700
> From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Subject: [PATCH] fix libibnetdisc portguid hashing corner case
> Message-Id: <1271264633.17987.112.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
> Mime-Version: 1.0
> Content-Transfer-Encoding: 7bit
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
