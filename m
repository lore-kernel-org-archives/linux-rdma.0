From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH][TRIVIAL] infiniband-diags/ibqueryerrors.c: Fix typo in
 help
Date: Thu, 16 Jun 2011 14:27:19 -0700
Message-ID: <20110616142719.25ce237c.weiny2@llnl.gov>
References: <4DFA6D1B.6020303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA6D1B.6020303-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, applied,
Ira

On Thu, 16 Jun 2011 13:52:43 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 0147d9c..1bba0e0 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -858,7 +858,7 @@ int main(int argc, char **argv)
>  		{"report-port", 'r', 0, NULL,
>  		 "report port configuration information"},
>  		{"threshold-file", 8, 1, NULL,
> -		 "specify an alternate thresold file, default: " DEF_THRES_FILE},
> +		 "specify an alternate threshold file, default: " DEF_THRES_FILE},
>  		{"GNDN", 'R', 0, NULL,
>  		 "(This option is obsolete and does nothing)"},
>  		{"data", 2, 0, NULL, "include data counters for ports with errors"},


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
