From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] split out scan specific data from
 ibnd_node_t [attempt #2]
Date: Sun, 15 Nov 2009 13:44:41 +0200
Message-ID: <20091115114441.GY7192@me>
References: <1258134736.31785.297.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1258134736.31785.297.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:52 Fri 13 Nov     , Al Chu wrote:
> This splits out some scan specific data from ibnd_node_t that doesn't
> need to be in the public struct.
> 
> Al
> 
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory

> From 75f819d436218be0c9bab7d0a6e763b4054748dd Mon Sep 17 00:00:00 2001
> From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Date: Thu, 29 Oct 2009 18:59:26 -0700
> Subject: [PATCH] split out scan specific data from ibnd_node_t
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
