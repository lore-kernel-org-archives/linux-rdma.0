From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1] IB/mad: Add port_num to error message
Date: Thu, 19 Jan 2017 17:05:42 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E3C637198@CRSMSX101.amr.corp.intel.com>
References: <1484837311-13206-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484837311-13206-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Print the invalid port number to ease troubleshooting.
> 
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
> v0 -> v1:
> 	* Fix typo in commit header
> ---
>  drivers/infiniband/core/mad.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c index
> a009f71..57f231f 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -316,7 +316,9 @@ struct ib_mad_agent *ib_register_mad_agent(struct
> ib_device *device,
>  	/* Validate device and port */
>  	port_priv = ib_get_mad_port(device, port_num);
>  	if (!port_priv) {
> -		dev_notice(&device->dev, "ib_register_mad_agent: Invalid
> port\n");
> +		dev_notice(&device->dev,
> +			   "ib_register_mad_agent: Invalid port %d\n",
> +			   port_num);
>  		ret = ERR_PTR(-ENODEV);
>  		goto error1;
>  	}
> --
> 1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
