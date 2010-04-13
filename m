From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [0/3] support --diff and --diffcheck in
 ibnetdiscover
Date: Tue, 13 Apr 2010 16:10:33 +0300
Message-ID: <20100413131033.GH10830@me>
References: <1270659929.26381.38.camel@crazyclimber.llnl.gov>
 <20100413130803.GG10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413130803.GG10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16:08 Tue 13 Apr     , Sasha Khapyorsky wrote:
> 
> Would it be better to keep cache in a regular human readable
> ibnetdiscover output format, so '--diff' will be usable not just against
> cache, but also against a regular ibnetdiscover output files?

BTW, such implementation could be simplified by the fact that we have
already ibnetdiscover output parser in 'ibsim'.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
