From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [infiniband-diags PATCH 4/4] A few typo fixes in the manpages
Date: Mon, 26 Sep 2016 00:56:59 -0400
Message-ID: <20160926045659.GD29780@phlsvsds.ph.intel.com>
References: <20160905214910.GA9795@pryan.ekaia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905214910.GA9795-2v28OwtJ5VXkvb5ro2YpKQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ana Guerrero =?iso-8859-1?Q?L=F3pez?= <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 05, 2016 at 11:49:10PM +0200, Ana Guerrero López wrote:
> They have been detected by lintian, the Debian package checker
> 
> Signed-off-by: Ana Guerrero López <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>

Thanks Applied,
Ira

> ---
>  doc/rst/iblinkinfo.8.in.rst       | 4 ++--
>  doc/rst/ibqueryerrors.8.in.rst    | 2 +-
>  doc/rst/infiniband-diags.8.in.rst | 4 ++--
>  doc/rst/rdma-ndd.8.in.rst         | 4 ++--
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/doc/rst/iblinkinfo.8.in.rst b/doc/rst/iblinkinfo.8.in.rst
> index ee2aefb..5f87f37 100644
> --- a/doc/rst/iblinkinfo.8.in.rst
> +++ b/doc/rst/iblinkinfo.8.in.rst
> @@ -57,7 +57,7 @@ The node to start a partial scan can be specified with the following addresses.
>  
>  **--switch, -S <port_guid>** same as "-G". (provided only for backward compatibility)
>  
> -How much of the scan to be printed can be controled with the following.
> +How much of the scan to be printed can be controlled with the following.
>  
>  **--all, -a**
>  Print all nodes found in a partial fabric scan.  Normally a
> @@ -81,7 +81,7 @@ Filter downports indicated in a ibnetdiscover cache.  If a port was previously
>  indicated as down in the specified cache, and is still down, do not output it in the
>  resulting output.  This option may be particularly useful for environments
>  where switches are not fully populated, thus much of the default iblinkinfo
> -info is considered unuseful.  See **ibnetdiscover** for information on caching
> +info is considered useless.  See **ibnetdiscover** for information on caching
>  ibnetdiscover output.
>  
>  
> diff --git a/doc/rst/ibqueryerrors.8.in.rst b/doc/rst/ibqueryerrors.8.in.rst
> index df2901c..0a7992b 100644
> --- a/doc/rst/ibqueryerrors.8.in.rst
> +++ b/doc/rst/ibqueryerrors.8.in.rst
> @@ -63,7 +63,7 @@ using a QoS aware routing engine as it can cause a credit deadlock.
>  
>  **CAUTION** clearing data or error counters will occur regardless of if they
>  are printed or not.  See **--counters** and **--data** for details on
> -controling which counters are printed.
> +controlling which counters are printed.
>  
>  **--details** include receive error and transmit discard details
>  
> diff --git a/doc/rst/infiniband-diags.8.in.rst b/doc/rst/infiniband-diags.8.in.rst
> index 7776a30..be77ce3 100644
> --- a/doc/rst/infiniband-diags.8.in.rst
> +++ b/doc/rst/infiniband-diags.8.in.rst
> @@ -120,8 +120,8 @@ Switch Forwarding Table info
>  
>  	See: ibtracert, ibroute, dump_lfts, dump_mfts, check_lft_balance, ibfindnodesusing
>  
> -Peformance counters
> --------------------
> +Performance counters
> +--------------------
>  
>  	See: ibqueryerrors, perfquery
>  
> diff --git a/doc/rst/rdma-ndd.8.in.rst b/doc/rst/rdma-ndd.8.in.rst
> index 708a5ab..1d126db 100644
> --- a/doc/rst/rdma-ndd.8.in.rst
> +++ b/doc/rst/rdma-ndd.8.in.rst
> @@ -27,7 +27,7 @@ those changes.
>  DETAILS
>  =======
>  
> -Full operation of this deamon requires kernels which support polling of the
> +Full operation of this daemon requires kernels which support polling of the
>  procfs hostname file as well as libudev.
>  
>  If your system does not support either of these features, the daemon will set
> @@ -37,7 +37,7 @@ the Node Descriptions at start up and then sleep forever.
>  Node Description format
>  -----------------------
>  
> -The deamon uses the nd_format configuration option within the ibdiags.conf
> +The daemon uses the nd_format configuration option within the ibdiags.conf
>  file.  %h and %d can be used as wildcards in that string to specify the dynamic
>  use of <hostname> and <device> respectively.
>  
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
