From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm - address windows env issues
Date: Tue, 25 May 2010 21:58:58 +0300
Message-ID: <20100525185858.GZ28549@me>
References: <4A4BD5F425D5495387BA92964E2873C8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4A4BD5F425D5495387BA92964E2873C8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:03 Tue 25 May     , Stan C. Smith wrote:
> 
> Add a Windows version of truncate_log_file().
> Use the Windows flavor of vsprintf().
> 
> Would you prefer items of this nature as two separate patches?

That is fine so.

> thanks,
> 
> stan.
> 
> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied. Thanks.


> 
> --- a/opensm/osm_log.c	2010-05-22 05:49:24.000000000 -0700
> +++ b/opensm/osm_log.c	2010-05-24 11:40:07.823895800 -0700

Please next time generate patches at top level of management tree,
eg a/opensm/opensm/osm_log.c ... (It took couple of minutes for me to
figure out why it doesn't apply this time :))

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
