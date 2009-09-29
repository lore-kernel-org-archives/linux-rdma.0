From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: [ofa-general] Re: [PATCH] infiniband-diags/src/ibqueryerrors.c: fix
 bug when attempting a sub-fabric scan
Date: Tue, 29 Sep 2009 17:41:45 +0200
Message-ID: <20090929154145.GA9465@me>
References: <20090923144555.9efa2c75.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <20090923144555.9efa2c75.weiny2@llnl.gov>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Ira Weiny <weiny2@llnl.gov>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, OpenFabrics <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

On 14:45 Wed 23 Sep     , Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2@llnl.gov>
> Date: Wed, 23 Sep 2009 14:26:55 -0700
> Subject: [PATCH] infiniband-diags/src/ibqueryerrors.c: fix bug when attempting a sub-fabric scan
> 
> 	Also ibd_sm_id is never valid in this tool as the "-s" option is used
> 	for "suppress"
> 
> Signed-off-by: Ira Weiny <weiny2@llnl.gov>
> ---
>  infiniband-diags/src/ibqueryerrors.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
> index f73ca6f..892e539 100644
> --- a/infiniband-diags/src/ibqueryerrors.c
> +++ b/infiniband-diags/src/ibqueryerrors.c
> @@ -441,8 +441,8 @@ int main(int argc, char **argv)
>  	} else if (switch_guid_str) {
>  		if ((resolved =
>  		     ib_resolve_portid_str_via(&portid, switch_guid_str,
> -					       IB_DEST_GUID, ibd_sm_id,
> -					       ibmad_port)) >= 0)
> +					       IB_DEST_GUID, NULL,

BTW, why should 'ibd_sm_id' be replaced by NULL?

Sasha

> +					       ibmad_port)) < 0)
>  			IBWARN("Failed to resolve %s; attempting full scan\n",
>  			       switch_guid_str);
>  	}
> -- 
> 1.5.4.5
> 
