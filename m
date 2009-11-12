From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_mgr.c: fix return value on
 alloc_mfts() failures
Date: Thu, 12 Nov 2009 03:56:15 +0200
Message-ID: <20091112015615.GB7192@me>
References: <20091111183317.GX7192@me>
 <f0e08f230911111225k4b1c30c0y44c13d950d9555b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230911111225k4b1c30c0y44c13d950d9555b6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:25 Wed 11 Nov     , Hal Rosenstock wrote:
> 
> Yes, that fixes the return value but nothing (at least currently)
> takes advantage of that. Is that the next step ?

Yes, it should be done this way.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
