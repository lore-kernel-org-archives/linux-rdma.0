From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Reduce heap consumption by unicast routing
 tables  (LFTs)
Date: Thu, 1 Oct 2009 05:56:46 +0200
Message-ID: <20091001035646.GE17846@me>
References: <20090927193258.GG26931@me>
 <1719052465.9944581254135649449.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
 <f0e08f230909301138y64595e9dj47bdec4a47d80f99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230909301138y64595e9dj47bdec4a47d80f99-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14:38 Wed 30 Sep     , Hal Rosenstock wrote:
> 
> The config options would not be needed but build options might be.
> That would depend on whether you want the current behavior (allocation
> during osm_switch_new) preserved or not. Do you ?

I don't see yet any reason to keep this (assuming that LFT buffer
allocation is moving to ucast_mgr), as well as a build option.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
