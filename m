From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: add support of reload net topology file
Date: Tue, 2 Mar 2010 18:35:11 +0200
Message-ID: <20100302163511.GL13592@me>
References: <4B7C0256.7080505@voltaire.com>
 <20100227152212.GG13592@me>
 <4B8BDF87.3020107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B8BDF87.3020107-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17:38 Mon 01 Mar     , Eli Dorfman (Voltaire) wrote:
> We can add the trap generation to this patch.
> what do you think?

I think that if you need this feature than it should be implemented
correctly (without assumptions that use can provide a "proper" files),
this should include some sort of connected client handling (in case if
its port disappear it could be disconnected for example).

For me it would seem more like topology "merge" rather then "reload"
feature.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
