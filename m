From: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] opensm: removed unnecessary checks in main()
Date: Mon, 7 Mar 2011 10:00:48 -0500
Message-ID: <20110307150047.GA6591@redhat.com>
References: <20110307100146.GI5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110307100146.GI5577-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 07, 2011 at 12:01:46PM +0200, Alex Netes wrote:
> Variable temp is unsigned.
> 
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  opensm/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/main.c b/opensm/main.c
> index 756fe6f..ef4b805 100644
> --- a/opensm/main.c
> +++ b/opensm/main.c
> @@ -987,7 +987,7 @@ int main(int argc, char *argv[])
>  			break;
>  		case 6:
>  			temp = strtol(optarg, NULL, 0);
> -			if (temp < 0 || temp >= IB_MAX_NUM_VLS) {
> +			if (temp >= IB_MAX_NUM_VLS) {
>  				fprintf(stderr,
>  					"ERROR: starting lash vl must be between 0 and 15\n");
>  				return -1;
> @@ -997,7 +997,7 @@ int main(int argc, char *argv[])
>  			break;
>  		case 7:
>  			temp = strtol(optarg, NULL, 0);
> -			if (temp < 0 || temp > 15) {
> +			if (temp > 15) {
>  				fprintf(stderr,
>  					"ERROR: SM's SL must be between 0 and 15\n");
>  				return -1;
> -- 
> 1.7.3.4
> 
> --

strtol() returs a long, not unsigned, therefor either temp must be
changed to match (and keep the < 0 tests) or a different function must
be used (strtoul()?).

			-- JF
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
