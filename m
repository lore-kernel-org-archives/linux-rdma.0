From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ib/mgmt: fix build under windows stack
Date: Wed, 9 Jun 2010 09:48:00 +0300
Message-ID: <20100609064800.GA20172@me>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F462DED@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F462DED-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:15 Wed 02 Jun     , Hefty, Sean wrote:
> Fix warnings in windows build.
> 
> These are typecasts in several places, with a couple additional changes
> needed to libibnetdisc.  Windows uses ISO definitions instead of
> POSIX definitions, so calls like _read, _write, etc. are used on
> Windows instead of read, write.  The result is that internal functions
> are renamed with an ibnd prefix.
> 
> In order to handle ibdebug exported from libibmad, Windows need to mark
> the variable as a 'dllexport' from libibmad, but as 'dllimport' for users.
> Since libibnetdisc wants to 'dllimport' ibdebug from libibmad, while
> 'dllexporting its own functions, it requires a separate 'MAD_EXPORT' like
> definition to allow this.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
