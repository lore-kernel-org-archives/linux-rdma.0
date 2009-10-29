From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] remove 'dist' field from
 ibnd_node_t, which was virtually not used
Date: Thu, 29 Oct 2009 23:39:18 +0200
Message-ID: <20091029213918.GH20136@me>
References: <1256773931.4819.192.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1256773931.4819.192.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16:52 Wed 28 Oct     , Al Chu wrote:
> Remove the 'dist' field from the ibnd_node_t struct and rearch code
> appropriately.  It ends up this field was only used to pass a value from
> create_node() to add_to_nodedist(), of which create_node() is the only
> function that calls add_to_nodedist().  In other words, it served pretty
> much no purpose.
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
> Date: Wed, 28 Oct 2009 16:18:39 -0700
> Subject: [PATCH] remove 'dist' field from ibnd_node_t, which was virtually not used
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
