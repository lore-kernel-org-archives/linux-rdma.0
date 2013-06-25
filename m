From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 10/15 ibacm] Add the ability to preload the destination
 GID and LID caches
Date: Tue, 25 Jun 2013 23:41:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD36C84@ORSMSX109.amr.corp.intel.com>
References: <51C432BC.9020706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C432BC.9020706-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Preloading of these caches is supported via a file which is
> produced by OpenSM by the dump_pr plugin which contains
> sufficient SA PathRecord information. Details on this
> file format and configuring OpenSM for this are found in
> dump_pr_notes.txt in dump_pr.
> 
> File format is specified in ibacm_opts.cfg as follows:
> path_rec_fnt full_opensm_v1
> 
> To preload these caches, ibacm service is started with -p option
> which can also take optional path_rec_file which defaults to
> ACM_CONF_DIR/ibacm_path_records.dump

I would rather use the config file versus adding command line parameters.

This series will preload the cache, but it does not change the actual protocol ibacm uses for updates.   I want to verify that this is your intent.  I see within this patch that you override the address and route timeout values set by the user.  I think the code should honor those settings.

I wonder if it would make sense to treat file loading as a 'protocol' rather than a preload of the cache.  By changing the timeout value, this is essentially what occurs.  If the cached data can timeout, then there's an option for what ibacm should do.  If it falls back to its configured address/route protocols, then this is truly a preload of the cache.  An alternate option would be for ibacm to see if the input files had been updated, and if so, reload its cache.

One drawback I see with using this as a simple preload mechanism is that the entire cache would timeout at once if cache timeouts are enabled.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
