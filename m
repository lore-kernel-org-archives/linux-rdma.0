From: Fab Tillier <ftillier@microsoft.com>
Subject: Re: [PATCH] libdat v2.0: memory leak in static registration
 during parsing
Date: Tue, 7 Dec 2010 21:35:54 +0000
Message-ID: <91B583BE4B6FCD408F53D1B8F537E09212A09114@TK5EX14MBXW601.wingroup.windeploy.ntdev.microsoft.com>
References: <E3280858FA94444CA49D2BA02341C983011E66B8E8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <E3280858FA94444CA49D2BA02341C983011E66B8E8@orsmsx506.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Davis, Arlin R" <arlin.r.davis@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
Cc: "King, Perry E." <perry.king@ngc.com>
List-Id: linux-rdma@vger.kernel.org

Davis, Arlin R wrote on Mon, 6 Dec 2010 at 16:22:50
> 
> the platform_params char string, allocated when parsing dat.conf, is
> not freed.
> 
> Signed-off-by: Arlin Davis <arlin.r.davis@intel.com>
> ---
>  dat/udat/udat_sr_parser.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/dat/udat/udat_sr_parser.c b/dat/udat/udat_sr_parser.c
> index 3b5caef..1d5f0d8 100644
> --- a/dat/udat/udat_sr_parser.c
> +++ b/dat/udat/udat_sr_parser.c
> @@ -492,6 +492,12 @@ DAT_RETURN dat_sr_parse_entry(DAT_OS_FILE * file)
>  					    1));
>  	}
> 
> +	if (NULL != entry.platform_params) {

Yoda logic here you have.

-Fab

> +		dat_os_free(entry.platform_params,
> +			    sizeof(char) *
> +			    (dat_os_strlen(entry.platform_params) +  1));
> +	}
> +
>  	return status;
>  }
> 
> --
> 1.7.3
> 
> 
> 
> _______________________________________________
> ofw mailing list
> ofw@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
