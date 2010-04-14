From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [0/3] support --diff and --diffcheck in
 ibnetdiscover
Date: Wed, 14 Apr 2010 12:54:52 +0300
Message-ID: <20100414095452.GQ10830@me>
References: <1270659929.26381.38.camel@crazyclimber.llnl.gov>
 <20100413130803.GG10830@me>
 <20100413131033.GH10830@me>
 <1271179075.17987.94.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271179075.17987.94.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:17 Tue 13 Apr     , Al Chu wrote:
> 
> I had considered this at one point.  There were several reasons I
> decided to go w/ the cache idea.  Perhaps the major reason is that the
> current cache system has "all" the data (nodeinfo, portinfo, etc.)
> saved, whereas the normal ibnetdiscover output does not. So we would be
> limited in our diff output for what ibnetdiscover outputs (or perhaps
> limited in future extensions).  Adding a --diff into iblinkinfo is also
> on my list to do, but that wouldn't be possible w/ a cached text output
> (the cached text file doesn't store portinfo data).

That makes sense.

> This isn't to say there are downsides.  The major downside is that it's
> difficult to edit the cache when minor changes happen on the network
> (e.g. for our system administrators, when an HCA is replaced b/c a node
> dies). I have a tool for that (to be submitted soon too I hope :-).

It is difficult to edit and difficult to read. So I would really prefer
to have a text file (even with extended format). But well, let's see how
this will go.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
