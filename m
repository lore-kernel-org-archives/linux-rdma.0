From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Add update_desc command to opensm console
Date: Wed, 13 Jan 2010 19:26:16 +0200
Message-ID: <20100113172616.GM574@me>
References: <4B4C3386.5040205@gmail.com>
 <20100112121423.GA574@me>
 <4B4DE7F5.3020407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B4DE7F5.3020407-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:34 Wed 13 Jan     , Eli Dorfman (Voltaire) wrote:
> 
> Sometimes nodes are discovered by the opensm with their default
> name before real host name was resolves and updated in the HCA.
> Since Mellanox ConnectX HCA do not support NodeDescription
> change trap (as part of trap 144) we need an option to refresh
> NodeDescription from console.
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
