From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB: new module params. cm_response_timeout,
 max_cm_retries
Date: Mon, 10 Sep 2012 19:11:25 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8CC0A@ORSMSX101.amr.corp.intel.com>
References: <1346861254-8614-1-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346861254-8614-1-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Create two kernel parameters, in order to make variables configurable.
> i.e. cma_cm_response_timeout for CM response timeout,
>      and cma_max_cm_retries for the number of retries.
> 
> They can now be configured via command line for the kernel modules.
> For example:
>     # modprobe ib_srp cma_cm_response_timeout=30 cma_max_cm_retries=60

Rather than using a module parameter, I'd rather see this these values be controlled through /proc/sys/net/rdma_cm, similar to how the rdma_ucm handles max_backlog.  For the rdma_cm, I also prefer something more generic.  CM retries is fine, but exposing wonky IB timeout (4.096 x 2^X us) to the user is less than ideal.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
