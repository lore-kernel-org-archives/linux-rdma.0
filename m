From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 1/8] infiniband-diags: Obfuscate sensitive output by
 default
Date: Thu, 31 May 2012 07:48:29 -0400
Message-ID: <4FC75A8D.4080305@dev.mellanox.co.il>
References: <1338398414.11948.29.camel@auk75.llnl.gov> <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398497-12444-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, weiny2-i2BcT+NCU+M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/30/2012 1:21 PM, Jim Foraker wrote:
> Cause security credentials to not be displayed by default. Instead,
> the "-K" flag is supported, which must be passed to the command
> to display valid results.
> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  doc/rst/common/opt_K.rst  |    4 +++
>  doc/rst/saquery.8.in.rst  |    2 ++
>  doc/rst/smpquery.8.in.rst |    2 ++
>  include/ibdiag_common.h   |    9 ++++++
>  src/ibaddr.c              |    2 +-
>  src/ibcacheedit.c         |    2 +-
>  src/ibccconfig.c          |    2 +-
>  src/ibccquery.c           |    2 +-
>  src/ibdiag_common.c       |   71 +++++++++++++++++++++++++++++++++++++++++++++
>  src/iblinkinfo.c          |    2 +-
>  src/ibnetdiscover.c       |    2 +-
>  src/ibping.c              |    2 +-
>  src/ibqueryerrors.c       |    2 +-
>  src/ibroute.c             |    2 +-
>  src/ibsendtrap.c          |    2 +-
>  src/ibstat.c              |    2 +-
>  src/ibsysstat.c           |    2 +-
>  src/ibtracert.c           |    2 +-
>  src/perfquery.c           |    2 +-
>  src/saquery.c             |   66 ++++++++++++++++++++---------------------
>  src/sminfo.c              |    2 +-
>  src/smpdump.c             |    2 +-
>  src/smpquery.c            |    6 ++--
>  src/vendstat.c            |    2 +-
>  24 files changed, 139 insertions(+), 55 deletions(-)
>  create mode 100644 doc/rst/common/opt_K.rst

Do all these tools display keys ? AFAIK ibping, ibstat, ibsysstat,
perfquery, and vendstat don't.

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
