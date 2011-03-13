From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv5 1/2][RESEND] opensm/PerfMgr: Better redirection support
Date: Sun, 13 Mar 2011 17:54:34 +0200
Message-ID: <20110313155434.GA14371@calypso.voltaire.com>
References: <20100617172849.GA17245@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100617172849.GA17245-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: Sasha Khapyorsky <IMCEAEX-_O=VOLTAIRE+20ADVANCED+20DATA+20SECURITY_OU=VOLTAIRE_CN=RECIPIENTS_CN=SASHAK-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20:28 Thu 17 Jun     , Hal Rosenstock wrote:
> 
> Handle PKey and QPN redirection information
> GID redirection handling remains
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v4:
> Fixed some trailing whitespace problems
> 
> Changes since v3:
> Rebased
> 
> Changes since v2:
> Use OpenSM DB rather than vendor layer for local port number and PKeys
> Change most log levels from ERROR to VERBOSE
> Redirection info validity now determined by single flag
> validate_redir_pkey returns pkey index or -1 rather than boolean
> Removed redir_ prefixes
> 
> Changes since v1:
> Added include of osm_helper.h to osm_perfmgr.c
> 

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
