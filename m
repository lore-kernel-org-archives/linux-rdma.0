From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: [PATCH] osmtest/osmtest.c: remove strings.h inclusion
Date: Mon, 12 Oct 2009 15:25:51 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C896BBEE@orsmsx501.amr.corp.intel.com>
References: <4BFF1A3398A74B2AABB948EF2843BF68@amr.corp.intel.com>
	<20091012214054.GH13830@me>
	<3F6F638B8D880340AB536D29CD4C1E1912C896BB77@orsmsx501.amr.corp.intel.com>
	<20091012220740.GM13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091012220740.GM13830@me>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Sasha Khapyorsky <sashak@voltaire.com>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> Remove redundant strings.h inclusion (and associated ifndef __WIN__).
>
> Signed-off-by: Sasha Khapyorsky <sashak@voltaire.com>
> ---
>  opensm/osmtest/osmtest.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
> index 3618ea3..f0f23c7 100644
> --- a/opensm/osmtest/osmtest.c
> +++ b/opensm/osmtest/osmtest.c
> @@ -46,9 +46,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#ifndef __WIN__
> -#include <strings.h>
> -#endif
>  #include <sys/time.h>
>  #include <complib/cl_debug.h>
>  #include "osmtest.h"

Looking better all the time...
