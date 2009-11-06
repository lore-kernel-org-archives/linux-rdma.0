From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [1/2] remove ibnd_update_node
Date: Fri, 6 Nov 2009 19:00:16 +0200
Message-ID: <20091106170016.GI7192@me>
References: <1257190397.580.30.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1257190397.580.30.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:33 Mon 02 Nov     , Al Chu wrote:
> Hey Sasha,
> 
> After talking to Ira about it, we think it's best remove
> ibnd_update_node.
> 
> A) It's not being used.
> B) It probably not implemented properly
> C) Some of Ira's original plans for its use require more API functions
> to be added, which of course isn't done right now.
> 
> So for now, it seems best to just remove it since it's an additional
> API function that can lead to confusion.
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
> Date: Thu, 29 Oct 2009 18:56:32 -0700
> Subject: [PATCH] remove ibnd_update_node
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Also removing its man page and libibnetdisc.map entry.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
