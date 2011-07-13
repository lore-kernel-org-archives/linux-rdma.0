From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Wed, 13 Jul 2011 10:48:37 -0600
Message-ID: <20110713164837.GH10216@obsidianresearch.com>
References: <20110710120442.GA11284@localhost.localdomain>
 <20110712162740.29e2d7d1.weiny2@llnl.gov>
 <20110712235222.GG10216@obsidianresearch.com>
 <20110712165817.16076a3d.weiny2@llnl.gov>
 <20110713041441.GA26663@obsidianresearch.com>
 <20110713082640.GA2024@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110713082640.GA2024-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2011 at 11:26:40AM +0300, Alex Netes wrote:
> @@ -407,6 +408,10 @@ This option defines the file name for the extra configuration
>  information needed for the torus-2QoS routing engine.   The default
>  name is \fB\%@OPENSM_CONFIG_DIR@/@TORUS2QOS_CONF_FILE@\fP
>  .TP
> +\fB\-\-pid_file\fR <path to pid file>
> +Specifies the file that contains the process ID of the opensm daemon.
> +The default is \fB/var/run/opensm.pid\fP
> +.TP

Should use a configure substitution for /var/run/opensm.pid here..

> +	printf("--pid_file <path to file>\n"
> +	       "          Specifies the file that contains the process ID of the\n"
> +	       "          opensm daemon.The default is /var/run/opensm.pid\n");

And this should be OSM_DEFAULT_PID_FILE

> +	if (opt.daemon) {
> +		FILE *f = fopen(opt.pid_file, "w");

Need a "wt" in case the file already exists

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
