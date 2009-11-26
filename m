From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/3] use nodes/switches lists
 instead of nodesdist array in libibnetdiscover
Date: Thu, 26 Nov 2009 19:08:04 +0200
Message-ID: <20091126170804.GN13817@me>
References: <1258481840.1335.96.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1258481840.1335.96.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:17 Tue 17 Nov     , Al Chu wrote:
> Hey Sasha,
> 
> I noticed that that 'nodesdist' array was used for going through only
> switches or all nodes in the fabric.  Spoke to Ira about it, and he
> believes it's b/c in early ibnetdiscover code the 'nodesdist' array was
> the only data structure available for iterating over nodes.  Now we can
> use the 'nodes' list or 'switches' list, which makes it clearer to
> understand what's going on and is probably the "right" data structure to
> now use.  It also makes the chassis code section not dependent on the
> scan specific chunks of libibnetdiscover.
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
> Date: Mon, 16 Nov 2009 17:14:56 -0800
> Subject: [PATCH] use nodes/switches lists instead of nodesdist array
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
