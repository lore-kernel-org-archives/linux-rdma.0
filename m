From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] osmtest - Add OSM_CDECL to main() declaration
Date: Mon, 12 Oct 2009 23:43:22 +0200
Message-ID: <20091012214322.GI13830@me>
References: <41F5872023464A3C8FD5828F037B4D77@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <41F5872023464A3C8FD5828F037B4D77@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Stan C. Smith" <stan.smith@intel.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 10:10 Mon 12 Oct     , Stan C. Smith wrote:
> 
> 
> Signed-off-by: stan smith <stan.smith@intel.com>
> 
> diff --git a/opensm/osmtest/main.c b/opensm/osmtest/main.c
> index 4bb9f82..287baf3 100644
> --- a/opensm/osmtest/main.c
> +++ b/opensm/osmtest/main.c
> @@ -285,7 +285,7 @@ ib_net64_t get_port_guid(IN osmtest_t * p_osmt, uint64_t port_guid)
>  
>  /**********************************************************************
>   **********************************************************************/
> -int main(int argc, char *argv[])
> +int OSM_CDECL main(int argc, char *argv[])

Hmm, why is this needed? AFAIK most of infiniband-diags tools were
ported to windows without adding such special declaration for main()
functions.

Sasha

>  {
>  	static osmtest_t osm_test;
>  	osmtest_opt_t opt = { 0 };
> 
