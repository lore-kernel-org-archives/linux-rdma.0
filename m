From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [1/2] fix libibnetdisc cache error path
 memleak
Date: Mon, 19 Apr 2010 17:56:43 +0300
Message-ID: <20100419145643.GN11943@me>
References: <1271285269.17987.139.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271285269.17987.139.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:47 Wed 14 Apr     , Al Chu wrote:
> Hey Sasha,
> 
> This patch fixes a mem-leak through error paths in the libibnetdisc
> cache loading.  If some data had not yet been "copied over" to the
> fabric struct and an error occurred, that memory would be leaked.
> 
> Al
> 
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory

> Date: Wed, 14 Apr 2010 14:11:27 -0700
> From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Subject: [PATCH] fix libibnetdisc cache error path memleak
> Message-Id: <1271284770.17987.131.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
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
